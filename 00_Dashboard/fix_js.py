import re

path = 'g:/My Drive/save log-blueprint-skill/EA-Knowledge-Base/00_Dashboard/EA_Knowledge_Brain_Dashboard.html'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the hardcoded types array with dynamic keys
content = content.replace("const types = ['entry', 'stop_loss', 'exit', 'filter', 'regime'];", "const types = Object.keys(comps).length > 0 ? Object.keys(comps) : ['entry', 'stop_loss', 'exit', 'filter', 'regime'];")

# Update color and label fallbacks
content = content.replace("const col = COMP_COLORS[t];", "const col = COMP_COLORS[t] || '#60a5fa';")
content = content.replace("const label = COMP_LABELS[t];", "const label = COMP_LABELS[t] || t;")

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed JS mapping successfully!")
