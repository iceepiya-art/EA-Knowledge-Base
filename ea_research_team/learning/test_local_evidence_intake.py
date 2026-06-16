import pathlib
import json

from channel_intake import main
from local_evidence_intake import import_local_evidence, transcribe_video_audio
from structured_extractor import StructuredExtractionStore, extract_raw_notes


def test_import_text_file_writes_raw_evidence_note(tmp_path):
    source = tmp_path / "smc_notes.txt"
    source.write_text(
        "Use FVG retest with CHoCH confirmation for entry. Stop loss below wick.",
        encoding="utf-8",
    )

    result = import_local_evidence(source, raw_dir=tmp_path / "raw" / "local")

    note_path = pathlib.Path(result["note_path"])
    content = note_path.read_text(encoding="utf-8")
    assert result["status"] == "raw_evidence_written"
    assert result["source_type"] == "local_text"
    assert "source_type: local_text" in content
    assert "FVG retest" in content
    assert "## Fact / Transcript Evidence" in content


def test_import_text_file_strips_utf8_bom(tmp_path):
    source = tmp_path / "drive_note.txt"
    source.write_text(
        "Drive note: enter after CHoCH and FVG retest.",
        encoding="utf-8-sig",
    )

    result = import_local_evidence(source, raw_dir=tmp_path / "raw" / "local")

    content = pathlib.Path(result["note_path"]).read_text(encoding="utf-8")
    fact_section = content.split("## Fact / Transcript Evidence", 1)[1].split("## Interpretation", 1)[0]
    assert "\ufeff" not in fact_section
    assert fact_section.strip().startswith("Drive note:")


def test_import_video_file_uses_same_stem_text_sidecar(tmp_path):
    source = tmp_path / "SMC.mp4"
    source.write_bytes(b"fake video bytes")
    sidecar = tmp_path / "SMC.txt"
    sidecar.write_text("Pattern W entry after liquidity sweep.", encoding="utf-8")

    result = import_local_evidence(source, raw_dir=tmp_path / "raw" / "local")

    content = pathlib.Path(result["note_path"]).read_text(encoding="utf-8")
    assert result["status"] == "raw_evidence_written"
    assert result["source_type"] == "local_video"
    assert result["text_source"] == str(sidecar)
    assert "Pattern W entry" in content
    assert "- Text captured: yes" in content


def test_import_video_without_sidecar_uses_auto_transcriber(tmp_path):
    source = tmp_path / "SMC.mp4"
    source.write_bytes(b"fake video bytes")

    def transcriber(path):
        assert path == source
        return "Auto transcript: enter after CHoCH and FVG retest."

    result = import_local_evidence(
        source,
        raw_dir=tmp_path / "raw" / "local",
        video_transcriber=transcriber,
    )

    content = pathlib.Path(result["note_path"]).read_text(encoding="utf-8")
    assert result["status"] == "raw_evidence_written"
    assert result["source_type"] == "local_video"
    assert result["text_source"] == "auto_transcription"
    assert result["text_captured"] is True
    assert "Auto transcript" in content
    assert "text_source: auto_transcription" in content
    assert "- Text captured: yes" in content


def test_import_video_prefers_sidecar_over_auto_transcriber(tmp_path):
    source = tmp_path / "SMC.mp4"
    source.write_bytes(b"fake video bytes")
    sidecar = tmp_path / "SMC.txt"
    sidecar.write_text("Sidecar transcript wins.", encoding="utf-8")
    calls = []

    def transcriber(path):
        calls.append(path)
        return "Auto transcript should not be used."

    result = import_local_evidence(
        source,
        raw_dir=tmp_path / "raw" / "local",
        video_transcriber=transcriber,
    )

    content = pathlib.Path(result["note_path"]).read_text(encoding="utf-8")
    assert calls == []
    assert result["text_source"] == str(sidecar)
    assert "Sidecar transcript wins." in content
    assert "Auto transcript should not be used." not in content


def test_import_image_without_text_marks_needs_text(tmp_path):
    source = tmp_path / "setup.png"
    source.write_bytes(b"fake image bytes")

    result = import_local_evidence(source, raw_dir=tmp_path / "raw" / "local")

    content = pathlib.Path(result["note_path"]).read_text(encoding="utf-8")
    assert result["status"] == "needs_text"
    assert result["source_type"] == "local_image"
    assert "source_type: local_image" in content
    assert "- Text captured: no" in content
    fact_section = content.split("## Fact / Transcript Evidence", 1)[1].split("## Interpretation", 1)[0]
    assert fact_section.strip() == ""


