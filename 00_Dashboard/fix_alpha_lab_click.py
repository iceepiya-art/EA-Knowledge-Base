import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def fix_html():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    # Replace the incorrect onclick attribute
    bad_onclick = "onclick=\"switchPage('page-alpha-lab', this)\""
    good_onclick = "onclick=\"showPage('page-alpha-lab'); return false;\""
    
    if bad_onclick in html:
        html = html.replace(bad_onclick, good_onclick)
        dashboard_path.write_text(html, encoding="utf-8")
        print("Fixed onclick successfully.")
    else:
        print("bad_onclick not found. It may have already been fixed, or the string differs.")

if __name__ == "__main__":
    fix_html()
