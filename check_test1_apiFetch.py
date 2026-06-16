from pathlib import Path
js = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\test_1.js").read_text(encoding="utf-8")
lines = js.split("\n")
print("\n".join(lines[10:30]))
