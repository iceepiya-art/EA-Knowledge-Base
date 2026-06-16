from pathlib import Path

js_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\test_1.js")

def fix_showpage():
    js = js_path.read_text(encoding="utf-8", errors="ignore")
    
    old_code = """  function showPage(pageId) {
    // hide all pages
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
    const target = document.getElementById('page-' + pageId);
    if (target) target.classList.add('active');"""

    new_code = """  function showPage(pageId) {
    // hide all pages robustly
    document.querySelectorAll('.page').forEach(p => {
        p.classList.remove('active');
        p.style.display = 'none';
    });
    const target = document.getElementById('page-' + pageId);
    if (target) {
        target.classList.add('active');
        target.style.display = 'block';
    }"""
    
    if old_code in js:
        js = js.replace(old_code, new_code)
        js_path.write_text(js, encoding="utf-8")
        print("Fixed showPage in test_1.js!")
    else:
        print("Could not find old showPage code.")

if __name__ == "__main__":
    fix_showpage()
