import os
import glob
import re

source_base = r"G:\My Drive\jobot"
output_base = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\raw\EA_Analysis"
dirs = ['EA Week2', 'EA Week3', 'EA Week4', 'EA Week5', 'EA Week6', 'EA Week7', 'EA Week8', 'EA Week9', 'EA Week10', 'ICEE PROFIT']

def analyze_ea(file_path, folder_name):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
        ea_name = os.path.basename(file_path)
        is_fxdreema = "fxDreema" in content or "fxdreema" in content.lower()
        
        # Extract inputs
        input_pattern = re.compile(r'^(?:input|sinput|extern)\s+([a-zA-Z0-9_]+)\s+([a-zA-Z0-9_]+)\s*=\s*([^;]+);', re.MULTILINE)
        inputs = input_pattern.findall(content)
        
        # Detect logic
        logic_tags = []
        c_lower = content.lower()
        if "martingale" in c_lower or "multiplier" in c_lower:
            logic_tags.append("Martingale")
        if "grid" in c_lower or "step" in c_lower:
            logic_tags.append("Grid")
        if "ma(" in c_lower or "ima(" in c_lower:
            logic_tags.append("MovingAverage")
        if "rsi(" in c_lower or "irsi(" in c_lower:
            logic_tags.append("RSI")
            
        out_dir = os.path.join(output_base, folder_name.replace(" ", "_"))
        os.makedirs(out_dir, exist_ok=True)
        
        md_content = f"""---
title: "EA Analysis: {ea_name}"
tags: ["ea-analysis", "{folder_name.replace(' ', '-').lower()}"]
---

# 🤖 EA Analysis Report: {ea_name}

- **Source Folder:** {folder_name}
- **Type:** {'fxDreema Generated' if is_fxdreema else 'Native MQL'}
- **Detected Logic Elements:** {', '.join(logic_tags) if logic_tags else 'Unknown/Custom'}

## ⚙️ Key Inputs/Parameters
"""
        if inputs:
            for itype, iname, ivalue in inputs[:20]: # Limit to 20 to avoid massive files
                md_content += f"- `{iname}` ({itype}) = **{ivalue.strip()}**\n"
            if len(inputs) > 20:
                md_content += f"- *... and {len(inputs) - 20} more parameters.*\n"
        else:
            md_content += "No standard input parameters detected.\n"
            
        md_path = os.path.join(out_dir, f"{ea_name}.md")
        with open(md_path, 'w', encoding='utf-8') as mf:
            mf.write(md_content)
            
    except Exception as e:
        print(f"Error analyzing {file_path}: {e}")

total_analyzed = 0
for d in dirs:
    path = os.path.join(source_base, d)
    if os.path.exists(path):
        mq_files = glob.glob(os.path.join(path, '**', '*.mq*'), recursive=True)
        print(f"Analyzing {len(mq_files)} files in {d}...")
        for f in mq_files:
            analyze_ea(f, d)
            total_analyzed += 1

print(f"\nSuccessfully generated {total_analyzed} markdown reports in {output_base}")
