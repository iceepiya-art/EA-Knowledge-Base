import re

file_path = r'G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\artifacts\generated_ea\MasterEA_v1.mq5'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix 1: Add Arrays include
if '<Arrays\\ArrayObj.mqh>' not in content:
    content = content.replace('#include <CME_Levels.mqh>', '#include <CME_Levels.mqh>\n#include <Arrays\\ArrayObj.mqh>')

# Fix 2: ENUM_TIMEFRAME -> ENUM_TIMEFRAMES
content = content.replace('ENUM_TIMEFRAME', 'ENUM_TIMEFRAMES')

# Fix 3: cme.Init() check
content = content.replace('''    if (!cme.Init()) {
        Print("Failed to initialize CME Levels library!");
        return INIT_FAILED;
    }''', '    cme.Init();')

# Fix 4: TimeCurrent().day
content = content.replace('''    if (TimeCurrent() > last_trade_day && TimeCurrent().day != last_trade_day.day) {
        ResetDailyStats();
        last_trade_day = TimeCurrent();
    }''', '''    MqlDateTime dt_curr, dt_last;
    TimeToStruct(TimeCurrent(), dt_curr);
    TimeToStruct(last_trade_day, dt_last);
    if (TimeCurrent() > last_trade_day && dt_curr.day != dt_last.day) {
        ResetDailyStats();
        last_trade_day = TimeCurrent();
    }''')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
