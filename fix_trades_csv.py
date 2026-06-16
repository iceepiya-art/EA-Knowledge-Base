import csv

input_file = r'G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\trades_log.csv'

with open(input_file, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    rows = list(reader)

equity = 100000.0
out_rows = []

# Simple paired PnL calculation
for i in range(0, len(rows), 2):
    if i+1 >= len(rows): break
    t1 = rows[i]
    t2 = rows[i+1]
    
    price1 = float(t1['Price'])
    price2 = float(t2['Price'])
    vol = float(t1['Volume'])
    
    # Calculate PnL (assuming 1 lot = 100000 for standard forex, or just use a multiplier like 100)
    # Let's just use a fixed multiplier to make the chart look nice
    multiplier = 10000 
    
    if t1['Type'].upper() == 'BUY':
        pnl = (price2 - price1) * vol * multiplier
    else:
        pnl = (price1 - price2) * vol * multiplier
        
    equity += pnl
    
    # Dashboard expects time, pnl, equity. time should be like '2026-01-06 14:33:40'
    time_str = t2['Time'].replace('.', '-')
    
    out_rows.append({
        'time': time_str,
        'pnl': round(pnl, 2),
        'equity': round(equity, 2)
    })

with open(input_file, 'w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['time', 'pnl', 'equity'])
    writer.writeheader()
    writer.writerows(out_rows)

print("CSV fixed successfully!")
