import MetaTrader5 as mt5
import pandas as pd
import numpy as np
from datetime import datetime

# Import our engine
from python_mt5_engine import MT5Engine

class AgentBacktester:
    def __init__(self, initial_capital: float = 10000.0, risk_per_trade: float = 0.01, rr_ratio: float = 2.0):
        self.engine = MT5Engine()
        self.initial_capital = initial_capital
        self.capital = initial_capital
        self.risk_per_trade = risk_per_trade
        self.rr_ratio = rr_ratio
        
        self.trades = []
        self.wins = 0
        self.losses = 0

    def run_backtest(self, symbol: str = "XAUUSD", timeframe: int = mt5.TIMEFRAME_M15, num_bars: int = 5000):
        print(f"=== Starting SMC Backtest ===")
        print(f"Symbol: {symbol} | Initial Capital: ${self.initial_capital:,.2f}")
        print(f"Risk Per Trade: {self.risk_per_trade*100}% | RR Ratio: 1:{self.rr_ratio}")
        print(f"Loading {num_bars} bars from MT5...")
        
        if not self.engine.connect():
            print("Connection failed.")
            return

        df = self.engine.get_data(symbol, timeframe, num_bars)
        if df.empty:
            print("No data received.")
            self.engine.disconnect()
            return
            
        print("Calculating SMC Structure and Indicators...")
        df = self.engine.add_smc_indicators(df)
        df = self.engine.calculate_smc_structure(df)
        
        # Simulation Loop
        # We start from index 200 to allow VPVR calculation
        print("Running Simulation Loop...")
        
        in_trade = False
        trade_direction = None
        entry_price = 0.0
        sl = 0.0
        tp = 0.0
        lot_size = 0.0
        entry_time = None
        
        closes = df['close'].values
        highs = df['high'].values
        lows = df['low'].values
        times = df['time'].values
        events = df['structure_event'].values
        atrs = df['atr'].values
        
        for i in range(200, len(df)):
            # 1. Manage existing trade
            if in_trade:
                current_high = highs[i]
                current_low = lows[i]
                
                result = None
                if trade_direction == "BUY":
                    if current_low <= sl:
                        result = "LOSS"
                        exit_price = sl
                    elif current_high >= tp:
                        result = "WIN"
                        exit_price = tp
                else: # SELL
                    if current_high >= sl:
                        result = "LOSS"
                        exit_price = sl
                    elif current_low <= tp:
                        result = "WIN"
                        exit_price = tp
                        
                if result:
                    pnl = 0
                    if result == "WIN":
                        self.wins += 1
                        risk_amount = self.capital * self.risk_per_trade
                        pnl = risk_amount * self.rr_ratio
                    else:
                        self.losses += 1
                        pnl = -(self.capital * self.risk_per_trade)
                        
                    self.capital += pnl
                    self.trades.append({
                        "entry_time": entry_time,
                        "exit_time": times[i],
                        "direction": trade_direction,
                        "entry_price": entry_price,
                        "exit_price": exit_price,
                        "pnl": pnl,
                        "capital": self.capital
                    })
                    
                    in_trade = False
                    trade_direction = None
                continue

            # 2. Look for new setup if not in a trade
            event = events[i]
            if event and isinstance(event, str) and ("BOS" in event or "CHoCH" in event):
                # Calculate Volume Profile for last 200 bars to act as a filter
                # (For speed, we skip full VPVR check here and just assume SMC is enough, 
                # but you could add the filter like so:)
                # window_df = df.iloc[i-200:i]
                # vp = self.engine.calculate_volume_profile(window_df)
                
                direction = "BUY" if "Bullish" in event else "SELL"
                entry_price = closes[i]
                atr = atrs[i]
                
                if pd.isna(atr): continue
                
                # SL is 1.5 ATR
                sl_dist = atr * 1.5
                if direction == "BUY":
                    sl = entry_price - sl_dist
                    tp = entry_price + (sl_dist * self.rr_ratio)
                else:
                    sl = entry_price + sl_dist
                    tp = entry_price - (sl_dist * self.rr_ratio)
                    
                in_trade = True
                trade_direction = direction
                entry_time = times[i]
                
        self.engine.disconnect()
        self.print_report()

    def print_report(self):
        print("\n" + "="*40)
        print("          BACKTEST RESULTS")
        print("="*40)
        total_trades = self.wins + self.losses
        win_rate = (self.wins / total_trades * 100) if total_trades > 0 else 0
        
        print(f"Total Trades: {total_trades}")
        print(f"Wins: {self.wins} | Losses: {self.losses}")
        print(f"Win Rate: {win_rate:.2f}%")
        print(f"Starting Capital: ${self.initial_capital:,.2f}")
        print(f"Ending Capital:   ${self.capital:,.2f}")
        print(f"Net Profit:       ${self.capital - self.initial_capital:,.2f} ({((self.capital - self.initial_capital)/self.initial_capital)*100:.2f}%)")
        print("="*40)
        
        # Save report
        if total_trades > 0:
            df_trades = pd.DataFrame(self.trades)
            df_trades.to_csv("smc_backtest_results.csv", index=False)
            print("Detailed trades saved to smc_backtest_results.csv")

if __name__ == "__main__":
    tester = AgentBacktester(initial_capital=10000, risk_per_trade=0.01, rr_ratio=2.0)
    # Using 10000 bars for a solid test (approx 3-4 months on M15)
    tester.run_backtest(symbol="XAUUSD", timeframe=mt5.TIMEFRAME_M15, num_bars=10000)
