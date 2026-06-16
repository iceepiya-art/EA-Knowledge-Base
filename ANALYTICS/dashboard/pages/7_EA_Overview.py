"""
7_EA_Overview.py — EA Intelligence Hub

One card per EA: KPIs + mini equity sparkline + registry metadata.
Click an EA card to drill into its detail section below.
"""

import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd

from utils import load_trades, sidebar_filters, require_data, pct, usd, num, C_WIN, C_LOSS, C_PRIMARY
from ea_engine import (
    get_registry, run_migration,
    compute_ea_metrics, ea_sparklines, build_leaderboard,
    _rank_score,
)

st.set_page_config(page_title="EA Overview — QTrade OS", page_icon="🤖", layout="wide")
run_migration()

# ── Shared CSS ─────────────────────────────────────────────────────────────────
st.markdown("""
<style>
.ea-card {
    background:#1e2130; border:1px solid #2d3147; border-radius:10px;
    padding:14px 16px; margin-bottom:10px;
}
.ea-card h4 { margin:0 0 4px 0; font-size:1rem; color:#cdd6f4; }
.ea-badge {
    display:inline-block; font-size:0.7rem; padding:2px 7px;
    border-radius:12px; margin-right:4px; font-weight:600;
}
.score-bar {
    height:6px; border-radius:3px; margin-top:6px;
}
</style>
""", unsafe_allow_html=True)

# ── Data ───────────────────────────────────────────────────────────────────────
df_all   = load_trades()
df       = sidebar_filters(df_all)
registry = get_registry()

if not require_data(df, min_rows=1):
    st.stop()

st.title("🤖 EA Intelligence Overview")

# ── Portfolio summary strip ────────────────────────────────────────────────────
ea_list   = sorted(df["strategy"].dropna().unique().tolist())
n_eas     = len(ea_list)
total_pnl = df["pnl_usd"].sum()
port_wr   = (df["outcome"] == "WIN").mean()
port_exp  = (port_wr * df[df.outcome=="WIN"].pnl_usd.mean() +
             (1-port_wr) * df[df.outcome=="LOSS"].pnl_usd.mean()
             ) if not df.empty else 0

pc1, pc2, pc3, pc4, pc5 = st.columns(5)
pc1.metric("Active EAs",       str(n_eas))
pc2.metric("Portfolio PnL",    usd(total_pnl))
pc3.metric("Portfolio WR",     pct(port_wr))
pc4.metric("Portfolio Expect", usd(port_exp, 2), "per trade")
pc5.metric("Total Trades",     f"{len(df):,}")

st.divider()

# ── Sparklines ─────────────────────────────────────────────────────────────────
sparks = ea_sparklines(df)

# ── EA type → color ────────────────────────────────────────────────────────────
TYPE_COLOR = {
    "Trend":   "#26a69a", "MeanRev": "#5c6bc0", "Grid":    "#ffa726",
    "Scalp":   "#ab47bc", "SMC":     "#ef5350",  "Hybrid":  "#26c6da",
    "Unknown": "#546e7a",
}
STATUS_COLOR = {"Active": "#26a69a", "Inactive": "#ef5350", "Testing": "#ffd600"}

RISK_ICON = {"Low": "🟢", "Medium": "🟡", "High": "🔴"}

reg_map = {}
if not registry.empty:
    for _, row in registry.iterrows():
        reg_map[row["ea_name"]] = row.to_dict()

# ── EA Cards (3 per row) ───────────────────────────────────────────────────────
COLS_PER_ROW = 3

