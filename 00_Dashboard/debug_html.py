import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def debug():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    start_idx = html.find('<div id="page-alpha-lab"')
    print("Found at:", start_idx)
    if start_idx != -1:
        print(html[start_idx:start_idx+1000])

if __name__ == "__main__":
    debug()
