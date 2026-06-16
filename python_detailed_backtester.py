import yfinance as yf
import pandas as pd
import ta
from pathlib import Path

def run_detailed_optimization():
    print("Downloading Gold (XAUUSD) Data (5-minute timeframe)...")
    df = yf.download("GC=F", period="60d", interval="5m")
    if df.empty:
        print("Failed to download data.")
        return
        
    print(f"Data downloaded: {len(df)} rows.")
    
    # Flatten columns
    if isinstance(df.columns, pd.MultiIndex):
        df.columns = [col[0] for col in df.columns]
        
    best_rsi = 26 # Found from previous run
    
    df['RSI'] = ta.momentum.rsi(df['Close'], window=best_rsi)
    
    capital = 10000.0
    position = 0
    
    trades = []
    
    # Fast iteration
    closes = df['Close'].to_numpy()
    rsis = df['RSI'].to_numpy()
    times = df.index
    
    entry_price = 0
    entry_time = None
    
    for i in range(1, len(closes)):
        current_rsi = rsis[i-1]
        current_close = closes[i]
        
        if pd.isna(current_rsi): continue
        
        if position == 0 and current_rsi < 30:
            position = capital / current_close
            entry_price = current_close
            entry_time = times[i]
            capital = 0.0
        elif position > 0 and current_rsi > 70:
            capital = position * current_close
            profit = capital - (position * entry_price)
            trades.append({
                'entry_time': entry_time,
                'exit_time': times[i],
                'profit': profit,
                'month': entry_time.month,
                'hour': entry_time.hour
            })
            position = 0
            
    if position > 0:
        capital = position * closes[-1]
        profit = capital - (position * entry_price)
        trades.append({
            'entry_time': entry_time,
            'exit_time': times[-1],
            'profit': profit,
            'month': entry_time.month,
            'hour': entry_time.hour
        })
        
    trades_df = pd.DataFrame(trades)
    
    # Summarize
    total_profit = trades_df['profit'].sum()
    
    profit_by_month = trades_df.groupby('month')['profit'].sum()
    best_month = profit_by_month.idxmax() if not profit_by_month.empty else "N/A"
    worst_month = profit_by_month.idxmin() if not profit_by_month.empty else "N/A"
    
    profit_by_hour = trades_df.groupby('hour')['profit'].sum()
    best_hour = profit_by_hour.idxmax() if not profit_by_hour.empty else "N/A"
    worst_hour = profit_by_hour.idxmin() if not profit_by_hour.empty else "N/A"
    
    report_md = f"""# Detailed EA Backtest Analysis (M5)
**Date**: 2026-06-12
**Symbol**: Gold (XAUUSD - GC=F)
**Timeframe**: M5
**Period Tested**: Last 60 Days
**Best Parameter**: RSI Period = {best_rsi}

## Summary
- **Total Trades**: {len(trades_df)}
- **Total Profit**: ${total_profit:.2f}

## Time & Seasonality Analysis
- **Best Trading Month**: Month {best_month} (${profit_by_month.get(best_month, 0):.2f})
- **Worst Trading Month**: Month {worst_month} (${profit_by_month.get(worst_month, 0):.2f})
- **Best Trading Hour**: {best_hour}:00 (${profit_by_hour.get(best_hour, 0):.2f})
- **Worst Trading Hour**: {worst_hour}:00 (${profit_by_hour.get(worst_hour, 0):.2f})

## Conclusion
The algorithm performs best during the {best_hour}:00 hour block and worst around {worst_hour}:00.
Consider adding a Time Filter constraint to the EA to block trading during {worst_hour}:00.
"""

    kb_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\raw\EA_Detailed_M5_Analysis.md")
    kb_path.write_text(report_md, encoding='utf-8')
    print(f"Saved detailed analysis to {kb_path}")
    
    # Prepare HTML snippet for dashboard
    html_snippet = f"""
        <div class="panel" style="margin-top: 20px;">
            <div class="panel-head" style="display:flex; align-items:center;">
                <div class="panel-title" style="display:flex; align-items:center; gap:8px;"><i data-lucide="bar-chart-2" style="width:18px;height:18px;"></i> Recent AI Optimization Results (Gold M5)</div>
            </div>
            <div class="panel-body">
                <div style="display:grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 12px;">
                    <div class="ea-stat-card">
                        <small>Parameter</small>
                        <b style="font-size:16px;">RSI = {best_rsi}</b>
                    </div>
                    <div class="ea-stat-card">
                        <small>Total Profit</small>
                        <b style="font-size:16px; color:var(--green)">${total_profit:.2f}</b>
                    </div>
                    <div class="ea-stat-card">
                        <small>Best Time</small>
                        <b style="font-size:16px;">{best_hour}:00</b>
                    </div>
                    <div class="ea-stat-card">
                        <small>Worst Time</small>
                        <b style="font-size:16px;">{worst_hour}:00</b>
                    </div>
                </div>
                <div style="font-size: 12px; color: var(--text-muted); background: rgba(255,255,255,0.03); padding: 10px; border-radius: 8px;">
                    <em>Insight: Added Time Filter recommendation to Knowledge Base to avoid {worst_hour}:00.</em>
                </div>
            </div>
        </div>
    """
    
    dash_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")
    dash_content = dash_path.read_text(encoding='utf-8')
    
    # Inject before </body> if not already injected
    if "Recent AI Optimization Results" not in dash_content:
        target = 'id="page-backtest" class="page"'
        if target in dash_content:
            idx = dash_content.find(target)
            idx = dash_content.find('>', idx) + 1
            dash_content = dash_content[:idx] + f'\n{html_snippet}\n' + dash_content[idx:]
        else:
            dash_content = dash_content.replace('</body>', f'{html_snippet}\n</body>')
        dash_path.write_text(dash_content, encoding='utf-8')
        print("Injected results into Dashboard.")

if __name__ == "__main__":
    run_detailed_optimization()
