from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def fix_js_links():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    js_tags = """
    <script src="test_0.js"></script>
    <script src="test_1.js"></script>
    """
    
    if "test_1.js" not in html:
        html = html.replace('</body>', f'{js_tags}\n</body>')
        dashboard_path.write_text(html, encoding="utf-8")
        print("Injected JS links successfully.")
    else:
        print("JS links already exist.")

if __name__ == "__main__":
    fix_js_links()
