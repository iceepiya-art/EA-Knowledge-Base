"""
Analyzer — วิเคราะห์ trade log ด้วย lens ของ SC₁₀₀ / QField
ผลลัพธ์ใช้สำหรับ ANALYST agent และ Weekly Review
"""
import sys
sys.stdout.reconfigure(encoding="utf-8")

from trade_store import get_all, get_stats
from collections import defaultdict


def analyze_by_regime() -> dict:
    trades = get_all()
    regimes = defaultdict(list)
    for t in trades:
        r = t.get("regime") or "Unknown"
        regimes[r].append(t)

    result = {}
    for regime, ts in regimes.items():
        result[regime] = get_stats(ts)
        result[regime]["count"] = len(ts)
    return result


def analyze_by_exit_type() -> dict:
    trades = get_all()
    exits = defaultdict(list)
    for t in trades:
        e = t.get("exit_type") or "Unknown"
        exits[e].append(t)

    result = {}
    for exit_type, ts in exits.items():
        result[exit_type] = get_stats(ts)
        result[exit_type]["count"] = len(ts)
    return result


def analyze_by_session() -> dict:
    trades = get_all()
    sessions = defaultdict(list)
    for t in trades:
        s = t.get("session") or "Unknown"
        sessions[s].append(t)

    result = {}
    for session, ts in sessions.items():
        result[session] = get_stats(ts)
        result[session]["count"] = len(ts)
    return result


def analyze_by_month() -> dict:
    trades = get_all()
    months = defaultdict(list)
    for t in trades:
        try:
            month = t.get("entry_time", "")[:7]  # "2026-05"
            months[month].append(t)
        except Exception:
            pass

    result = {}
    for month in sorted(months.keys()):
        result[month] = get_stats(months[month])
        result[month]["count"] = len(months[month])
    return result


def analyze_sc100_buckets() -> dict:
    """วิเคราะห์ WR แต่ละช่วง SC₁₀₀"""
    trades = [t for t in get_all() if t.get("sc100", 0) > 0]
    buckets = {
        "< 0.22 (CRASH)":     [t for t in trades if t["sc100"] < 0.22],
        "0.22–0.25 (TREND-)": [t for t in trades if 0.22 <= t["sc100"] < 0.25],
        "0.25–0.30 (WEAK-)":  [t for t in trades if 0.25 <= t["sc100"] < 0.30],
        "0.30–0.35 (WEAK+)":  [t for t in trades if 0.30 <= t["sc100"] < 0.35],
        "0.35–0.40 (REVERT)": [t for t in trades if 0.35 <= t["sc100"] < 0.40],
        "> 0.40 (REVERT+)":   [t for t in trades if t["sc100"] >= 0.40],
    }
    result = {}
    for label, ts in buckets.items():
        if ts:
            result[label] = get_stats(ts)
            result[label]["count"] = len(ts)
    return result


def analyze_lot_size() -> dict:
    """เปรียบเทียบ small lot vs large lot"""
    trades = get_all()
    small = [t for t in trades if t.get("lot", 0) <= 0.10]
    large = [t for t in trades if t.get("lot", 0) > 0.10]
    return {
        "small_lot (≤ 0.10)": {**get_stats(small), "count": len(small)},
        "large_lot (> 0.10)": {**get_stats(large), "count": len(large)},
    }


def analyze_weak_regime_window() -> dict:
    """Focus on the SC100 0.25-0.35 window where QField is weakest."""
    weak_trades = [
        t for t in get_all()
        if 0.25 <= float(t.get("sc100", 0) or 0) < 0.35
    ]
    weak_minus = [t for t in weak_trades if float(t.get("sc100", 0) or 0) < 0.30]
    weak_plus = [t for t in weak_trades if float(t.get("sc100", 0) or 0) >= 0.30]
    return {
        "WEAK window": {**get_stats(weak_trades), "count": len(weak_trades)},
        "WEAK- (0.25-0.30)": {**get_stats(weak_minus), "count": len(weak_minus)},
        "WEAK+ (0.30-0.35)": {**get_stats(weak_plus), "count": len(weak_plus)},
    }


