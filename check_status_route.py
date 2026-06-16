import re
from pathlib import Path

server_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\learning\server.py")
code = server_path.read_text(encoding="utf-8", errors="ignore")

lines = code.split("\n")
for i, l in enumerate(lines):
    if '@app.route("/api/learning/status")' in l:
        print("\n".join(lines[i:i+10]))
        break
