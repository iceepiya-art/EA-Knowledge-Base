"""
EA report parsers — pure functions, no Flask, no data stores.
"""
from datetime import datetime
import html
import os
import re


def _read_file_autoenc(path: str) -> str:
    raw = open(path, "rb").read()
    if raw[:2] in (b"\xff\xfe", b"\xfe\xff"):
        return raw.decode("utf-16")
    if raw[:3] == b"\xef\xbb\xbf":
        return raw.decode("utf-8-sig")
    return raw.decode("utf-8", errors="ignore")


def _text_from_report(raw: str) -> str:
    raw = html.unescape(raw or "")
    raw = re.sub(r"(?is)<script.*?</script>|<style.*?</style>", " ", raw)
    raw = re.sub(r"(?is)<[^>]+>", " ", raw)
    raw = raw.replace("\xa0", " ")
    raw = re.sub(r"\s+", " ", raw)
    return raw.strip()


def _parse_mt5_trade_history(text: str) -> dict:
    # MT5 uses space as thousand separator: "9 265.60" → normalise first
    t = re.sub(r"(?<=\d) (?=\d{3}(?:[^\d]|$))", "", text)

    def grab(labels: list[str]) -> str:
        for lbl in labels:
            m = re.search(re.escape(lbl) + r"[:\s]*(-?[\d,]+(?:\.\d+)?)", t, re.IGNORECASE)
            if m:
                return m.group(1).replace(",", "")
        return ""

    wr_m    = re.search(r"Profit Trades \(% of total\)[:\s]*[\d,]+ \((\d+\.\d+)%\)", t)
    dd_m    = re.search(r"Balance Drawdown Maximal[:\s]*(-?[\d,]+(?:\.\d+)?) \((\d+\.\d+)%\)", t)
    short_m = re.search(r"Short Trades \(won %\)[:\s]*[\d,]+ \((\d+\.\d+)%\)", t)
    long_m  = re.search(r"Long Trades \(won %\)[:\s]*[\d,]+ \((\d+\.\d+)%\)", t)
    acc_m   = re.search(r"Account[:\s]*(\d+)", text)
    name_m  = re.search(r"Name[:\s]*(.+?)\s*Account:", text)
    co_m    = re.search(r"Company[:\s]*(.+?)\s*Date:", text)
    exp_m   = re.search(r"Date[:\s]*(\d{4}\.\d{2}\.\d{2}\s+\d{2}:\d{2})", text)
    trade_dates = re.findall(r"\b(\d{4}\.\d{2}\.\d{2})\s+\d{2}:\d{2}:\d{2}\b", text)
    syms    = list(dict.fromkeys(re.findall(r"\b(XAUUSDm?|NQ1?|EURUSD|GBPUSD|USDJPY|AUDUSD|USDCAD|USDCHF|NZDUSD)\b", text)))

    return {
        "report_type":     "trade_history",
        "account_id":      acc_m.group(1) if acc_m else "",
        "account_name":    name_m.group(1).strip() if name_m else "",
        "broker":          co_m.group(1).strip() if co_m else "",
        "symbol":          ", ".join(syms),
        "period_start":    trade_dates[0] if trade_dates else "",
        "period_end":      trade_dates[-1] if trade_dates else "",
        "exported_at":     exp_m.group(1) if exp_m else "",
        "net_profit":      grab(["Total Net Profit"]),
        "gross_profit":    grab(["Gross Profit"]),
        "gross_loss":      grab(["Gross Loss"]),
        "profit_factor":   grab(["Profit Factor"]),
        "drawdown":        (f"{dd_m.group(1)} ({dd_m.group(2)}%)" if dd_m else grab(["Balance Drawdown Maximal"])),
        "total_trades":    grab(["Total Trades"]),
        "win_rate":        ((wr_m.group(1) + "%") if wr_m else grab(["Profit Trades"])),
        "short_win_rate":  ((short_m.group(1) + "%") if short_m else ""),
        "long_win_rate":   ((long_m.group(1) + "%") if long_m else ""),
        "largest_profit":  grab(["Largest profit trade"]),
        "largest_loss":    grab(["Largest loss trade"]),
        "sharpe_ratio":    grab(["Sharpe Ratio"]),
        "recovery_factor": grab(["Recovery Factor"]),
        "expected_payoff": grab(["Expected Payoff"]),
    }


def _first_number_near(text: str, labels: list[str]) -> str:
    for label in labels:
        pattern = re.compile(re.escape(label) + r".{0,180}?(-?\d[\d,]*(?:\.\d+)?%?)", re.IGNORECASE)
        match = pattern.search(text)
        if match:
            return match.group(1)
    return ""