def test_import_image_without_sidecar_uses_auto_text_extractor(tmp_path):
    source = tmp_path / "setup.png"
    source.write_bytes(b"fake image bytes")

    def extractor(path):
        assert path == source
        return "Image OCR: liquidity sweep into order block."

    result = import_local_evidence(
        source,
        raw_dir=tmp_path / "raw" / "local",
        image_text_extractor=extractor,
    )

    content = pathlib.Path(result["note_path"]).read_text(encoding="utf-8")
    assert result["status"] == "raw_evidence_written"
    assert result["source_type"] == "local_image"
    assert result["text_source"] == "auto_image_text"
    assert result["text_captured"] is True
    assert "Image OCR" in content
    assert "text_source: auto_image_text" in content
    assert "- Text captured: yes" in content


def test_import_image_prefers_sidecar_over_auto_text_extractor(tmp_path):
    source = tmp_path / "setup.png"
    source.write_bytes(b"fake image bytes")
    sidecar = tmp_path / "setup.md"
    sidecar.write_text("Sidecar chart description wins.", encoding="utf-8")
    calls = []

    def extractor(path):
        calls.append(path)
        return "Auto image text should not be used."

    result = import_local_evidence(
        source,
        raw_dir=tmp_path / "raw" / "local",
        image_text_extractor=extractor,
    )

    content = pathlib.Path(result["note_path"]).read_text(encoding="utf-8")
    assert calls == []
    assert result["text_source"] == str(sidecar)
    assert "Sidecar chart description wins." in content
    assert "Auto image text should not be used." not in content


def test_reimport_media_with_text_updates_existing_empty_note(tmp_path):
    source = tmp_path / "chart.png"
    source.write_bytes(b"fake image bytes")
    first = import_local_evidence(source, raw_dir=tmp_path / "raw" / "local")

    second = import_local_evidence(
        source,
        raw_dir=tmp_path / "raw" / "local",
        text="Enter after liquidity sweep and CHoCH confirmation.",
    )

    content = pathlib.Path(first["note_path"]).read_text(encoding="utf-8")
    assert first["note_path"] == second["note_path"]
    assert second["status"] == "raw_evidence_written"
    assert "liquidity sweep" in content
    assert "- Text captured: yes" in content


def test_import_text_note_can_be_extracted_by_existing_pipeline(tmp_path, monkeypatch):
    monkeypatch.delenv("GEMINI_API_KEY", raising=False)
    source = tmp_path / "trade_rule.md"
    source.write_text(
        "Enter after BOS and FVG retest. Place stop loss below the sweep wick.",
        encoding="utf-8",
    )
    import_local_evidence(source, raw_dir=tmp_path / "raw" / "local")

    store = StructuredExtractionStore(tmp_path / "structured.json")
    result = extract_raw_notes(raw_dir=tmp_path / "raw" / "local", store=store)

    data = json.loads((tmp_path / "structured.json").read_text(encoding="utf-8"))
    assert result["written"] == 1
    item = next(iter(data["items"].values()))
    assert any("FVG" in concept for concept in item["concepts"])
    assert item["ea_rule_candidates"]["entry"]


def test_import_local_cli_writes_note(tmp_path):
    source = tmp_path / "manual.txt"
    source.write_text("Buy only after CHoCH confirmation.", encoding="utf-8")
    raw_dir = tmp_path / "raw" / "local"

    exit_code = main(["import-local", str(source), "--raw-dir", str(raw_dir)])

    notes = list(raw_dir.glob("*.md"))
    assert exit_code == 0
    assert len(notes) == 1
    assert "CHoCH confirmation" in notes[0].read_text(encoding="utf-8")


def test_transcribe_video_audio_respects_configured_engine_order(tmp_path, monkeypatch):
    source = tmp_path / "SMC.mp4"
    source.write_bytes(b"fake video bytes")
    calls = []

    def faster_whisper(path):
        calls.append("faster_whisper")
        return ""

    def gemini(path):
        calls.append("gemini")
        return "Gemini should not be called"

    def whisper_cli(path):
        calls.append("whisper_cli")
        return "Local CLI transcript"

    monkeypatch.setenv("ORCA_TRANSCRIPTION_ENGINES", "faster_whisper,whisper_cli")
    monkeypatch.setattr("local_evidence_intake._transcribe_with_faster_whisper", faster_whisper)
    monkeypatch.setattr("local_evidence_intake._transcribe_with_gemini", gemini)
    monkeypatch.setattr("local_evidence_intake._transcribe_with_whisper_cli", whisper_cli)

    assert transcribe_video_audio(source) == "Local CLI transcript"
    assert calls == ["faster_whisper", "whisper_cli"]


def test_transcribe_video_audio_reports_when_configured_engines_return_empty(tmp_path, monkeypatch):
    source = tmp_path / "SMC.mp4"
    source.write_bytes(b"fake video bytes")

    monkeypatch.setenv("ORCA_TRANSCRIPTION_ENGINES", "faster_whisper")
    monkeypatch.setattr("local_evidence_intake._transcribe_with_faster_whisper", lambda path: "")

    try:
        transcribe_video_audio(source)
    except RuntimeError as exc:
        assert "configured engines returned empty transcript" in str(exc)
    else:
        raise AssertionError("Expected RuntimeError for empty transcript")



