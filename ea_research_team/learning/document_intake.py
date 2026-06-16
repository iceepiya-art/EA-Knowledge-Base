import os
import json
import sys
import argparse
from pathlib import Path

from local_evidence_intake import import_local_evidence
from structured_extractor import extract_raw_notes, StructuredExtractionStore

WORKSPACE_DIR = Path("G:/My Drive/save log-blueprint-skill/EA-Knowledge-Base")
MANIFEST_FILE = WORKSPACE_DIR / "data" / "raw" / "document_manifest.json"
SUPPORTED_EXTS = {".pdf", ".txt", ".md", ".docx", ".csv"}

import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def log(msg):
    print(f"[DocumentIntake] {msg}")
    sys.stdout.flush()

def load_manifest():
    if MANIFEST_FILE.exists():
        with open(MANIFEST_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {"processed_hashes": {}}

def save_manifest(manifest):
    MANIFEST_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(MANIFEST_FILE, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)

def discover_documents(root_dir: Path):
    found = []
    for ext in SUPPORTED_EXTS:
        found.extend(list(root_dir.rglob(f"*{ext}")))
    return found

def main():
    parser = argparse.ArgumentParser(description="Document Intake Pipeline")
    parser.add_argument("--root", type=str, required=True, help="Root directory to scan for documents")
    parser.add_argument("--limit", type=int, default=5, help="Number of documents to process in this batch")
    args = parser.parse_args()

    root_dir = Path(args.root)
    if not root_dir.exists():
        log(f"Root directory {root_dir} does not exist.")
        sys.exit(1)

    manifest = load_manifest()
    processed_hashes = manifest["processed_hashes"]

    documents = discover_documents(root_dir)
    pending_docs = [doc for doc in documents if str(doc.resolve()) not in processed_hashes]

    log(f"Found {len(documents)} total documents. {len(pending_docs)} pending processing.")

    if not pending_docs:
        log("No pending documents found. Exiting.")
        sys.exit(0)

    batch = pending_docs[:args.limit]
    log(f"Processing batch of {len(batch)} documents...")

    import google.generativeai as genai
    gemini_key = os.environ.get("GEMINI_API_KEY")
    if gemini_key:
        genai.configure(api_key=gemini_key)
        # We pass a dummy client to signal to use Gemini inside structured_extractor
        llm_client = "GEMINI_ENABLED"
    else:
        llm_client = None

    raw_dir = WORKSPACE_DIR / "ea_research_team" / "raw" / "local"

    success_count = 0
    for doc in batch:
        log(f"Importing: {doc.name}")
        try:
            # 1. Import Local Evidence (creates raw .md note)
            result = import_local_evidence(source_path=str(doc), raw_dir=raw_dir)
            if result.get("status") == "raw_evidence_written":
                log(f"Successfully extracted text to raw note: {result['note_path']}")
                success_count += 1
            else:
                log(f"Failed to extract text from {doc.name}: {result.get('transcription_error')}")
            
            # Mark as processed regardless to avoid infinite loop on broken files
            processed_hashes[str(doc.resolve())] = {
                "status": result.get("status"),
                "note_path": result.get("note_path")
            }
        except Exception as e:
            log(f"Error importing {doc.name}: {e}")
            processed_hashes[str(doc.resolve())] = {
                "status": "error",
                "error": str(e)
            }

    save_manifest(manifest)
    
    if success_count > 0:
        log("Extracting structured knowledge via LLM...")
        # 2. Extract structured knowledge from the raw notes in the local dir
        store = StructuredExtractionStore(WORKSPACE_DIR / "ea_research_team" / "learning" / "structured_extractions.json")
        extract_result = extract_raw_notes(raw_dir=raw_dir, store=store, llm_client=llm_client)
        log(f"Structured Extraction Result: {extract_result}")

if __name__ == "__main__":
    main()
