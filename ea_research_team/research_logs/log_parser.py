"""
Gold Breakout Research Log Parser
วิเคราะห์ setup_log.csv + trade_log.csv แล้วพิมพ์รายงานสรุป
"""
import csv
import os
import sys
import io
from collections import defaultdict
from datetime import datetime

# fix Windows terminal encoding
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
DEFAULT_DIR = os.path.join(os.path.dirname(__file__), "fix4_backtest_20260507")
PREFIX      = "gold_breakout_fix4"

# ---------------------------------------------------------------------------
# Loaders
# ---------------------------------------------------------------------------
def load_csv(path):
    rows = []
    with open(path, encoding="utf-8", errors="replace") as f:
        reader = csv.DictReader(f)
        for r in reader:
            rows.append(r)
    return rows

def load_logs(folder, prefix):
    setup_path = os.path.join(folder, f"{prefix}_setup_log.csv")
    trade_path = os.path.join(folder, f"{prefix}_trade_log.csv")
    if not os.path.exists(setup_path):
        sys.exit(f"[ERR] ไม่พบ {setup_path}")
    if not os.path.exists(trade_path):
        sys.exit(f"[ERR] ไม่พบ {trade_path}")
    return load_csv(setup_path), load_csv(trade_path)

# ---------------------------------------------------------------------------
# Build trades — ใช้ CLOSE events เป็นหลัก, join OPEN ด้วย setup_id
# ---------------------------------------------------------------------------
def build_trades(trade_rows, setup_rows):
    # setup_id -> first setup row
    setup_map = {}
    for r in setup_rows:
        sid = r["setup_id"]
        if sid not in setup_map:
            setup_map[sid] = r

    # setup_id -> last OPEN row (สำหรับ entry_price)
    open_map = {}
    for r in trade_rows:
        if r["event"] == "OPEN":
            open_map[r["setup_id"]] = r

    trades = []
    unmatched = 0
    open_count  = sum(1 for r in trade_rows if r["event"] == "OPEN")
    close_count = sum(1 for r in trade_rows if r["event"] == "CLOSE")

    for r in trade_rows:
        if r["event"] != "CLOSE":
            continue
        sid    = r["setup_id"]
        setup  = setup_map.get(sid)
        open_r = open_map.get(sid)
        profit = float(r["profit"]) if r["profit"] else 0.0
        direction = (setup or open_r or {}).get("direction", r.get("direction", ""))
        entry = float(open_r["entry_price"]) if open_r and open_r["entry_price"] else 0.0
        trades.append({
            "setup_id":    sid,
            "direction":   direction,
            "entry_price": entry,
            "close_price": float(r["close_price"]) if r["close_price"] else 0.0,
            "lot":         float(r["lot"]) if r["lot"] else 0.0,
            "profit":      profit,
            "exit_reason": r["exit_reason"],
            "open_time":   open_r["timestamp"] if open_r else r["timestamp"],
            "close_time":  r["timestamp"],
            "mindset":     (setup or {}).get("mindset", ""),
        })
        if not setup:
            unmatched += 1
    return trades, open_count, close_count, unmatched

# ---------------------------------------------------------------------------
# Stats
# ---------------------------------------------------------------------------
def calc_stats(trades, label="ALL"):
    if not trades:
        return
    profits = [t["profit"] for t in trades]
    wins    = [p for p in profits if p > 0]
    losses  = [p for p in profits if p <= 0]
    total   = len(profits)
    wr      = len(wins) / total * 100 if total else 0
    gross_p = sum(wins)
    gross_l = abs(sum(losses))
    pf      = gross_p / gross_l if gross_l > 0 else float("inf")
    avg_w   = sum(wins)   / len(wins)   if wins   else 0
    avg_l   = sum(losses) / len(losses) if losses else 0
    net     = sum(profits)
    rr      = abs(avg_w / avg_l) if avg_l != 0 else 0

    print(f"\n{'='*52}")
    print(f"  {label}")
    print(f"{'='*52}")
    print(f"  Trades      : {total:>6}  |  Wins: {len(wins)}  Losses: {len(losses)}")
    print(f"  Win Rate    : {wr:>6.1f}%")
    print(f"  Net Profit  : {net:>10.2f}")
    print(f"  Gross Profit: {gross_p:>10.2f}  |  Gross Loss: {-gross_l:.2f}")
    print(f"  Profit Factor: {pf:>6.2f}")
    print(f"  Avg Win     : {avg_w:>8.2f}  |  Avg Loss : {avg_l:.2f}")
    print(f"  Avg RR      : {rr:>6.2f}x")
    print(f"  Largest Win : {max(wins,default=0):>8.2f}  |  Largest Loss: {min(losses,default=0):.2f}")

def calc_exit_breakdown(trades):
    counts = defaultdict(int)
    pnl    = defaultdict(float)
    for t in trades:
        r = t["exit_reason"] or "UNKNOWN"
        counts[r] += 1
        pnl[r]    += t["profit"]
    print(f"\n  Exit Reason Breakdown:")
    print(f"  {'Reason':<15} {'Count':>6}  {'Net P&L':>10}")
    print(f"  {'-'*35}")
    for r in sorted(counts):
        print(f"  {r:<15} {counts[r]:>6}  {pnl[r]:>10.2f}")

def calc_monthly(trades):
    monthly = defaultdict(list)
    for t in trades:
        try:
            dt = datetime.strptime(t["open_time"], "%Y.%m.%d %H:%M:%S")
            key = dt.strftime("%Y-%m")
        except:
            key = "unknown"
        monthly[key].append(t["profit"])

    print(f"\n  Monthly P&L:")
    print(f"  {'Month':<10} {'Trades':>6}  {'Net P&L':>10}  {'WR%':>7}")
    print(f"  {'-'*38}")
    for month in sorted(monthly):
        ps  = monthly[month]
        net = sum(ps)
        wr  = sum(1 for p in ps if p > 0) / len(ps) * 100
        print(f"  {month:<10} {len(ps):>6}  {net:>10.2f}  {wr:>6.1f}%")

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    folder = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_DIR
    prefix = sys.argv[2] if len(sys.argv) > 2 else PREFIX

    print(f"\n[LOG PARSER] folder : {folder}")
    print(f"[LOG PARSER] prefix : {prefix}")

    setup_rows, trade_rows = load_logs(folder, prefix)
    trades, n_open, n_close, unmatched = build_trades(trade_rows, setup_rows)

    print(f"\n  Setup rows  : {len(setup_rows)}")
    print(f"  OPEN events : {n_open}")
    print(f"  CLOSE events: {n_close}  (= trades analyzed)")
    print(f"  Unmatched   : {unmatched} (no setup row for this setup_id)")

    # Overall
    calc_stats(trades, "OVERALL")
    calc_exit_breakdown(trades)
    calc_monthly(trades)

    # By direction
    buys  = [t for t in trades if t["direction"] == "BUY"]
    sells = [t for t in trades if t["direction"] == "SELL"]
    calc_stats(buys,  "BUY trades only")
    calc_stats(sells, "SELL trades only")

    print()

if __name__ == "__main__":
    main()
