from pathlib import Path

js_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\test_1.js")

def fix():
    js = js_path.read_text(encoding="utf-8")
    
    old_code = """['obsidian-status', 'conflict-status-indicator', 'index-status-indicator'].forEach(id => {"""
    new_code = """['obsidian-status', 'conflict-status', 'knowledge-status'].forEach(id => {"""

    if old_code in js:
        js = js.replace(old_code, new_code)
        js_path.write_text(js, encoding="utf-8")
        print("Fixed status indicators in JS!")
    else:
        print("old_code not found")

if __name__ == "__main__":
    fix()
