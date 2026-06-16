import os
import glob
import json
import urllib.request
import urllib.error

base_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base"
skills_glob = os.path.join(base_dir, ".agent*", "skills", "**", "SKILL.md")
skill_files = glob.glob(skills_glob, recursive=True)

print(f"Found {len(skill_files)} skill files.")

providers = ["claude", "openai", "gemini", "opencode", "kimi"]

for file_path in skill_files:
    dir_name = os.path.basename(os.path.dirname(file_path))
    skill_name = dir_name[:80] # Max 80 chars
    
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    data = json.dumps({
        "skillName": skill_name,
        "content": content,
        "providers": providers
    }).encode("utf-8")
    
    req = urllib.request.Request("http://127.0.0.1:8790/api/skills/custom", data=data, headers={"Content-Type": "application/json"}, method="POST")
    try:
        with urllib.request.urlopen(req) as response:
            res = json.loads(response.read().decode("utf-8"))
            print(f"Successfully imported {skill_name}: {res}")
    except urllib.error.URLError as e:
        print(f"Failed to import {skill_name}: {e}")
        if hasattr(e, 'read'):
            print(e.read().decode('utf-8'))

# Register Project
project_data = json.dumps({
    "name": "EA-Knowledge-Base",
    "project_path": base_dir,
    "core_goal": "Develop and backtest MQL5 EAs using CME OI SYSTEM and FXSSI data"
}).encode("utf-8")

req_proj = urllib.request.Request("http://127.0.0.1:8790/api/projects", data=project_data, headers={"Content-Type": "application/json"}, method="POST")
try:
    with urllib.request.urlopen(req_proj) as response:
        res = json.loads(response.read().decode("utf-8"))
        print(f"Successfully registered project EA-Knowledge-Base: {res}")
except urllib.error.URLError as e:
    print(f"Failed to register project: {e}")
    if hasattr(e, 'read'):
        print(e.read().decode('utf-8'))
