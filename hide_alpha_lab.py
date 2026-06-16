import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def fix_display_none():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    # Replace the starting tag to include display:none
    bad_tag = '<div id="page-alpha-lab" class="page" style="position:relative; z-index:100;">'
    good_tag = '<div id="page-alpha-lab" class="page" style="display:none; position:relative; z-index:100;">'
    
    if bad_tag in html:
        html = html.replace(bad_tag, good_tag)
        dashboard_path.write_text(html, encoding="utf-8")
        print("Fixed display:none!")
    elif good_tag in html:
        print("Already has display:none")
    else:
        # Try regex if exact match fails
        html = re.sub(r'<div id="page-alpha-lab" class="page"[^>]*>', good_tag, html)
        dashboard_path.write_text(html, encoding="utf-8")
        print("Fixed display:none using regex!")

if __name__ == "__main__":
    fix_display_none()