def _parse_csv_backtest(text: str) -> dict:
    lines = [line for line in text.splitlines() if line.strip()]
    if not lines:
        return {}
    header = [h.strip().lower() for h in re.split(r",|\t|;", lines[0])]
    profit_idx = -1
    for key in ["profit", "net profit", "p/l", "pl"]:
        if key in header:
            profit_idx = header.index(key)
            break
    trades = wins = losses = 0
    net = gross_profit = gross_loss = 0.0
    open_dates = []
    close_dates = []
    symbols = []
    open_idx = next((i for i, h in enumerate(header) if h in ("open", "open time", "optime")), -1)
    close_idx = next((i for i, h in enumerate(header) if h in ("close", "close time", "closetime")), -1)
    sym_idx = next((i for i, h in enumerate(header) if h in ("symbol", "instrument", "pair")), -1)
    if profit_idx >= 0:
        for line in lines[1:]:
            cols = [c.strip().replace('"', "") for c in re.split(r",|\t|;", line)]
            if profit_idx >= len(cols):
                continue
            try:
                val = float(cols[profit_idx].replace(",", ""))
            except ValueError:
                continue
            trades += 1
            net += val
            if val > 0:
                wins += 1
                gross_profit += val
            elif val < 0:
                losses += 1
                gross_loss += val
            if open_idx >= 0 and open_idx < len(cols) and cols[open_idx]:
                open_dates.append(cols[open_idx][:10])
            if close_idx >= 0 and close_idx < len(cols) and cols[close_idx]:
                close_dates.append(cols[close_idx][:10])
            if sym_idx >= 0 and sym_idx < len(cols) and cols[sym_idx]:
                symbols.append(cols[sym_idx])
    if not trades:
        return {}
    pf = abs(gross_profit / gross_loss) if gross_loss else 0.0
    unique_syms = list(dict.fromkeys(symbols))
    return {
        "report_type": "forward_test",
        "net_profit": f"{net:.2f}",
        "gross_profit": f"{gross_profit:.2f}",
        "gross_loss": f"{gross_loss:.2f}",
        "total_trades": str(trades),
        "win_rate": f"{(wins / trades) * 100:.1f}%",
        "profit_factor": f"{pf:.2f}",
        "drawdown": "",
        "symbol": ", ".join(unique_syms[:6]),
        "period_start": min(open_dates) if open_dates else "",
        "period_end": max(close_dates) if close_dates else "",
    }


def _parse_backtest_report(path: str, content: str) -> dict:
    ext = os.path.splitext(path)[1].lower()
    text = _text_from_report(content)
    if ext == ".csv":
        metrics = _parse_csv_backtest(content)
    elif "Trade History Report" in text:
        metrics = _parse_mt5_trade_history(text)
    else:
        metrics = {
            "report_type":   "strategy_tester",
            "net_profit":    _first_number_near(text, ["Total Net Profit", "Net Profit", "Profit"]),
            "profit_factor": _first_number_near(text, ["Profit Factor", "PF"]),
            "drawdown":      _first_number_near(text, ["Maximal Drawdown", "Equity Drawdown Maximal", "Drawdown"]),
            "total_trades":  _first_number_near(text, ["Total Trades", "Trades"]),
            "win_rate":      _first_number_near(text, ["Profit Trades (% of total)", "Win Rate", "Won %"]),
        }
    return {
        "id":              datetime.now().strftime("%Y%m%d_%H%M%S"),
        "file":            os.path.basename(path),
        "path":            path,
        "imported_at":     datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "report_type":     metrics.get("report_type", "strategy_tester"),
        "account_id":      metrics.get("account_id", ""),
        "account_name":    metrics.get("account_name", ""),
        "broker":          metrics.get("broker", ""),
        "symbol":          metrics.get("symbol", ""),
        "period_start":    metrics.get("period_start", ""),
        "period_end":      metrics.get("period_end", ""),
        "exported_at":     metrics.get("exported_at", ""),
        "net_profit":      metrics.get("net_profit", ""),
        "gross_profit":    metrics.get("gross_profit", ""),
        "gross_loss":      metrics.get("gross_loss", ""),
        "profit_factor":   metrics.get("profit_factor", ""),
        "drawdown":        metrics.get("drawdown", ""),
        "total_trades":    metrics.get("total_trades", ""),
        "win_rate":        metrics.get("win_rate", ""),
        "short_win_rate":  metrics.get("short_win_rate", ""),
        "long_win_rate":   metrics.get("long_win_rate", ""),
        "largest_profit":  metrics.get("largest_profit", ""),
        "largest_loss":    metrics.get("largest_loss", ""),
        "sharpe_ratio":    metrics.get("sharpe_ratio", ""),
        "recovery_factor": metrics.get("recovery_factor", ""),
        "expected_payoff": metrics.get("expected_payoff", ""),
        "notes":           "",
    }
