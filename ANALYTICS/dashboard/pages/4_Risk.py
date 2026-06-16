"""
4_Risk.py — Advanced Risk Monitor Dashboard

Tabs:
  Monitor   — live score gauge, limit bars, alerts
  Sizer     — dynamic position size calculator
  Settings  — edit risk config + manual halt
  History   — risk events audit trail
"""

import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import plotly.express as px
import pandas as pd

import risk_engine as re
from utils import load_trades, usd, pct

st.set_page_config(page_title="Risk — QTrade OS", page_icon="🛡", layout="wide")

# ══════════════════════════════════════════════════════════════════════════════
# CONSTANTS
# ══════════════════════════════════════════════════════════════════════════════

_STATUS_COLOR = {
    "SAFE":    "#26a69a",
    "CAUTION": "#ffd600",
    "WARNING": "#ff9800",
    "HALT":    "#ef5350",
}
_STATUS_BG = {
    "SAFE":    "rgba(38,166,154,0.15)",
    "CAUTION": "rgba(255,214,0,0.12)",
    "WARNING": "rgba(255,152,0,0.15)",
    "HALT":    "rgba(239,83,80,0.20)",
}
_LEVEL_COLOR = {
    "INFO":     "#8892b0",
    "CAUTION":  "#ffd600",
    "WARNING":  "#ff9800",
    "CRITICAL": "#ef5350",
}

# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

@st.cache_data(ttl=30)
def _load_snapshot():
    cfg  = re.load_config()
    snap = re.get_risk_snapshot(cfg)
    return snap, cfg

def _status_banner(snap: dict) -> None:
    status = snap["status"]
    color  = _STATUS_COLOR[status]
    bg     = _STATUS_BG[status]
    score  = snap["score"]

    icon = {"SAFE":"✅","CAUTION":"🔔","WARNING":"⚠","HALT":"🚨"}[status]

    # Halt reasons
    halt_txt = ""
    if snap["halt_reasons"]:
        halt_txt = "  |  " + " · ".join(snap["halt_reasons"])

    st.markdown(
        f"""<div style="background:{bg};border:1px solid {color};border-radius:8px;
            padding:14px 20px;margin-bottom:8px;display:flex;
            align-items:center;justify-content:space-between">
        <span style="font-size:1.25rem;font-weight:700;color:{color}">
            {icon} {status}{halt_txt}
        </span>
        <span style="font-size:1.1rem;color:{color}">
            Risk Score: <b>{score:.0f} / 100</b>
        </span>
        </div>""",
        unsafe_allow_html=True,
    )

    if snap["warnings"]:
        for w in snap["warnings"]:
            st.warning(w, icon="⚠")

def _score_gauge(score: float, status: str) -> go.Figure:
    color = _STATUS_COLOR[status]
    fig = go.Figure(go.Indicator(
        mode  = "gauge+number",
        value = score,
        number= {"font": {"size": 48, "color": color}, "suffix": ""},
        title = {"text": "Safe-to-Trade Score", "font": {"size": 14, "color": "#8892b0"}},
        gauge = {
            "axis":  {"range": [0, 100], "tickwidth": 1, "tickcolor": "#4a5568"},
            "bar":   {"color": color, "thickness": 0.25},
            "bgcolor": "rgba(0,0,0,0)",
            "borderwidth": 0,
            "steps": [
                {"range": [0,  20], "color": "rgba(239,83,80,0.25)"},
                {"range": [20, 50], "color": "rgba(255,152,0,0.20)"},
                {"range": [50, 75], "color": "rgba(255,214,0,0.15)"},
                {"range": [75,100], "color": "rgba(38,166,154,0.15)"},
            ],
            "threshold": {
                "line": {"color": "white", "width": 2},
                "thickness": 0.85,
                "value": score,
            },
        },
    ))
    fig.update_layout(
        height=260,
        paper_bgcolor="rgba(0,0,0,0)",
        font={"color": "#cdd6f4"},
        margin=dict(l=30, r=30, t=30, b=10),
    )
    return fig

