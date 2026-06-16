import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def fix_layout():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    start_idx = html.find('<div id="page-alpha-lab"')
    if start_idx == -1:
        print("Could not find page-alpha-lab")
        return
        
    end_script = html.find('</script>', start_idx)
    if end_script != -1:
        end_idx = end_script + 9
    else:
        print("Could not find end of alpha lab")
        return
        
    alpha_lab_content = html[start_idx:end_idx]
    
    # Remove it from the current position
    html = html[:start_idx] + html[end_idx:]
    
    # Remove the z-index hack since we are putting it in the right place
    alpha_lab_content = alpha_lab_content.replace('style="position:relative; z-index:100;"', 'style="display:none;"')
    
    # Now insert it right before </main>
    if '</main>' in html:
        html = html.replace('</main>', f'{alpha_lab_content}\n</main>')
        dashboard_path.write_text(html, encoding="utf-8")
        print("Moved Alpha Lab inside <main> successfully.")
    else:
        print("Could not find </main>!")

if __name__ == "__main__":
    fix_layout()
