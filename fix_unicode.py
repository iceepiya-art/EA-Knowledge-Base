import re

file_path = r'G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\learning\mt5_cli.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace checkmark with standard ascii to avoid cp1252 errors
content = content.replace('[\u2714]', '[+]')
# also replace any o in the string
content = re.sub(r'\[\w\] Compilation successful', '[+] Compilation successful', content)
content = content.replace('[o]', '[+]')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
