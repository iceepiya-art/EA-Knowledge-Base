from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def check_html():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    print("Has page-dashboard?", '<div id="page-dashboard"' in html)
    print("Has page-alpha-lab?", '<div id="page-alpha-lab"' in html)
    print("Has test_0.js?", 'test_0.js' in html)
    print("Has test_1.js?", 'test_1.js' in html)
    print("Total length:", len(html))
    
    # Let's print the last 500 chars to see what's there
    print("END OF FILE:\n", html[-500:])

if __name__ == "__main__":
    check_html()