def _limit_bar(label: str, used_pct: float, limit_label: str, color: str) -> None:
    """Render a single limit progress bar."""
    clamped = min(used_pct / 100.0, 1.0)
    st.markdown(
        f"<div style='display:flex;justify-content:space-between;"
        f"font-size:0.85rem;color:#8892b0;margin-bottom:2px'>"
        f"<span>{label}</span><span>{used_pct:.1f}% of {limit_label}</span></div>",
        unsafe_allow_html=True,
    )
    bar_color = "#ef5350" if used_pct >= 100 else "#ff9800" if used_pct >= 75 else color
    filled = int(clamped * 40)
    bar    = f"<div style='background:#2d3147;border-radius:4px;height:10px'>" \
             f"<div style='width:{clamped*100:.1f}%;background:{bar_color};" \
             f"height:10px;border-radius:4px;transition:width 0.3s'></div></div>"
    st.markdown(bar, unsafe_allow_html=True)
    st.markdown("<div style='margin-bottom:10px'></div>", unsafe_allow_html=True)

def _score_breakdown_chart(breakdown: dict) -> go.Figure:
    labels = ["Daily DD", "Weekly DD", "Consec Losses", "Session DD"]
    values = [
        breakdown.get("daily_dd", 0),
        breakdown.get("weekly_dd", 0),
        breakdown.get("consec_loss", 0),
        breakdown.get("session_dd", 0),
    ]
    max_pts = [35, 25, 25, 15]
    colors  = ["#ef5350","#ff9800","#ffd600","#5c6bc0"]

    fig = go.Figure()
    for label, val, mx, col in zip(labels, values, max_pts, colors):
        fig.add_trace(go.Bar(
            name=label, x=[label],
            y=[val], marker_color=col,
            text=[f"-{val:.1f}"], textposition="outside",
            hovertemplate=f"{label}: -{val:.1f} / -{mx} pts<extra></extra>",
        ))
    fig.update_layout(
        height=200, showlegend=False,
        barmode="group",
        yaxis=dict(range=[0, 40], title="Points Deducted", color="#8892b0"),
        xaxis_tickfont=dict(color="#8892b0"),
        paper_bgcolor="rgba(0,0,0,0)",
        plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=10, b=0),
    )
    return fig

# ══════════════════════════════════════════════════════════════════════════════
# PAGE HEADER
# ══════════════════════════════════════════════════════════════════════════════

st.title("🛡 Risk Monitor")

# Refresh control
col_title, col_btn = st.columns([8, 1])
with col_btn:
    if st.button("↻ Refresh", use_container_width=True):
        st.cache_data.clear()
        st.rerun()

snap, cfg = _load_snapshot()
_status_banner(snap)

tab_mon, tab_sizer, tab_settings, tab_hist = st.tabs(
    ["📊 Monitor", "📐 Position Sizer", "⚙ Settings", "📋 History"]
)

# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — MONITOR
# ══════════════════════════════════════════════════════════════════════════════

