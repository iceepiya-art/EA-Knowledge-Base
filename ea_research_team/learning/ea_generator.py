"""AI EA Generator (Phase 2) — Generates Master All-Terrain EA using Claude 3.5 Sonnet.

Reads:
  - Master_EA_Blueprint.yaml
  - ea_components.json (for detailed MQL5 rules)

Writes:
  - artifacts/generated_ea/MasterEA_vX.mq5
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

try:
    import google.genai as genai
    from google.genai import types
except ImportError:
    print("Warning: 'google-genai' package not found. Run: pip install google-genai")
    genai = None

DEFAULT_BLUEPRINT_PATH = Path(__file__).with_name("Master_EA_Blueprint.yaml")
DEFAULT_COMPONENTS_PATH = Path(__file__).with_name("ea_components.json")
OUTPUT_DIR = Path(__file__).parent.parent.parent / "artifacts" / "generated_ea"

PROMPT_TEMPLATE = """You are an elite, world-class MQL5 Developer. Your goal is to write the "Master All-Terrain EA" (The Holy Grail).
You are not allowed to write simple or basic EAs. You MUST write an advanced, regime-switching Context-Aware EA.

Here is the Blueprint (Architectural Focus):
{blueprint}

Here are the specific extracted rules and logic from our knowledge base:
{components}

REQUIREMENTS:
1. The EA MUST have a Market Regime Detector (e.g., detecting Trend vs Sideway using ADX, ATR, or Moving Averages).
2. The `OnTick()` function MUST be divided into conditional regimes:
   - If `IsTrend()` -> Run Trend Engine (Breakout, Trailing Stop)
   - If `IsSideway()` -> Run Range Engine (Grid, Scalping, Oscillators)
   - If `IsHighVolatility()` -> Run Risk Management Engine (Hedge, Close All, or tighten stops)
3. Include proper Position Sizing, Stop Loss, and Take Profit calculations.
4. Output ONLY the raw MQL5 code inside a single ```mq5 block. Do not output markdown text outside the code block.
"""

def read_files(blueprint_path: Path, components_path: Path) -> tuple[str, str]:
    blueprint = blueprint_path.read_text(encoding="utf-8") if blueprint_path.exists() else "No blueprint found."
    
    if components_path.exists():
        comps = json.loads(components_path.read_text(encoding="utf-8"))
        comps_text = json.dumps(comps.get("components", {}), indent=2, ensure_ascii=False)
    else:
        comps_text = "No components found."
        
    return blueprint, comps_text

def generate_ea(blueprint: str, components: str, api_key: str) -> str:
    if not genai:
        raise RuntimeError("google-genai SDK is not installed.")
        
    client = genai.Client(api_key=api_key)
    
    prompt = PROMPT_TEMPLATE.format(blueprint=blueprint, components=components)
    
    print("Generating Master EA with Gemini... (This may take 15-30 seconds)")
    
    system_instruction = """You are an expert MQL5 algorithmic trader and developer.
        - Must output raw valid MQL5 code only. No markdown formatting.
        - Focus on code structure and strategy logic.
        - DO NOT use #include <Indicators/ADX.mqh> or similar fake includes. Use standard iADX(), iATR(), iMACD(), iMA() built-in functions.
        
        CRITICAL RULE - CME INSTITUTIONAL LEVELS:
        You MUST include <CME_Levels.mqh> in your code.
        Instantiate `CCmeLevels cme;` and call `cme.Init();` in OnInit().
        Before opening a BUY order, you MUST check `cme.IsNearCmeSupport(Ask)`.
        Before opening a SELL order, you MUST check `cme.IsNearCmeResistance(Bid)`.
        This is an absolute requirement. Do not trade in the middle of nowhere.
        
        MAKE SURE TO GENERATE THE ENTIRE COMPLETE EA CODE. Do not truncate."""
        
    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=prompt,
        config=types.GenerateContentConfig(
            system_instruction=system_instruction,
            temperature=0.2,
            max_output_tokens=8000,
        )
    )
    
    content = response.text
    
    # Extract code from ```mq5 ... ```
    if "```mq5" in content:
        code = content.split("```mq5")[1].split("```")[0].strip()
    elif "```mql5" in content:
        code = content.split("```mql5")[1].split("```")[0].strip()
    elif "```" in content:
        code = content.split("```")[1].split("```")[0].strip()
    else:
        code = content.strip()
        
    return code

def main(argv: list[str] | None = None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        
    parser = argparse.ArgumentParser(description="Phase 2: Master EA Generator")
    parser.add_argument("--blueprint", default=str(DEFAULT_BLUEPRINT_PATH))
    parser.add_argument("--components", default=str(DEFAULT_COMPONENTS_PATH))
    parser.add_argument("--output-name", default="MasterEA_v1.mq5")
    args = parser.parse_args(argv)
    
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("Error: GEMINI_API_KEY environment variable is not set.", file=sys.stderr)
        return 1
        
    try:
        blueprint, comps = read_files(Path(args.blueprint), Path(args.components))
        mql5_code = generate_ea(blueprint, comps, api_key)
        
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
        out_file = OUTPUT_DIR / args.output_name
        out_file.write_text(mql5_code, encoding="utf-8")
        
        print(f"SUCCESS: Master EA successfully generated and saved to: {out_file}")
        
    except Exception as e:
        print(f"Error during generation: {e}", file=sys.stderr)
        return 1
        
    return 0

if __name__ == "__main__":
    sys.exit(main())
