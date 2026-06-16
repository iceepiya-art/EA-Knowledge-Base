import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def fix_html():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    # Replace the incorrect onclick attribute
    bad_onclick = "onclick=\"showPage('page-alpha-lab'); return false;\""
    good_onclick = "onclick=\"showPage('alpha-lab'); return false;\""
    
    if bad_onclick in html:
        html = html.replace(bad_onclick, good_onclick)
        dashboard_path.write_text(html, encoding="utf-8")
        print("Fixed onclick parameter successfully.")
    else:
        print("bad_onclick not found.")

if __name__ == "__main__":
    fix_html()
