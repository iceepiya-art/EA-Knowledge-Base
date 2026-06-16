"""HistData Importer for MT5

Downloads XAUUSD Tick Data from HistData.com and automatically injects it into 
a Custom Symbol 'XAUUSD_Hist' in MetaTrader 5.
"""
import os
import sys
import glob
import zipfile
import pandas as pd
import numpy as np
from datetime import datetime
from pathlib import Path

try:
    import MetaTrader5 as mt5
    from histdata import download_hist_data
except ImportError:
    print("Dependencies missing. Please run: pip install MetaTrader5 pandas histdata")
    sys.exit(1)

# Configuration
SYMBOL = "XAUUSD"
CUSTOM_SYMBOL = f"{SYMBOL}_Hist"
START_YEAR = 2019
END_YEAR = 2023
DATA_DIR = Path("data/histdata")
DATA_DIR.mkdir(parents=True, exist_ok=True)

def download_data():
    """Download Tick Data from HistData.com"""
    print(f"[1/3] Downloading {SYMBOL} Tick Data ({START_YEAR}-{END_YEAR})...")
    
    for year in range(START_YEAR, END_YEAR + 1):
        print(f"  -> Downloading {year}...")
        try:
            download_hist_data(
                year=str(year),
                month=None,
                pair=SYMBOL.lower(),
                platform='generic',
                time_frame='M1',
                output_directory=str(DATA_DIR)
            )
        except Exception as e:
            print(f"     [!] Failed to download {year}: {e}")

def parse_and_inject():
    """Parse CSVs and inject into MT5"""
    print("\n[2/3] Connecting to MetaTrader 5...")
    if not mt5.initialize():
        print(f"[-] initialize() failed, error code = {mt5.last_error()}")
        sys.exit(1)
        
    print(f"  -> MT5 Version: {mt5.version()}")
    
    # Check if Custom Symbol exists
    symbol_info = mt5.symbol_info(CUSTOM_SYMBOL)
    if symbol_info is None:
        print(f"[-] Custom Symbol '{CUSTOM_SYMBOL}' not found!")
        print(f"    Please create it manually in MT5:")
        print(f"    1. Right-click Market Watch -> Custom Symbols")
        print(f"    2. Click 'Create Custom Symbol'")
        print(f"    3. Symbol: {CUSTOM_SYMBOL}")
        print(f"    4. Copy from: {SYMBOL}")
        print(f"    5. Click OK, then run this script again.")
        mt5.shutdown()
        sys.exit(1)
    else:
        print(f"  -> Custom Symbol '{CUSTOM_SYMBOL}' found. Injecting data...")

    print("\n[3/3] Parsing ZIP/CSV files and injecting ticks into MT5...")
    
    # Process both .zip and .csv files
    data_files = sorted(glob.glob(str(DATA_DIR / "*.zip"))) + sorted(glob.glob(str(DATA_DIR / "*.csv")))
    if not data_files:
        print("[-] No zip or csv files found to process.")
        return

    for file_path in data_files:
        print(f"  -> Processing: {Path(file_path).name}")
        
        if file_path.endswith(".zip"):
            print("     [!] Skipping .zip file. Please extract it first if it contains ticks.")
        else:
            process_dataframe(file_path)

    print("\n[✔] SUCCESS: Historical Tick Data injection completed!")
    mt5.shutdown()

def process_dataframe(file_path):
    """Helper to convert and inject the dataframe in chunks to save RAM"""
    print(f"     -> Reading and injecting {Path(file_path).name} in chunks...")
    
    chunk_size = 1000000 # 1 million ticks per chunk
    total_injected = 0
    
    # Format: 2020.05.05 00:00:00.640,1703.505,1703.842
    for chunk in pd.read_csv(file_path, header=None, names=["DateTime", "Bid", "Ask"], chunksize=chunk_size):
        chunk['DateTime'] = pd.to_datetime(chunk['DateTime'], format="%Y.%m.%d %H:%M:%S.%f")
        
        ticks = np.zeros(len(chunk), dtype=[
            ('time', 'i8'), 
            ('bid', 'f8'), 
            ('ask', 'f8'), 
            ('last', 'f8'), 
            ('volume', 'u8'), 
            ('time_msc', 'i8'), 
            ('flags', 'u4'), 
            ('volume_real', 'f8')
        ])
        
        ticks['time'] = chunk['DateTime'].astype('int64') // 10**9
        ticks['time_msc'] = chunk['DateTime'].astype('int64') // 10**6
        ticks['bid'] = chunk['Bid']
        ticks['ask'] = chunk['Ask']
        ticks['flags'] = 6 # TICK_FLAG_BID | TICK_FLAG_ASK
        
        result = mt5.custom_ticks_add(CUSTOM_SYMBOL, ticks)
        if result == -1:
            print(f"     [-] Failed to add ticks chunk: {mt5.last_error()}")
        else:
            total_injected += result
            print(f"     [+] Injected {total_injected:,} ticks so far...")
            
    print(f"     [✔] Completed file. Total ticks injected: {total_injected:,}")

if __name__ == "__main__":
    # download_data() # Skip download since user provided the file
    parse_and_inject()
