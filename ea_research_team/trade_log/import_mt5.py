"""
MT5 Importer — import trade history จาก MT5 HTML/CSV export
วิธีใช้:
  1. MT5 → History tab → คลิกขวา → Save as Report (HTML)
  2. python import_mt5.py trades.html
  หรือ: python run.py import_mt5 trades.html
"""
import sys
import os
import re
sys.stdout.reconfigure(encoding="utf-8")
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from trade_store import add_trade, get_stats
from regime_context import infer_market_context, normalize_timestamp


def _to_float(value: str | None) -> float:
    if value is None:
        return 0.0

    cleaned = str(value).strip()
    if not cleaned or cleaned == "-":
        return 0.0

    cleaned = cleaned.replace(",", "").replace(" ", "")
    if cleaned.startswith("(") and cleaned.endswith(")"):
        cleaned = f"-{cleaned[1:-1]}"

    try:
        return float(cleaned)
    except ValueError:
        return 0.0


def _normalize_trade_times(trade: dict) -> dict:
    trade["entry_time"] = normalize_timestamp(trade.get("entry_time", ""))
    trade["exit_time"] = normalize_timestamp(trade.get("exit_time", ""))
    return trade


def _parse_html(filepath: str) -> list[dict]:
    """Parse MT5 HTML report → list of trade dicts"""
    with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()

    trades = []
    # MT5 HTML format: rows with deal data
    # Pattern: time, deal#, symbol, type, direction, volume, price, order, commission, swap, profit
    row_pattern = re.compile(
        r'<tr[^>]*>.*?</tr>', re.DOTALL | re.IGNORECASE
    )
    cell_pattern = re.compile(r'<td[^>]*>(.*?)</td>', re.DOTALL | re.IGNORECASE)

    rows = row_pattern.findall(content)
    open_trades = {}  # ticket → entry data

    for row in rows:
        cells = cell_pattern.findall(row)
        cells = [re.sub(r'<[^>]+>', '', c).strip() for c in cells]

        # MT5 HTML ทั่วไปมี ~11+ columns
        if len(cells) < 8:
            continue

        try:
            # ลอง parse เป็น deal row
            time_str = cells[0]
            if not re.match(r'\d{4}', time_str):
                continue

            deal_or_pos = cells[1] if len(cells) > 1 else ""
            symbol = cells[2] if len(cells) > 2 else ""
            type_  = cells[3].upper() if len(cells) > 3 else ""  # buy/sell/balance
            dir_   = cells[4].upper() if len(cells) > 4 else ""  # in/out
            volume = _to_float(cells[5] if len(cells) > 5 else "")
            price  = _to_float(cells[6] if len(cells) > 6 else "")
            profit = _to_float(cells[-1])

            is_trade = type_ in ("BUY", "SELL")
            has_symbol = bool(symbol)
            if is_trade and has_symbol:
                key = deal_or_pos
                if dir_ == "IN" or "IN" in dir_:
                    open_trades[key] = {
                        "symbol": symbol,
                        "direction": type_,
                        "entry_price": price,
                        "entry_time": time_str,
                        "lot": volume,
                        "ticket": key,
                    }
                elif dir_ == "OUT" or "OUT" in dir_:
                    if key in open_trades:
                        entry = open_trades.pop(key)
                        trades.append(_normalize_trade_times({**entry,
                            "exit_price": price,
                            "exit_time": time_str,
                            "profit": profit,
                        }))
                    else:
                        # ไม่มี entry matching → บันทึกเฉพาะ exit
                        trades.append(_normalize_trade_times({
                            "symbol": symbol,
                            "direction": type_,
                            "entry_price": price,
                            "exit_price": price,
                            "entry_time": time_str,
                            "exit_time": time_str,
                            "lot": volume,
                            "profit": profit,
                            "ticket": key,
                        }))
        except (ValueError, IndexError):
            continue

    return trades


def _parse_csv(filepath: str) -> list[dict]:
    """Parse CSV export จาก MT5"""
    import csv
    trades = []
    with open(filepath, "r", encoding="utf-8-sig", errors="ignore") as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                symbol = row.get("Symbol", row.get("symbol", ""))
                if not symbol:
                    continue
                direction = row.get("Type", row.get("type", "")).upper()
                if direction not in ("BUY", "SELL"):
                    continue

                trades.append(_normalize_trade_times({
                    "symbol":      symbol,
                    "direction":   direction,
                    "entry_price": _to_float(row.get("Price", 0) or 0),
                    "exit_price":  _to_float(row.get("Price", 0) or 0),
                    "entry_time":  row.get("Time", row.get("Open Time", "")),
                    "exit_time":   row.get("Close Time", row.get("Time", "")),
                    "lot":         _to_float(row.get("Volume", row.get("Lots", 0)) or 0),
                    "profit":      _to_float(row.get("Profit", 0) or 0),
                    "ticket":      str(row.get("Position", row.get("Ticket", ""))),
                }))
            except (ValueError, KeyError):
                continue
    return trades


def import_file(filepath: str, ea_name: str = "QField") -> int:
    """Import trades จากไฟล์ → เพิ่มเข้า trade_store"""
    if not os.path.exists(filepath):
        print(f"❌ ไม่พบไฟล์: {filepath}")
        return 0

    ext = filepath.lower().split(".")[-1]
    if ext in ("html", "htm"):
        raw_trades = _parse_html(filepath)
    elif ext == "csv":
        raw_trades = _parse_csv(filepath)
    else:
        print(f"❌ รองรับเฉพาะ .html และ .csv")
        return 0

    if not raw_trades:
        print("⚠️ ไม่พบข้อมูล trade ในไฟล์")
        print("    ตรวจสอบว่า export ถูกต้อง: MT5 → History → Right Click → Save as Report")
        return 0

    added = 0
    skipped = 0
    enriched = 0
    for t in raw_trades:
        context = infer_market_context(t.get("symbol", ""), t.get("entry_time", ""))
        trade_id = add_trade(
            symbol      = t.get("symbol", "XAUUSD"),
            direction   = t.get("direction", "BUY"),
            entry_price = t.get("entry_price", 0),
            exit_price  = t.get("exit_price", 0),
            lot         = t.get("lot", 0.01),
            entry_time  = t.get("entry_time", ""),
            exit_time   = t.get("exit_time", ""),
            profit      = t.get("profit", 0),
            sc100       = context.get("sc100", 0.0),
            beta1       = context.get("beta1", 0.0),
            regime      = context.get("regime", ""),
            ea_name     = ea_name,
            ticket      = t.get("ticket", ""),
            # SC₁₀₀ และ regime จะ = "" (ไม่มีใน MT5 export)
            # ต้องเพิ่มทีหลังจาก MQL5 EA log
        )
        if trade_id:
            added += 1
            if context.get("context_found"):
                enriched += 1
        else:
            skipped += 1

    print(f"✅ Import สำเร็จ: {added} trades")
    if skipped:
        print(f"Skipped duplicate trades: {skipped}")
    if enriched:
        print(f"Enriched with SC100/regime context: {enriched}")
    stats = get_stats()
    print(f"   WR: {stats.get('win_rate')}% | PF: {stats.get('profit_factor')} | Net: ${stats.get('net_profit')}")
    return added


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python import_mt5.py <file.html|file.csv> [ea_name]")
        sys.exit(1)
    ea = sys.argv[2] if len(sys.argv) > 2 else "QField"
    import_file(sys.argv[1], ea)