with tab_mon:
    col_gauge, col_limits, col_stats = st.columns([1.2, 1.4, 1.0], gap="large")

    # ── Score gauge ───────────────────────────────────────────────────────
    with col_gauge:
        st.plotly_chart(_score_gauge(snap["score"], snap["status"]),
                        use_container_width=True)

        # Score breakdown bar chart
        st.markdown("**Score deductions**")
        st.plotly_chart(_score_breakdown_chart(snap["breakdown"]),
                        use_container_width=True)

    # ── Limit bars ────────────────────────────────────────────────────────
    with col_limits:
        st.markdown("##### Risk Limits")
        lim = snap["limits"]
        bal = cfg["account_balance"]

        # Daily DD
        _limit_bar(
            f"Daily Drawdown  ({usd(snap['daily_pnl'])})",
            lim["daily_used_pct"],
            f"{lim['daily_limit']:.0f}% = {usd(-bal * lim['daily_limit'] / 100, 0)}",
            "#5c6bc0",
        )

        # Weekly DD
        week_used = lim["weekly_used_pct"]
        _limit_bar(
            f"Weekly Drawdown  ({usd(snap['weekly_pnl'])})",
            week_used,
            f"{lim['weekly_limit']:.0f}% = {usd(-bal * lim['weekly_limit'] / 100, 0)}",
            "#5c6bc0",
        )

        # Consecutive losses
        c_max   = cfg["max_consecutive_losses"]
        c_cur   = snap["consec_losses"]
        c_used  = c_cur / c_max * 100 if c_max else 0
        _limit_bar(
            f"Consecutive Losses  ({c_cur})",
            c_used,
            f"{c_max} trades",
            "#5c6bc0",
        )

        # Session DD — worst session
        if snap["session_pnl"]:
            worst_sess = min(snap["session_pnl"], key=snap["session_pnl"].get)
            worst_val  = snap["session_pnl"][worst_sess]
            sess_limit = cfg["session_loss_limit_pct"] / 100 * bal
            sess_used  = abs(min(worst_val, 0)) / sess_limit * 100 if sess_limit else 0
            _limit_bar(
                f"Session DD — {worst_sess}  ({usd(worst_val)})",
                sess_used,
                f"{cfg['session_loss_limit_pct']:.0f}% = {usd(sess_limit, 0)}",
                "#5c6bc0",
            )

        # Volatility scalar
        vs = snap["vol_scalar"]
        st.markdown(
            f"<div style='margin-top:8px;font-size:0.85rem;color:#8892b0'>"
            f"Volatility scalar: <b style='color:{'#ff9800' if vs < 1.0 else '#26a69a'}'>"
            f"{vs:.2f}x</b> ({'High vol — reduced sizing' if vs < 1.0 else 'Normal vol'})"
            f"</div>",
            unsafe_allow_html=True,
        )

        # Correlation exposure
        if snap["corr_exposure"]:
            st.markdown("**Correlation groups active today:**")
            for group, count in snap["corr_exposure"].items():
                limit = cfg.get("max_correlated_trades", 2)
                badge_color = "#ef5350" if count >= limit else "#ffd600" if count >= limit - 1 else "#26a69a"
                st.markdown(
                    f"<span style='background:{badge_color};color:#1a1b2e;"
                    f"padding:2px 8px;border-radius:4px;font-size:0.8rem;margin-right:6px'>"
                    f"{group}: {count}</span>",
                    unsafe_allow_html=True,
                )
            st.markdown("")

    # ── Today stats ───────────────────────────────────────────────────────
    with col_stats:
        st.markdown("##### Today")
        st.metric("Trades",  snap["today_trades"])
        st.metric("Win Rate", f"{snap['today_wr']:.0f}%",
                  f"+{snap['today_wins']} / -{snap['today_losses']}")
        st.metric("PnL Today",   usd(snap["daily_pnl"]),
                  delta_color="normal")
        st.metric("PnL This Week", usd(snap["weekly_pnl"]),
                  delta_color="normal")

        # Manual halt toggle
        st.markdown("---")
        is_halted = snap["manual_halt"] is not None
        halt_label = "🔴 HALT ACTIVE — Resume" if is_halted else "Manual Halt"
        if st.button(halt_label, type="primary" if is_halted else "secondary",
                     use_container_width=True):
            re.set_manual_halt(not is_halted,
                               reason="Manual halt from dashboard")
            st.cache_data.clear()
            st.rerun()

    st.divider()

    # ── Behavioral alerts ─────────────────────────────────────────────────
    beh = snap["behavioral_alerts"]
    st.markdown("##### Behavioral Alerts")

    if not beh:
        st.success("No behavioral risk patterns detected")
    else:
        for alert in beh:
            lvl = alert.get("level","WARNING")
            msg = alert.get("message","")
            if lvl == "CRITICAL":  st.error(msg)
            elif lvl == "WARNING": st.warning(msg)
            else:                  st.info(msg)

    st.divider()

    # ── Daily PnL history chart ───────────────────────────────────────────
    df_hist = snap["df_hist"]
    if not df_hist.empty:
        st.markdown("##### Daily PnL — Last 30 Days")
        daily_limit_line = -bal * cfg["daily_loss_limit_pct"] / 100

        colors = ["#26a69a" if v >= 0 else "#ef5350" for v in df_hist["daily_pnl"]]
        fig = go.Figure()
        fig.add_trace(go.Bar(
            x=df_hist["day"], y=df_hist["daily_pnl"],
            marker_color=colors, name="Daily PnL",
        ))
        fig.add_hline(y=daily_limit_line, line_dash="dot", line_color="#ff9800",
                      annotation_text=f"Daily limit {usd(daily_limit_line, 0)}")
        fig.update_layout(
            height=200,
            xaxis_title=None, yaxis_title="PnL (USD)",
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            showlegend=False, margin=dict(l=0, r=0, t=10, b=0),
            yaxis=dict(color="#8892b0"), xaxis=dict(color="#8892b0"),
        )
        st.plotly_chart(fig, use_container_width=True)

    # ── Today's trade log ─────────────────────────────────────────────────
    df_today = snap["df_today"]
    if not df_today.empty:
        st.markdown("##### Today's Trades")
        display = df_today[["open_time","symbol","direction","session","outcome","pnl_usd"]].copy()
        display["open_time"] = display["open_time"].dt.strftime("%H:%M")
        display.columns = ["Time","Symbol","Dir","Session","Outcome","PnL"]
        st.dataframe(
            display.style
                .map(lambda v: "color:#26a69a" if v=="WIN" else "color:#ef5350" if v=="LOSS" else "",
                     subset=["Outcome"])
                .map(lambda v: f"color:{'#26a69a' if (isinstance(v,float) and v>0) else '#ef5350' if isinstance(v,float) else ''}",
                     subset=["PnL"]),
            use_container_width=True, hide_index=True, height=200,
        )


# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — POSITION SIZER
# ══════════════════════════════════════════════════════════════════════════════

with tab_sizer:
    st.markdown("#### Dynamic Position Size Calculator")
    st.caption(
        f"Account: **{usd(cfg['account_balance'],0)}** | "
        f"Risk/trade: **{cfg['risk_per_trade_pct']:.1f}%** | "
        f"Volatility scalar: **{snap['vol_scalar']:.2f}x**"
    )

    sz1, sz2 = st.columns(2, gap="large")

    with sz1:
        symbol  = st.selectbox("Symbol", ["XAUUSD","EURUSD","GBPUSD","USDJPY","NQ","SPX500","XAGUSD","Other"], index=0)
        entry   = st.number_input("Entry Price", min_value=0.0, value=3000.0, step=0.01, format="%.4f")
        sl      = st.number_input("Stop Loss Price", min_value=0.0, value=2970.0, step=0.01, format="%.4f")

        direction = "BUY" if entry > sl else "SELL"
        st.caption(f"Detected direction: **{direction}**")

        use_vol_scalar = st.toggle("Apply volatility scalar", value=True)
        scalar = snap["vol_scalar"] if use_vol_scalar else 1.0

        # Consecutive-loss scalar
        c_cur  = snap["consec_losses"]
        c_warn = cfg["warn_consecutive_losses"]
        c_max  = cfg["max_consecutive_losses"]
        if c_cur >= c_warn:
            loss_scalar = max(0.5, 1.0 - 0.25 * (c_cur - c_warn + 1))
            st.warning(f"Consecutive losses ({c_cur}) active: lot size reduced to {loss_scalar:.0%}")
            scalar *= loss_scalar

    with sz2:
        if entry > 0 and sl > 0 and entry != sl:
            result = re.compute_lot_size(entry, sl, symbol, cfg, vol_scalar=scalar)

            if "error" in result:
                st.error(result["error"])
            else:
                lot   = result["lot_size"]
                color = _STATUS_COLOR[snap["status"]]

                st.markdown(
                    f"""<div style="background:#1e2130;border:1px solid {color};border-radius:8px;
                        padding:20px;text-align:center">
                    <div style="font-size:0.85rem;color:#8892b0">Recommended Lot Size</div>
                    <div style="font-size:3rem;font-weight:700;color:{color}">{lot:.2f}</div>
                    <div style="font-size:0.85rem;color:#8892b0">
                        Risk: {usd(result['risk_usd'])} ({result['risk_pct']:.1f}%) &nbsp;|&nbsp;
                        SL: {result['sl_pips']:.0f} pips
                    </div>
                    </div>""",
                    unsafe_allow_html=True,
                )

                st.markdown("")
                st.markdown("**Take Profit levels:**")
                tgt = result["rr_targets"]
                tp_col1, tp_col2, tp_col3 = st.columns(3)
                for col, (rr_label, tp_price) in zip(
                    [tp_col1, tp_col2, tp_col3],
                    [("1R", tgt["1R"]), ("2R", tgt["2R"]), ("3R", tgt["3R"])]
                ):
                    reward = result["risk_usd"] * int(rr_label[0])
                    col.metric(rr_label, f"{tp_price:.4f}", f"+{usd(reward)}")

                with st.expander("Full breakdown"):
                    st.json({
                        "entry":          entry,
                        "sl":             sl,
                        "sl_distance":    result["sl_distance"],
                        "sl_pips":        result["sl_pips"],
                        "contract_size":  result["contract_size"],
                        "loss_per_lot":   result["loss_per_lot"],
                        "risk_usd":       result["risk_usd"],
                        "raw_lot":        result["raw_lot"],
                        "vol_scalar":     result["vol_scalar"],
                        "final_lot":      result["lot_size"],
                    })
        else:
            st.info("Enter entry and stop loss prices to calculate.")

    st.divider()

    # Quick RR table
    if entry > 0 and sl > 0 and entry != sl:
        st.markdown("#### Risk / Reward Table")
        sl_dist = abs(entry - sl)
        rows = []
        for rr in [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0]:
            tp_price = (entry + rr * sl_dist) if direction == "BUY" else (entry - rr * sl_dist)
            reward   = result["risk_usd"] * rr
            rows.append({"RR": f"{rr:.1f}R", "TP Price": f"{tp_price:.4f}",
                         "Reward (USD)": f"+{usd(reward)}", "Net (USD)": usd(reward)})
        st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — SETTINGS
