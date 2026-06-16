import re

file_path = r'G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\artifacts\generated_ea\MasterEA_v1.mq5'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Make the EA dynamic to the tester timeframe instead of hardcoded H1
content = re.sub(r'input ENUM_TIMEFRAMES MainTimeframe\s*=\s*PERIOD_H1;', 'input ENUM_TIMEFRAMES MainTimeframe  = PERIOD_CURRENT;', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
