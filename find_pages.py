from pathlib import Path
import re

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def find_pages():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    pages = re.findall(r'<div id="(page-[^"]+)"', html)
    print("Found pages:", pages)
    
    # Also find where the content div is
    content_idx = html.find('<div class="content">')
    print("Content div at:", content_idx)
    
    for page in pages:
        idx = html.find(f'<div id="{page}"')
        print(f"{page} at index: {idx}, is inside content: {idx > content_idx}")

if __name__ == "__main__":
    find_pages()
