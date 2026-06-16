import os
import glob
import re
import time

reports_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Parallel_Reports"
output_md = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\raw\EA_Backtest_Stats.md"

def extract_stat(xml_content, stat_name):
    # Regex to find: <Data ss:Type="String">Stat Name</Data> followed by <Data ss:Type="Number">Value</Data> or String
    pattern = r'<Data ss:Type="String">' + re.escape(stat_name) + r'</Data>.*?<Data ss:Type="(?:Number|String)">([^<]+)</Data>'
    match = re.search(pattern, xml_content, re.DOTALL | re.IGNORECASE)
    if match:
        return match.group(1).strip()
    return "N/A"

def parse_reports():
    xml_files = glob.glob(os.path.join(reports_dir, "*.xml"))
    
    if not xml_files:
        return False
        
    results = []
    for f in xml_files:
        filename = os.path.basename(f)
        # Expected format: Report_AgentX_EAName_M1.xml
        parts = filename.replace(".xml", "").split("_", 2)
        if len(parts) >= 3:
            ea_name_tf = parts[2]
            # TF is usually the last part
            tf = "M1" if "_M1" in ea_name_tf else "M5" if "_M5" in ea_name_tf else "Unknown"
            ea_name = ea_name_tf.replace(f"_{tf}", "")
        else:
            ea_name = filename
            tf = "Unknown"
            
        with open(f, 'r', encoding='utf-16', errors='ignore') as file:
            content = file.read()
            if "Total Net Profit" not in content:
                # MT5 might save as utf-8 or ANSI, try utf-8
                with open(f, 'r', encoding='utf-8', errors='ignore') as file2:
                    content = file2.read()

        profit = extract_stat(content, "Total Net Profit")
        drawdown = extract_stat(content, "Equity DD %")
        if drawdown == "N/A":
            drawdown = extract_stat(content, "Balance DD %")
        trades = extract_stat(content, "Total Trades")
        win_rate = extract_stat(content, "Profit Trades (% of total)")
        
        # Win rate is usually something like "45 (60.00%)", extract percentage
        if "(" in win_rate:
            win_rate = win_rate.split("(")[1].replace(")", "")
            
        results.append({
            "EA Name": ea_name,
            "TF": tf,
            "Net Profit": profit,
            "Drawdown %": drawdown,
            "Total Trades": trades,
            "Win Rate": win_rate
        })
        
    # Sort by Net Profit (handling N/A and converting to float)
    def get_profit(item):
        try:
            return float(item["Net Profit"])
        except:
            return -999999
            
    results.sort(key=get_profit, reverse=True)
    
    # Generate Markdown Table manually
    md_table = "| EA Name | TF | Net Profit | Drawdown % | Total Trades | Win Rate |\n"
    md_table += "|---|---|---|---|---|---|\n"
    for r in results:
        md_table += f"| {r['EA Name']} | {r['TF']} | {r['Net Profit']} | {r['Drawdown %']} | {r['Total Trades']} | {r['Win Rate']} |\n"
    
    md_content = f"""---
title: "EA Backtest Statistics (XAUUSD 1Y Real Ticks)"
tags: ["backtest", "mt5", "stats"]
---

# 📊 EA Backtest Statistics
*Live auto-updating report from MT5 Parallel Supervisor*

**Total EAs Tested so far:** {len(xml_files)}

{md_table}

*Note: EAs with high profit but extremely high drawdown (>30%) are highly dangerous.*
"""

    with open(output_md, 'w', encoding='utf-8') as out:
        out.write(md_content)
        
    return True

if __name__ == "__main__":
    print("Watching for MT5 reports...")
    while True:
        try:
            parsed = parse_reports()
            if parsed:
                print(f"Updated {output_md}")
                # Optional: sync to obsidian
                os.system(r'python "G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\update_obsidian.py"')
        except Exception as e:
            print(f"Error parsing: {e}")
            
        time.sleep(60) # check every minute