# ══════════════════════════════════════════════════════════════════════════════

with tab_settings:
    st.markdown("#### Risk Configuration")
    st.caption("Changes saved immediately to `SYSTEM/config/risk_config.json`")

    with st.form("risk_config_form"):
        c1, c2 = st.columns(2)

        with c1:
            st.markdown("**Account**")
            new_balance  = st.number_input("Account Balance (USD)", min_value=100.0,
                                           value=float(cfg["account_balance"]), step=1000.0)
            new_risk_pct = st.number_input("Risk Per Trade (%)", min_value=0.1, max_value=5.0,
                                           value=float(cfg["risk_per_trade_pct"]), step=0.1)
            new_max_lot  = st.number_input("Max Lot Size", min_value=0.01, max_value=100.0,
                                           value=float(cfg["max_lot_size"]), step=0.1)

            st.markdown("**Daily Limits**")
            new_daily_halt = st.slider("Daily Loss Limit (%)", 0.5, 10.0,
                                       float(cfg["daily_loss_limit_pct"]), 0.1)
            new_daily_warn = st.slider("Daily Warning (%)", 0.1, new_daily_halt,
                                       min(float(cfg["daily_warning_pct"]), new_daily_halt), 0.1)

            st.markdown("**Weekly Limits**")
            new_week_halt = st.slider("Weekly Loss Limit (%)", 1.0, 20.0,
                                      float(cfg["weekly_loss_limit_pct"]), 0.5)
            new_week_warn = st.slider("Weekly Warning (%)", 0.5, new_week_halt,
                                      min(float(cfg["weekly_warning_pct"]), new_week_halt), 0.5)

        with c2:
            st.markdown("**Consecutive Losses**")
            new_c_halt = st.slider("Max Consecutive Losses (Halt)", 1, 10,
                                   int(cfg["max_consecutive_losses"]))
            new_c_warn = st.slider("Warn After N Consecutive Losses", 1, new_c_halt,
                                   min(int(cfg["warn_consecutive_losses"]), new_c_halt))

            st.markdown("**Session**")
            new_sess_limit = st.slider("Session Loss Limit (%)", 0.1, 5.0,
                                       float(cfg["session_loss_limit_pct"]), 0.1)

            st.markdown("**Position Limits**")
            new_max_open = st.slider("Max Open Trades", 1, 10, int(cfg["max_open_trades"]))
            new_max_corr = st.slider("Max Correlated Trades", 1, 5,
                                     int(cfg["max_correlated_trades"]))

            st.markdown("**Volatility**")
            new_vol_scalar = st.slider("High Volatility Size Scalar", 0.1, 1.0,
                                       float(cfg["volatility_high_scalar"]), 0.05)

            st.markdown("**Behavioral Alerts**")
            ba = cfg.get("behavioral_alerts", {})
            new_lot_creep     = st.slider("Lot Creep Threshold (×)", 1.0, 3.0,
                                          float(ba.get("lot_creep_threshold", 1.3)), 0.1)
            new_revenge_mins  = st.slider("Revenge Trade Gap (min)", 1, 60,
                                          int(ba.get("revenge_gap_minutes", 10)))

        save_btn = st.form_submit_button("💾 Save Configuration", type="primary",
                                         use_container_width=True)

        if save_btn:
            new_cfg = dict(cfg)
            new_cfg.update({
                "account_balance":         new_balance,
                "risk_per_trade_pct":      new_risk_pct,
                "max_lot_size":            new_max_lot,
                "daily_loss_limit_pct":    new_daily_halt,
                "daily_warning_pct":       new_daily_warn,
                "weekly_loss_limit_pct":   new_week_halt,
                "weekly_warning_pct":      new_week_warn,
                "max_consecutive_losses":  new_c_halt,
                "warn_consecutive_losses": new_c_warn,
                "session_loss_limit_pct":  new_sess_limit,
                "max_open_trades":         new_max_open,
                "max_correlated_trades":   new_max_corr,
                "volatility_high_scalar":  new_vol_scalar,
                "behavioral_alerts": {
                    "lot_creep_threshold":  new_lot_creep,
                    "revenge_gap_minutes":  new_revenge_mins,
                    "fomo_recent_count":    ba.get("fomo_recent_count", 3),
                },
            })
            re.save_config(new_cfg)
            re.log_risk_event("INFO", "CONFIG_CHANGE", "Risk config updated from dashboard")
            st.cache_data.clear()
            st.success("Configuration saved.")
            st.rerun()

    # ── Pre-session checklist ─────────────────────────────────────────────
    st.divider()
    st.markdown("#### Pre-Session Checklist")
    lim    = snap["limits"]
    status = snap["status"]
    c_cur  = snap["consec_losses"]
    c_max  = cfg["max_consecutive_losses"]

    def _check(ok: bool, yes_txt: str, no_txt: str) -> str:
        return f"✅ {yes_txt}" if ok else f"❌ {no_txt}"

    st.markdown(f"""
| Check | Limit | Status |
|---|---|---|
| Daily drawdown | < {cfg['daily_loss_limit_pct']:.0f}% | {_check(lim['daily_used_pct']<100, f"{lim['daily_loss_pct']:.1f}% used", f"{lim['daily_loss_pct']:.1f}% — LIMIT HIT")} |
| Weekly drawdown | < {cfg['weekly_loss_limit_pct']:.0f}% | {_check(lim['weekly_used_pct']<100, f"{lim['weekly_loss_pct']:.1f}% used", f"{lim['weekly_loss_pct']:.1f}% — LIMIT HIT")} |
| Consecutive losses | < {c_max} | {_check(c_cur < c_max, f"{c_cur} losses", f"{c_cur} — HALT")} |
| Risk status | SAFE | {_check(status=="SAFE", "All clear", f"{status} — review before trading")} |

**Today:** {snap['today_trades']} trades | {usd(snap['daily_pnl'])} | WR {snap['today_wr']:.0f}%
""")


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — HISTORY
# ══════════════════════════════════════════════════════════════════════════════

