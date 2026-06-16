import os
import glob
import json
import shutil
import time

source_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base"
target_dir = r"C:\Users\ADMIN\Documents\claw-empire\custom-skills"

skills_glob = os.path.join(source_dir, ".agent*", "skills", "**", "SKILL.md")
skill_files = glob.glob(skills_glob, recursive=True)

print(f"Injecting {len(skill_files)} skills into {target_dir}...")

providers = ["claude", "openai", "gemini", "opencode", "kimi"]

for file_path in skill_files:
    dir_name = os.path.basename(os.path.dirname(file_path))
    skill_name = dir_name[:80]
    canonical_name = skill_name.lower()
    
    skill_target_dir = os.path.join(target_dir, canonical_name)
    os.makedirs(skill_target_dir, exist_ok=True)
    
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    with open(os.path.join(skill_target_dir, "skills.md"), "w", encoding="utf-8") as f:
        f.write(content)
        
    meta = {
        "skillName": skill_name,
        "canonicalSkillName": canonical_name,
        "providers": providers,
        "createdAt": int(time.time() * 1000),
        "updatedAt": int(time.time() * 1000),
        "contentLength": len(content)
    }
    
    with open(os.path.join(skill_target_dir, "meta.json"), "w", encoding="utf-8") as f:
        json.dump(meta, f, indent=2)
        
    print(f"Injected: {skill_name}")

print("Done! You can now see them in the Skills Library.")