for row_start in range(0, n_eas, COLS_PER_ROW):
    cols = st.columns(COLS_PER_ROW)
    for col_i, ea in enumerate(ea_list[row_start : row_start + COLS_PER_ROW]):
        grp  = df[df.strategy == ea].sort_values("open_time")
        m    = compute_ea_metrics(grp)
        meta = reg_map.get(ea, {})
        score= _rank_score(m)
        spark= sparks.get(ea, [])

        ea_type   = meta.get("ea_type",   "Unknown")
        risk_lvl  = meta.get("risk_level","Medium")
        status    = meta.get("status",    "Active")
        t_color   = TYPE_COLOR.get(ea_type, "#546e7a")
        s_color   = STATUS_COLOR.get(status, "#aaaaaa")

        with cols[col_i]:
            # Sparkline
            if spark:
                fig = go.Figure(go.Scatter(
                    x=list(range(len(spark))), y=spark,
                    mode="lines",
                    line=dict(color=C_WIN if spark[-1] >= 0 else C_LOSS, width=1.5),
                    fill="tozeroy",
                    fillcolor=f"{'rgba(38,166,154,0.12)' if spark[-1]>=0 else 'rgba(239,83,80,0.12)'}",
                ))
                fig.update_layout(
                    height=80, margin=dict(l=0, r=0, t=0, b=0),
                    xaxis=dict(visible=False), yaxis=dict(visible=False),
                    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                    showlegend=False,
                )
                st.plotly_chart(fig, use_container_width=True, key=f"spark_{ea}")

            # Badges
            badge_html = (
                f"<span class='ea-badge' style='background:{t_color}22;color:{t_color}'>{ea_type}</span>"
                f"<span class='ea-badge' style='background:{s_color}22;color:{s_color}'>{status}</span>"
                f"<span>{RISK_ICON.get(risk_lvl,'')}</span>"
            )

            # Score bar
            bar_color = ("#26a69a" if score >= 65 else "#ffa726" if score >= 40 else "#ef5350")
            bar_w     = f"{score}%"

            st.markdown(f"""
<div class="ea-card">
  <h4>{ea}</h4>
  <div style="margin-bottom:6px">{badge_html}</div>
  <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:4px;font-size:0.82rem">
    <div><span style="color:#8892b0">WR</span><br>
         <b style="color:{'#26a69a' if m.get('win_rate',0)>=0.5 else '#ef5350'}">
         {pct(m.get('win_rate'))}</b></div>
    <div><span style="color:#8892b0">PF</span><br>
         <b>{num(m.get('profit_factor'))}</b></div>
    <div><span style="color:#8892b0">Net PnL</span><br>
         <b style="color:{'#26a69a' if m.get('net_pnl',0)>=0 else '#ef5350'}">
         {usd(m.get('net_pnl'))}</b></div>
    <div><span style="color:#8892b0">Expect</span><br>
         <b>{usd(m.get('expectancy'))}</b></div>
    <div><span style="color:#8892b0">Max DD</span><br>
         <b style="color:#ef5350">{usd(m.get('max_drawdown'))}</b></div>
    <div><span style="color:#8892b0">Trades</span><br>
         <b>{m.get('total_trades',0):,}</b></div>
  </div>
  <div style="display:flex;align-items:center;gap:8px;margin-top:8px">
    <div style="font-size:0.72rem;color:#8892b0;white-space:nowrap">Score {score:.0f}/100</div>
    <div style="flex:1;background:#2d3147;border-radius:3px;height:6px">
      <div style="width:{bar_w};background:{bar_color};height:6px;border-radius:3px"></div>
    </div>
  </div>
</div>""", unsafe_allow_html=True)

# ── Portfolio combined equity curve ────────────────────────────────────────────
st.divider()
st.subheader("Portfolio Combined Equity")

daily_pivot = df.copy()
daily_pivot["date"] = daily_pivot["open_time"].dt.date
daily = daily_pivot.groupby("date")["pnl_usd"].sum().cumsum().reset_index()
daily.columns = ["date", "cum_pnl"]

if not daily.empty:
    fig_port = go.Figure()
    fig_port.add_trace(go.Scatter(
        x=daily["date"], y=daily["cum_pnl"],
        mode="lines", name="Portfolio",
        line=dict(color=C_PRIMARY, width=2.5),
        fill="tozeroy", fillcolor="rgba(92,107,192,0.10)",
    ))
    # Add per-EA traces (muted)
    for ea in ea_list:
        g = df[df.strategy == ea].copy()
        g["date"] = g["open_time"].dt.date
        gd = g.groupby("date")["pnl_usd"].sum().cumsum().reset_index()
        gd.columns = ["date", "cum_pnl"]
        if not gd.empty:
            fig_port.add_trace(go.Scatter(
                x=gd["date"], y=gd["cum_pnl"],
                mode="lines", name=ea,
                line=dict(width=1, dash="dot"),
                opacity=0.55,
            ))
    fig_port.update_layout(
        height=320, hovermode="x unified",
        xaxis=dict(gridcolor="#1e2130"),
        yaxis=dict(title="Cum PnL (USD)", gridcolor="#1e2130"),
        legend=dict(orientation="h", y=1.05),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=10, b=0),
    )
    st.plotly_chart(fig_port, use_container_width=True)

# ── EA Registry editor ─────────────────────────────────────────────────────────
with st.expander("Edit EA Registry", expanded=False):
    from ea_engine import save_registry_row, EA_TYPES, RISK_LEVELS, STATUSES

    sel_ea = st.selectbox("Select EA to edit", ea_list, key="reg_ea_sel")
    cur    = reg_map.get(sel_ea, {})

    rc1, rc2, rc3 = st.columns(3)
    f_type   = rc1.selectbox("Type",   EA_TYPES,    index=EA_TYPES.index(cur.get("ea_type","Unknown")))
    f_risk   = rc2.selectbox("Risk",   RISK_LEVELS, index=RISK_LEVELS.index(cur.get("risk_level","Medium")))
    f_status = rc3.selectbox("Status", STATUSES,    index=STATUSES.index(cur.get("status","Active")))

    rc4, rc5 = st.columns(2)
    f_sym  = rc4.text_input("Preferred Symbol",  cur.get("preferred_symbol",""))
    f_sess = rc5.text_input("Preferred Session", cur.get("preferred_session",""))
    f_desc = st.text_area("Description", cur.get("description",""), height=80)

    if st.button("Save Registry", type="primary"):
        ok, msg = save_registry_row(sel_ea, {
            "ea_type": f_type, "risk_level": f_risk, "status": f_status,
            "preferred_symbol": f_sym, "preferred_session": f_sess,
            "description": f_desc,
        })
        if ok:
            st.success(msg)
            st.cache_data.clear()
        else:
            st.error(msg)
