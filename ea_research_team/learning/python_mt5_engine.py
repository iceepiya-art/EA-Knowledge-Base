import MetaTrader5 as mt5
import pandas as pd
import pandas_ta as ta
import numpy as np
from datetime import datetime

class MT5Engine:
    def __init__(self):
        self.connected = False

    def connect(self):
        """Initialize connection to MetaTrader 5"""
        if not mt5.initialize():
            print("initialize() failed, error code =", mt5.last_error())
            self.connected = False
            return False
        self.connected = True
        print(f"MetaTrader5 package version: {mt5.__version__}")
        return True

    def disconnect(self):
        """Disconnect from MT5"""
        if self.connected:
            mt5.shutdown()
            self.connected = False

    def get_data(self, symbol: str, timeframe: int, num_bars: int = 500) -> pd.DataFrame:
        """
        Fetch OHLCV data from MT5
        timeframe examples: mt5.TIMEFRAME_M15, mt5.TIMEFRAME_H1
        """
        if not self.connected:
            self.connect()
            
        rates = mt5.copy_rates_from_pos(symbol, timeframe, 0, num_bars)
        if rates is None:
            print(f"Failed to get rates for {symbol}")
            return pd.DataFrame()
            
        df = pd.DataFrame(rates)
        df['time'] = pd.to_datetime(df['time'], unit='s')
        return df

    def add_smc_indicators(self, df: pd.DataFrame, pivot_len=8, atr_len=14, ema_fast=9, ema_slow=21) -> pd.DataFrame:
        """
        Calculate AlphaEdge-like Base Indicators:
        - EMA Fast / Slow
        - ATR
        - Pivot High / Low
        """
        if df.empty:
            return df
            
        # 1. EMAs and ATR
        df['ema_fast'] = ta.ema(df['close'], length=ema_fast)
        df['ema_slow'] = ta.ema(df['close'], length=ema_slow)
        df['atr'] = ta.atr(df['high'], df['low'], df['close'], length=atr_len)
        
        # 2. Pivot High / Low (Swing Highs and Lows)
        # Using a rolling window approach similar to ta.pivothigh / pivotlow in pine script
        def get_pivot_high(highs, left, right):
            window = highs.values
            center = window[left]
            if center == max(window):
                return center
            return np.nan

        def get_pivot_low(lows, left, right):
            window = lows.values
            center = window[left]
            if center == min(window):
                return center
            return np.nan

        window_size = pivot_len * 2 + 1
        df['pivot_high'] = df['high'].rolling(window=window_size, center=True).apply(
            lambda x: get_pivot_high(x, pivot_len, pivot_len), raw=False
        )
        df['pivot_low'] = df['low'].rolling(window=window_size, center=True).apply(
            lambda x: get_pivot_low(x, pivot_len, pivot_len), raw=False
        )
        
        # Fill NaN backwards to simulate "knowing" the pivot after 'right' bars have passed
        df['last_ph'] = df['pivot_high'].ffill()
        df['last_pl'] = df['pivot_low'].ffill()
        
        return df

    def calculate_volume_profile(self, df: pd.DataFrame, bins: int = 50) -> dict:
        """
        Calculate Volume Profile, POC, VAH, and VAL for the given dataframe window.
        """
        if df.empty:
            return {}
            
        # Use real_volume if available, else tick_volume
        vol_col = 'real_volume' if 'real_volume' in df.columns and df['real_volume'].sum() > 0 else 'tick_volume'
        
        prices = df['close'].values
        volumes = df[vol_col].values
        
        # Create price bins
        hist, bin_edges = np.histogram(prices, bins=bins, weights=volumes)
        
        # Calculate POC (Point of Control)
        poc_idx = np.argmax(hist)
        poc = (bin_edges[poc_idx] + bin_edges[poc_idx + 1]) / 2.0
        
        # Calculate Value Area (70% of total volume)
        total_vol = np.sum(hist)
        va_vol_target = total_vol * 0.70
        
        # Start VA from POC and expand outwards
        va_vol = hist[poc_idx]
        va_indices = [poc_idx]
        
        upper_idx = poc_idx + 1
        lower_idx = poc_idx - 1
        
        while va_vol < va_vol_target and (upper_idx < len(hist) or lower_idx >= 0):
            upper_vol = hist[upper_idx] if upper_idx < len(hist) else -1
            lower_vol = hist[lower_idx] if lower_idx >= 0 else -1
            
            if upper_vol > lower_vol:
                va_vol += upper_vol
                va_indices.append(upper_idx)
                upper_idx += 1
            else:
                if lower_vol >= 0:
                    va_vol += lower_vol
                    va_indices.append(lower_idx)
                    lower_idx -= 1
                else:
                    break
                    
        val = bin_edges[min(va_indices)]
        vah = bin_edges[max(va_indices) + 1]
        
        return {
            "POC": poc,
            "VAH": vah,
            "VAL": val,
            "Total_Volume": total_vol
        }

    def calculate_smc_structure(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Identify Break of Structure (BOS) and Change of Character (CHoCH).
        """
        if 'last_ph' not in df.columns or 'last_pl' not in df.columns:
            return df
            
        # Simple Logic: 
        # BOS Bullish = Close > Last Pivot High
        # BOS Bearish = Close < Last Pivot Low
        
        # Check cross above/below
        df['cross_above_ph'] = (df['close'] > df['last_ph']) & (df['close'].shift(1) <= df['last_ph'].shift(1))
        df['cross_below_pl'] = (df['close'] < df['last_pl']) & (df['close'].shift(1) >= df['last_pl'].shift(1))
        
        # Trend Context (Simplistic for now, normally tracks sequence of HH/HL)
        # If we cross above PH, it's Bullish BOS. If trend was bearish, it's Bullish CHoCH.
        df['structure_event'] = None
        
        current_trend = 1 # 1 = Bullish, -1 = Bearish
        
        events = []
        for i in range(len(df)):
            event = None
            if df['cross_above_ph'].iloc[i]:
                if current_trend == -1:
                    event = "CHoCH Bullish"
                    current_trend = 1
                else:
                    event = "BOS Bullish"
            elif df['cross_below_pl'].iloc[i]:
                if current_trend == 1:
                    event = "CHoCH Bearish"
                    current_trend = -1
                else:
                    event = "BOS Bearish"
            events.append(event)
            
        df['structure_event'] = events
        return df

if __name__ == "__main__":
    engine = MT5Engine()
    if engine.connect():
        print("Fetching XAUUSD M15 Data...")
        df = engine.get_data("XAUUSD", mt5.TIMEFRAME_M15, 200)
        
        if not df.empty:
            df = engine.add_smc_indicators(df)
            df = engine.calculate_smc_structure(df)
            vp = engine.calculate_volume_profile(df)
            
            print("\n=== Volume Profile Analysis ===")
            print(f"POC: {vp.get('POC')}")
            print(f"VAH: {vp.get('VAH')}")
            print(f"VAL: {vp.get('VAL')}")
            
            print("\n=== Recent SMC Events ===")
            events_df = df.dropna(subset=['structure_event'])
            if not events_df.empty:
                print(events_df[['time', 'close', 'structure_event']].tail(5))
            else:
                print("No recent SMC events found in this window.")
        
        engine.disconnect()
