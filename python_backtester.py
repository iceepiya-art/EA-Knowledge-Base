import yfinance as yf
import pandas as pd
import ta
import json
from pathlib import Path

def run_optimization():
    print("Downloading Gold (XAUUSD) Data (5-minute timeframe)...")
    df = yf.download("GC=F", period="60d", interval="5m")
    if df.empty:
        print("Failed to download data.")
        return
        
    print(f"Data downloaded: {len(df)} rows.")
    
    results = []
    
    for rsi_period in range(10, 31):
        df_test = df.copy()
        
        if isinstance(df_test.columns, pd.MultiIndex):
            df_test.columns = [col[0] for col in df_test.columns]
            
        df_test['RSI'] = ta.momentum.rsi(df_test['Close'], window=rsi_period)
        
        capital = 10000.0
        position = 0
        
        # Use numpy for blazing fast loop
        closes = df_test['Close'].to_numpy()
        rsis = df_test['RSI'].to_numpy()
        
        for i in range(1, len(closes)):
            current_rsi = rsis[i-1]
            current_close = closes[i]
            
            if pd.isna(current_rsi): continue
            
            if position == 0 and current_rsi < 30:
                position = capital / current_close
                capital = 0.0
            elif position > 0 and current_rsi > 70:
                capital = position * current_close
                position = 0
                
        if position > 0:
            capital = position * closes[-1]
            
        profit = capital - 10000.0
        results.append({"rsi_period": rsi_period, "profit": profit})
        print(f"RSI Period {rsi_period}: Profit = ${profit:.2f}")
        
    best = max(results, key=lambda x: x['profit'])
    
    report_content = f"""# RSI Optimization Test Results (M5)
**Date**: 2026-06-12
**Symbol**: Gold (XAUUSD proxy - GC=F)
**Timeframe**: M5 (5 Minutes)
**Data Period**: Last 60 Days
**Strategy**: Buy when RSI < 30, Sell when RSI > 70

## Best Result
- **Best RSI Period**: {best['rsi_period']}
- **Net Profit**: ${best['profit']:.2f} (from $10,000 initial capital)

## All Results
"""
    for r in results:
        report_content += f"- Period {r['rsi_period']}: ${r['profit']:.2f}\n"
        
    kb_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\raw\RSI_Optimization_Result.md")
    kb_path.write_text(report_content, encoding='utf-8')
    print(f"\nOptimization complete! Best RSI: {best['rsi_period']}. Saved to {kb_path}")

if __name__ == "__main__":
    run_optimization()
