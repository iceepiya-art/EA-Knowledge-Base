import re

file_path = r'G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\artifacts\generated_ea\MasterEA_v1.mq5'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix PlaceBuyOrder
buy_logic_old = '''    if (!cme.IsNearCmeSupport(price)) {
        if (UseNotifications) Alert("CME: Not near CME Support for BUY at ", DoubleToString(price, _Digits));
        return false;
    }'''
content = content.replace(buy_logic_old, '')

# Fix PlaceSellOrder
sell_logic_old = '''    if (!cme.IsNearCmeResistance(price)) {
        if (UseNotifications) Alert("CME: Not near CME Resistance for SELL at ", DoubleToString(price, _Digits));
        return false;
    }'''
content = content.replace(sell_logic_old, '')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
