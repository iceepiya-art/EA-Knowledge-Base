import pandas as pd
import json
import os
from pathlib import Path
from google import genai
from google.genai import types
import datetime

def _get_gemini_client():
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        raise ValueError("GEMINI_API_KEY not found in environment.")
    return genai.Client(api_key=api_key)

def generate_csv_diagnosis(csv_path: str) -> dict:
    path = Path(csv_path)
    if not path.exists():
        raise FileNotFoundError(f"CSV file not found: {csv_path}")

    if csv_path.lower().endswith('.xlsx'):
        df = pd.read_excel(path)
    else:
        df = pd.read_csv(path)
    
    # Basic normalization for common MT5 column names
    df.columns = [c.strip().lower() for c in df.columns]
    
    stats = {
        "total_trades": len(df),
        "columns_found": list(df.columns)
    }
    
    # Calculate PnL stats if available
    pnl_cols = [c for c in df.columns if 'pnl' in c or 'profit' in c]
    if pnl_cols:
        pnl_col = pnl_cols[0]
        df[pnl_col] = pd.to_numeric(df[pnl_col], errors='coerce')
        wins = df[df[pnl_col] > 0]
        losses = df[df[pnl_col] <= 0]
        stats["win_rate"] = len(wins) / len(df) * 100 if len(df) > 0 else 0
        stats["avg_win"] = wins[pnl_col].mean() if len(wins) > 0 else 0
        stats["avg_loss"] = losses[pnl_col].mean() if len(losses) > 0 else 0
        stats["total_pnl"] = df[pnl_col].sum()
        stats["profit_factor"] = abs(wins[pnl_col].sum() / losses[pnl_col].sum()) if len(losses) > 0 and losses[pnl_col].sum() != 0 else 999
    
    # Grab the first 50 rows as a sample
    sample_df = df.head(50)
    csv_sample_str = sample_df.to_csv(index=False)
    
    prompt = f"""
    You are an expert Quantitative Analyst and MT5 EA Developer.
    I have provided a trading history CSV. Please analyze it and extract actionable trading rules or filters to improve our EA's logic.
    
    # File Stats
    Total Trades: {stats['total_trades']}
    Win Rate: {stats.get('win_rate', 'N/A')}%
    Profit Factor: {stats.get('profit_factor', 'N/A')}
    Total PnL: {stats.get('total_pnl', 'N/A')}
    
    # CSV Data Sample (Top 50 Trades):
    {csv_sample_str}
    
    Analyze the patterns in winning vs losing trades. Look at indicators, time of day, or direction if present.
    Return a JSON object in exactly this format:
    {{
        "diagnosis_summary": "A 2-3 sentence summary of your findings",
        "extracted_rules": [
            "Rule 1: Detailed instruction on what to avoid or do",
            "Rule 2: Detailed instruction..."
        ]
    }}
    """
    
    client = _get_gemini_client()
    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=prompt,
        config=types.GenerateContentConfig(
            response_mime_type="application/json",
            temperature=0.2
        )
    )
    
    try:
        result = json.loads(response.text)
    except json.JSONDecodeError:
        result = {"diagnosis_summary": "Failed to parse JSON", "extracted_rules": []}
        
    result["stats"] = stats
    
    # Write to local evidence
    _save_to_local_evidence(path.name, result)
        
    return result

def _save_to_local_evidence(filename: str, diagnosis: dict):
    from local_evidence_intake import import_local_evidence
    
    text_content = f"# CSV Diagnosis Report: {filename}\n\n"
    text_content += f"## Summary\n{diagnosis.get('diagnosis_summary', '')}\n\n"
    text_content += "## Extracted Rules (To be integrated into EA)\n"
    for rule in diagnosis.get('extracted_rules', []):
        text_content += f"- {rule}\n"
        
    # Write a dummy txt file to inbox to run through pipeline
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    out_path = os.path.join(base_dir, "inbox", "text", f"diagnosis_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
    
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(text_content)
    
    # Import it
    import_local_evidence(out_path, text=text_content)