def analyze_weak_beta_split() -> dict:
    weak_trades = [
        t for t in get_all()
        if 0.25 <= float(t.get("sc100", 0) or 0) < 0.35
    ]
    beta_up = [t for t in weak_trades if float(t.get("beta1", 0) or 0) > 0]
    beta_down = [t for t in weak_trades if float(t.get("beta1", 0) or 0) <= 0]
    return {
        "WEAK + beta_up": {**get_stats(beta_up), "count": len(beta_up)},
        "WEAK + beta_down": {**get_stats(beta_down), "count": len(beta_down)},
    }


def full_report() -> str:
    """สร้าง report ครบถ้วนสำหรับ ANALYST agent"""
    trades = get_all()
    if not trades:
        return "❌ ยังไม่มี trade data — import จาก MT5 ก่อน\nรัน: python run.py import_mt5 <file.html>"

    lines = []
    overall = get_stats(trades)

    lines.append("=" * 55)
    lines.append("📊 TRADE LOG ANALYSIS REPORT")
    lines.append("=" * 55)
    lines.append(f"Total trades  : {overall['total']}")
    lines.append(f"Win Rate      : {overall['win_rate']}%")
    lines.append(f"Profit Factor : {overall['profit_factor']}")
    lines.append(f"Net Profit    : ${overall['net_profit']}")
    lines.append(f"Avg Win       : ${overall['avg_win']}  |  Avg Loss: ${overall['avg_loss']}")
    lines.append(f"Max Win       : ${overall['max_win']}  |  Max Loss: ${overall['max_loss']}")

    # By Month
    lines.append("\n─── By Month ──────────────────────────────")
    for month, s in analyze_by_month().items():
        wr = s.get("win_rate", 0)
        pf = s.get("profit_factor", 0)
        bar = "█" * int(wr / 10)
        lines.append(f"  {month}  {bar:<10} WR:{wr:5.1f}%  PF:{pf:4.2f}  N={s['count']}")

    # By Regime
    lines.append("\n─── By Regime ─────────────────────────────")
    regime_order = ["TRENDING", "WEAK", "REVERTING", "CRASH", "Unknown"]
    by_regime = analyze_by_regime()
    for regime in regime_order:
        if regime not in by_regime:
            continue
        s = by_regime[regime]
        wr = s.get("win_rate", 0)
        icon = {"TRENDING":"📈","WEAK":"😐","REVERTING":"🔄","CRASH":"💥"}.get(regime, "❓")
        lines.append(f"  {icon} {regime:<12} WR:{wr:5.1f}%  PF:{s.get('profit_factor',0):4.2f}  N={s['count']}")

    # By SC₁₀₀ buckets
    sc_data = analyze_sc100_buckets()
    if sc_data:
        lines.append("\n─── By SC₁₀₀ Value ────────────────────────")
        for label, s in sc_data.items():
            wr = s.get("win_rate", 0)
            lines.append(f"  {label:<26} WR:{wr:5.1f}%  N={s['count']}")

    weak_window = analyze_weak_regime_window()
    if weak_window["WEAK window"]["count"]:
        lines.append("\n--- WEAK Regime Focus (0.25-0.35) ---")
        for label, s in weak_window.items():
            if not s["count"]:
                continue
            lines.append(
                f"  {label:<22} WR:{s.get('win_rate', 0):5.1f}%  "
                f"PF:{s.get('profit_factor', 0):4.2f}  Net:${s.get('net_profit', 0):7.2f}  N={s['count']}"
            )

    weak_beta = analyze_weak_beta_split()
    if weak_beta["WEAK + beta_up"]["count"] or weak_beta["WEAK + beta_down"]["count"]:
        lines.append("\n--- WEAK Regime by beta1 Direction ---")
        for label, s in weak_beta.items():
            if not s["count"]:
                continue
            lines.append(
                f"  {label:<22} WR:{s.get('win_rate', 0):5.1f}%  "
                f"PF:{s.get('profit_factor', 0):4.2f}  Net:${s.get('net_profit', 0):7.2f}  N={s['count']}"
            )

    # By Exit Type
    lines.append("\n─── By Exit Type ──────────────────────────")
    for exit_type, s in analyze_by_exit_type().items():
        wr = s.get("win_rate", 0)
        icon = {"TP":"🎯","RSI_EXIT":"📊","SL":"🛑","MANUAL":"✋"}.get(exit_type, "❓")
        avg_trade = s.get("net_profit", 0) / s["count"] if s["count"] else 0
        lines.append(f"  {icon} {exit_type:<12} WR:{wr:5.1f}%  Avg:${avg_trade:6.2f}  N={s['count']}")

    # By Session
    lines.append("\n─── By Session ────────────────────────────")
    for session, s in analyze_by_session().items():
        wr = s.get("win_rate", 0)
        lines.append(f"  {session:<12} WR:{wr:5.1f}%  N={s['count']}")

    # By Lot Size
    lines.append("\n─── Lot Size Effect ───────────────────────")
    for label, s in analyze_lot_size().items():
        wr = s.get("win_rate", 0)
        lines.append(f"  {label:<22} WR:{wr:5.1f}%  N={s['count']}")

    # Gaps / Insights
    lines.append("\n─── AI Insights ───────────────────────────")
    by_r = analyze_by_regime()

    # WEAK regime gap
    weak = by_r.get("WEAK", {})
    if weak.get("count", 0) > 5:
        if weak.get("win_rate", 100) < 60:
            lines.append("  ⚠️  WEAK regime WR ต่ำกว่า 60% → ควรลด lot หรือหยุดเทรด")
    else:
        lines.append("  ℹ️  WEAK regime data น้อยเกินไป (<5 trades) — เพิ่ม data ก่อน")

    weak_window_stats = analyze_weak_regime_window()
    weak_minus = weak_window_stats["WEAK- (0.25-0.30)"]
    weak_plus = weak_window_stats["WEAK+ (0.30-0.35)"]
    if weak_minus["count"] and weak_plus["count"]:
        weaker_side = "0.25-0.30" if weak_minus["win_rate"] < weak_plus["win_rate"] else "0.30-0.35"
        lines.append(
            f"  INFO WEAK split: 0.25-0.30 WR {weak_minus['win_rate']}% vs "
            f"0.30-0.35 WR {weak_plus['win_rate']}% -> tighten filters in {weaker_side}"
        )

    weak_beta_stats = analyze_weak_beta_split()
    beta_up = weak_beta_stats["WEAK + beta_up"]
    beta_down = weak_beta_stats["WEAK + beta_down"]
    if beta_up["count"] and beta_down["count"]:
        preferred_beta = "beta_up" if beta_up["win_rate"] >= beta_down["win_rate"] else "beta_down"
        lines.append(
            f"  INFO WEAK beta split: beta_up WR {beta_up['win_rate']}% vs "
            f"beta_down WR {beta_down['win_rate']}% -> prefer {preferred_beta} entries in WEAK regime"
        )

    # Exit type gap
    exit_data = analyze_by_exit_type()
    sl = exit_data.get("SL", {})
    if sl.get("win_rate", 100) < 65:
        lines.append(f"  ⚠️  SL exit WR = {sl.get('win_rate')}% → SL อาจแคบเกินไป ลอง ATR × 0.4")

    # Month trend
    monthly = analyze_by_month()
    if len(monthly) >= 2:
        months = sorted(monthly.keys())
        last_wr = monthly[months[-1]].get("win_rate", 0)
        prev_wr = monthly[months[-2]].get("win_rate", 0)
        if last_wr < prev_wr - 10:
            lines.append(f"  ⚠️  WR ตกจาก {prev_wr}% → {last_wr}% ใน 2 เดือนล่าสุด — ควรตรวจ regime shift")

    lines.append("\n" + "=" * 55)
    return "\n".join(lines)
