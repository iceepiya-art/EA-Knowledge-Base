import re

file_path = r'G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\artifacts\generated_ea\MasterEA_v1.mq5'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace .Free() with .Clear()
content = content.replace('.Free()', '.Clear()')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
