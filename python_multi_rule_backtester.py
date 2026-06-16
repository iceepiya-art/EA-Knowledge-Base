import MetaTrader5 as mt5
import pandas as pd
import ta
from pathlib import Path
from datetime import datetime, timedelta
import numpy as np

WORKSPACE_DIR = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base")

def get_tf_name(tf):
    if tf == mt5.TIMEFRAME_M1: return "M1"
    if tf == mt5.TIMEFRAME_M5: return "M5"
    if tf == mt5.TIMEFRAME_M15: return "M15"
    return str(tf)

def run_multi_tf_optimization():
    print("[*] Initializing MetaTrader5...")
    if not mt5.initialize():
        print(f"[-] MT5 init failed, error code: {mt5.last_error()}")
        return

    timeframes = [mt5.TIMEFRAME_M1, mt5.TIMEFRAME_M5, mt5.TIMEFRAME_M15]
    date_to = datetime.now()
    date_from = date_to - timedelta(days=365)
    
    all_results = []

    for tf in timeframes:
        tf_name = get_tf_name(tf)
        print(f"\n[*] Fetching 1 Year of {tf_name} Data for XAUUSD (from {date_from.date()} to {date_to.date()})...")
        rates = mt5.copy_rates_range("XAUUSD", tf, date_from, date_to)
        
        if rates is None or len(rates) == 0:
            print(f"[-] Failed to fetch data for {tf_name}.")
            continue

        df = pd.DataFrame(rates)
        df['time'] = pd.to_datetime(df['time'], unit='s')
        df.set_index('time', inplace=True)
        
        print(f"[+] Data ready: {len(df)} rows for {tf_name}. Calculating indicators...")

        # Pre-calculate Indicators
        df['ema_10'] = ta.trend.ema_indicator(df['close'], window=10)
        df['ema_20'] = ta.trend.ema_indicator(df['close'], window=20)
        df['ema_50'] = ta.trend.ema_indicator(df['close'], window=50)
        df['ema_200'] = ta.trend.ema_indicator(df['close'], window=200)
        
        df['rsi_14'] = ta.momentum.rsi(df['close'], window=14)
        
        df['stoch_k'] = ta.momentum.stoch(df['high'], df['low'], df['close'], window=14, smooth_window=3)
        df['stoch_d'] = ta.momentum.stoch_signal(df['high'], df['low'], df['close'], window=14, smooth_window=3)
        
        df['macd'] = ta.trend.macd(df['close'], window_slow=26, window_fast=12)
        df['macd_signal'] = ta.trend.macd_signal(df['close'], window_slow=26, window_fast=12, window_sign=9)
        
        df['bb_high'] = ta.volatility.bollinger_hband(df['close'], window=20, window_dev=2.0)
        df['bb_low'] = ta.volatility.bollinger_lband(df['close'], window=20, window_dev=2.0)

        closes = df['close'].to_numpy()
        
        def run_vectorized_test(buy_signals, sell_signals, rule_name, param_name):
            capital = 10000.0
            pos = 0
            entry = 0.0
            trades = []
            for i in range(1, len(closes)):
                if pd.isna(closes[i]): continue
                
                if pos == 0 and buy_signals[i]:
                    pos = capital / closes[i]
                    entry = closes[i]
                    capital = 0.0
                elif pos > 0 and sell_signals[i]:
                    capital = pos * closes[i]
                    trades.append(capital - (pos * entry))
                    pos = 0
                    
            if pos > 0: 
                trades.append((pos * closes[-1]) - (pos * entry))
                
            profit = sum(trades)
            win_rate = len([t for t in trades if t > 0]) / len(trades) * 100 if len(trades) > 0 else 0
            return {'Timeframe': tf_name, 'Rule': rule_name, 'Param': param_name, 'Profit': profit, 'Trades': len(trades), 'WinRate': win_rate}

        # Rules
        buy = (df['ema_10'].shift(1) < df['ema_20'].shift(1)) & (df['ema_10'] > df['ema_20'])
        sell = (df['ema_10'].shift(1) > df['ema_20'].shift(1)) & (df['ema_10'] < df['ema_20'])
        all_results.append(run_vectorized_test(buy.to_numpy(), sell.to_numpy(), "EMA_Cross", "10/20"))
        
        buy = (df['ema_50'].shift(1) < df['ema_200'].shift(1)) & (df['ema_50'] > df['ema_200'])
        sell = (df['ema_50'].shift(1) > df['ema_200'].shift(1)) & (df['ema_50'] < df['ema_200'])
        all_results.append(run_vectorized_test(buy.to_numpy(), sell.to_numpy(), "EMA_Cross", "50/200"))

        buy = (df['rsi_14'].shift(1) < 30) & (df['rsi_14'] >= 30)
        sell = (df['rsi_14'].shift(1) > 70) & (df['rsi_14'] <= 70)
        all_results.append(run_vectorized_test(buy.to_numpy(), sell.to_numpy(), "RSI_Reversion", "14"))

        buy = (df['macd'].shift(1) < 0) & (df['macd'] >= 0)
        sell = (df['macd'].shift(1) > 0) & (df['macd'] <= 0)
        all_results.append(run_vectorized_test(buy.to_numpy(), sell.to_numpy(), "MACD_ZeroCross", "12/26"))

        buy = (df['close'].shift(1) < df['bb_low'].shift(1)) & (df['close'] >= df['bb_low'])
        sell = (df['close'].shift(1) > df['bb_high'].shift(1)) & (df['close'] <= df['bb_high'])
        all_results.append(run_vectorized_test(buy.to_numpy(), sell.to_numpy(), "BB_Reversion", "20/2.0"))

        buy_ema = (df['ema_10'].shift(1) < df['ema_20'].shift(1)) & (df['ema_10'] > df['ema_20'])
        sell_ema = (df['ema_10'].shift(1) > df['ema_20'].shift(1)) & (df['ema_10'] < df['ema_20'])
        buy = buy_ema & (df['rsi_14'] > 50)
        sell = sell_ema & (df['rsi_14'] < 50)
        all_results.append(run_vectorized_test(buy.to_numpy(), sell.to_numpy(), "COMBINED", "EMA10/20 + RSI>50 Filter"))

        buy = (df['close'] > df['bb_high']) & (df['macd'] > df['macd_signal'])
        sell = (df['close'] < df['bb_low']) & (df['macd'] < df['macd_signal'])
        all_results.append(run_vectorized_test(buy.to_numpy(), sell.to_numpy(), "COMBINED", "BB_Breakout + MACD"))

        buy_macd = (df['macd'].shift(1) < df['macd_signal'].shift(1)) & (df['macd'] > df['macd_signal'])
        sell_macd = (df['macd'].shift(1) > df['macd_signal'].shift(1)) & (df['macd'] < df['macd_signal'])
        buy = buy_macd & (df['stoch_k'] < 80)
        sell = sell_macd & (df['stoch_k'] > 20)
        all_results.append(run_vectorized_test(buy.to_numpy(), sell.to_numpy(), "COMBINED", "MACD_Cross + Stoch Valid"))

    mt5.shutdown()

    res_df = pd.DataFrame([r for r in all_results if r['Trades'] > 10])
    if res_df.empty:
        print("[-] No rules generated enough trades.")
        return
        
    res_df.sort_values('Profit', ascending=False, inplace=True)
    
    report_md = f"# ⏱ Multi-Timeframe Vector Backtest Report\n\n"
    report_md += f"**Symbol**: XAUUSD\n"
    report_md += f"**Timeframes**: M1, M5, M15 (ย้อนหลัง 1 ปี)\n"
    report_md += f"**Execution**: High-Speed Python Pandas Vectorization\n\n"
    
    report_md += "## 🏆 Top 10 Strategies Across ALL Timeframes\n\n"
    report_md += "| Rank | Timeframe | Rule Type | Parameters/Filters | Profit ($) | Win Rate (%) | Total Trades |\n"
    report_md += "|---|---|---|---|---|---|---|\n"
    
    for idx, row in enumerate(res_df.head(10).itertuples(), 1):
        report_md += f"| {idx} | **{row.Timeframe}** | **{row.Rule}** | {row.Param} | ${row.Profit:,.2f} | {row.WinRate:.1f}% | {row.Trades} |\n"
        
    report_md += "\n## 💡 Key Insights by Timeframe\n"
    
    for tf_name in ["M1", "M5", "M15"]:
        tf_df = res_df[res_df['Timeframe'] == tf_name]
        if not tf_df.empty:
            best_tf = tf_df.iloc[0]
            report_md += f"### จ้าวแห่ง {tf_name}\n"
            report_md += f"- **{best_tf['Rule']} ({best_tf['Param']})**: ทำกำไร ${best_tf['Profit']:,.2f} (Win Rate: {best_tf['WinRate']:.1f}%)\n"
    
    report_md += f"\n> [!TIP]\n"
    report_md += f"> สถิตินี้ชี้ให้เห็นว่า ระบบเทรดเดียวกันอาจจะกำไรมหาศาลใน M15 แต่ขาดทุนยับเยินใน M1 การรู้ Timeframe ที่เหมาะสมคือหัวใจหลัก!\n"
    
    kb_path = WORKSPACE_DIR / "raw" / "Multi_TF_Stats_Analysis.md"
    kb_path.write_text(report_md, encoding='utf-8')
    print(f"\n[+] Massive test complete! Report saved to {kb_path}")

if __name__ == "__main__":
    run_multi_tf_optimization()
