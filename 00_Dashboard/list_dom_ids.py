import re
from pathlib import Path

js_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\test_1.js")
js = js_path.read_text(encoding="utf-8")
ids = re.findall(r"document\.getElementById\('([^']+)'\)", js)
unique_ids = list(set(ids))
unique_ids.sort()
print("\n".join(unique_ids))
