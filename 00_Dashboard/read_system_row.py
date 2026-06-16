import re
from pathlib import Path

html_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")
html = html_path.read_text(encoding="utf-8", errors="ignore")
matches = re.findall(r'<div class="system-row">.*?id="([^"]+)".*?</div>', html)
for m in matches:
    print(m)