with tab_hist:
    st.markdown("#### Risk Events — Audit Trail")

    h1, h2, h3 = st.columns(3)
    h_level = h1.selectbox("Level", ["All","INFO","CAUTION","WARNING","CRITICAL"])
    h_cat   = h2.selectbox("Category", ["All","DAILY_DD","WEEKLY_DD","CONSEC_LOSS",
                                         "SESSION_DD","HALT","RESUME","CONFIG_CHANGE"])
    h_limit = h3.number_input("Max rows", 50, 500, 200, step=50)

    df_ev = re.get_risk_events(int(h_limit))

    if not df_ev.empty:
        if h_level != "All":
            df_ev = df_ev[df_ev["level"] == h_level]
        if h_cat != "All":
            df_ev = df_ev[df_ev["category"] == h_cat]

    if df_ev.empty:
        st.info("No risk events yet. Events are logged when limits are approached or breached.")
    else:
        df_ev["logged_at"] = df_ev["logged_at"].dt.strftime("%Y-%m-%d %H:%M:%S")

        # Summary metrics
        sc1, sc2, sc3, sc4 = st.columns(4)
        sc1.metric("Total Events", len(df_ev))
        sc2.metric("Critical",  int((df_ev["level"]=="CRITICAL").sum()))
        sc3.metric("Warnings",  int((df_ev["level"]=="WARNING").sum()))
        sc4.metric("Info/Caution", int(df_ev["level"].isin(["INFO","CAUTION"]).sum()))

        st.dataframe(
            df_ev.rename(columns={
                "logged_at":"When","level":"Level","category":"Category",
                "message":"Message","metric_value":"Value","threshold":"Limit",
            }).style.map(
                lambda v: f"color:{_LEVEL_COLOR.get(v,'#cdd6f4')}" if isinstance(v,str) and v in _LEVEL_COLOR else "",
                subset=["Level"]
            ),
            use_container_width=True,
            hide_index=True,
            height=450,
        )

    # ── Trading halt log ─────────────────────────────────────────────────
    st.markdown("#### Trading Halts Log")
    try:
        import sqlite3 as _sq
        _c = _sq.connect(str(re.DB_PATH))
        df_halts = pd.read_sql_query(
            "SELECT started_at, ended_at, reason, halt_type, is_active FROM trading_halts ORDER BY started_at DESC LIMIT 20",
            _c,
        )
        _c.close()
        if df_halts.empty:
            st.info("No halt records.")
        else:
            df_halts["Active"] = df_halts["is_active"].map({1: "YES", 0: "no"})
            st.dataframe(df_halts[["started_at","ended_at","reason","halt_type","Active"]],
                         use_container_width=True, hide_index=True)
    except Exception as e:
        st.error(f"Could not load halt log: {e}")
