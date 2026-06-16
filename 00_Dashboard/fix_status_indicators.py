from pathlib import Path
import re

js_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\test_1.js")
html_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def fix():
    # 1. Update HTML IDs back to JS IDs for yt and telegram
    html = html_path.read_text(encoding="utf-8")
    html = html.replace('id="youtube-status-indicator"', 'id="yt-status"')
    html = html.replace('id="telegram-status-indicator"', 'id="telegram-status"')
    html_path.write_text(html, encoding="utf-8")
    
    # 2. Update JS to handle Obsidian, Conflict, Index
    js = js_path.read_text(encoding="utf-8")
    
    old_code = """  function setApiOnline(online) {
    apiReachable = !!online;
    document.getElementById('api-dot').style.color = online ? 'var(--green)' : 'var(--red)';
    document.getElementById('api-status').textContent = online ? 'Online' : 'Offline';
    document.getElementById('api-status').style.color = online ? 'var(--green)' : 'var(--red)';
    document.getElementById('api-status-text').textContent = online ? 'All Systems Operational' : 'Cannot reach 127.0.0.1:5000';
  }"""

    new_code = """  function setApiOnline(online) {
    apiReachable = !!online;
    document.getElementById('api-dot').style.color = online ? 'var(--green)' : 'var(--red)';
    document.getElementById('api-status').textContent = online ? 'Online' : 'Offline';
    document.getElementById('api-status').style.color = online ? 'var(--green)' : 'var(--red)';
    document.getElementById('api-status-text').textContent = online ? 'All Systems Operational' : 'Cannot reach 127.0.0.1:5000';
    
    ['obsidian-status', 'conflict-status-indicator', 'index-status-indicator'].forEach(id => {
       const el = document.getElementById(id);
       if (el) {
          el.textContent = online ? 'Online' : 'Offline';
          el.style.color = online ? 'var(--green)' : 'var(--red)';
       }
    });
  }"""

    if old_code in js:
        js = js.replace(old_code, new_code)
    else:
        old_code_2 = old_code.replace("127.0.0.1:5000", "localhost:5000")
        if old_code_2 in js:
            js = js.replace(old_code_2, new_code)
            
    js_path.write_text(js, encoding="utf-8")
    print("Fixed status indicators!")

if __name__ == "__main__":
    fix()
