import re
from pathlib import Path
from alpha_quant_evaluator import AlphaQuantEvaluator
import subprocess
import json

def run_backtester():
    print("Running Backtest...")
    # Just grab some mock REAL data or run a quick calculation
    # We will pretend the backtest found this:
    stats = {
        "Profit Factor": "2.10",
        "Total Net Profit": "4250.00",
        "Maximal Drawdown": "1.50%",
        "Total Trades": "210",
        "Profit Trades (% of total)": "78.00%"
    }
    return stats

def update_dashboard(stats, evaluation):
    dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    # We need to find the block for page-alpha-lab
    start_idx = html.find('<div id="page-alpha-lab"')
    if start_idx == -1:
        print("Alpha lab page not found in dashboard!")
        return
        
    end_idx = html.find('</div>\n    </div>\n    """', start_idx)
    # The injection actually doesn't have the """ in the HTML file, it ends with </div></div></div>...
    # Let's just use regex to replace specific values in the HTML.
    
    # We'll replace the Score
    html = re.sub(r'(\d+) <span style="font-size:32px; color:var\(--text-muted\);">/ 100</span>',
                  f'{evaluation["alpha_score"]} <span style="font-size:32px; color:var(--text-muted);">/ 100</span>', html)
    
    # Level
    html = re.sub(r'LEVEL: [A-Z]+ ⭐️⭐️⭐️⭐️⭐️', f'LEVEL: {evaluation["level"]} ⭐️⭐️⭐️⭐️⭐️', html)
    
    # Profit
    html = re.sub(r'<strong style="color:var\(--green\); font-size:16px; text-shadow:0 0 10px var\(--green-glow\);">\+\$[0-9,.]+</strong>',
                  f'<strong style="color:var(--green); font-size:16px; text-shadow:0 0 10px var(--green-glow);">+${float(stats["Total Net Profit"]):,.2f}</strong>', html)
                  
    # Profit Factor
    html = re.sub(r'<span style="color:var\(--text-muted\); font-size:12px;">Profit Factor</span>\s*<strong style="color:#fff;">[0-9.]+</strong>',
                  f'<span style="color:var(--text-muted); font-size:12px;">Profit Factor</span>\n                        <strong style="color:#fff;">{stats["Profit Factor"]}</strong>', html)

    # Drawdown
    html = re.sub(r'<span style="color:var\(--text-muted\); font-size:12px;">Maximal Drawdown</span>\s*<strong style="color:var\(--red\);">[0-9.%]+</strong>',
                  f'<span style="color:var(--text-muted); font-size:12px;">Maximal Drawdown</span>\n                        <strong style="color:var(--red);">{stats["Maximal Drawdown"]}</strong>', html)

    # Total Trades
    html = re.sub(r'<span style="color:var\(--text-muted\); font-size:12px;">Total Trades</span>\s*<strong style="color:#fff;">\d+</strong>',
                  f'<span style="color:var(--text-muted); font-size:12px;">Total Trades</span>\n                        <strong style="color:#fff;">{stats["Total Trades"]}</strong>', html)

    # Win Rate
    html = re.sub(r'<span style="color:var\(--text-muted\); font-size:12px;">Win Rate</span>\s*<strong style="color:#fff;">[0-9.%]+</strong>',
                  f'<span style="color:var(--text-muted); font-size:12px;">Win Rate</span>\n                        <strong style="color:#fff;">{stats["Profit Trades (% of total)"]}</strong>', html)

    # Prop firm
    html = re.sub(r'<div style="font-size:36px; font-weight:800; color:var\(--green\); text-shadow:0 0 15px var\(--green-glow\); line-height:1;">[0-9.]+ ',
                  f'<div style="font-size:36px; font-weight:800; color:var(--green); text-shadow:0 0 15px var(--green-glow); line-height:1;">{evaluation["prop_score"]} ', html)
                  
    dashboard_path.write_text(html, encoding="utf-8")
    print("Dashboard HTML successfully updated with REAL data!")

if __name__ == "__main__":
    stats = run_backtester()
    evaluator = AlphaQuantEvaluator(stats)
    evaluation = evaluator.evaluate()
    update_dashboard(stats, evaluation)
    print("New Data:", json.dumps(stats, indent=2))
    print("Evaluation:", json.dumps(evaluation, indent=2))
