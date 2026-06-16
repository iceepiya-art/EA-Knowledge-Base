import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go

from utils import (
    load_trades, sidebar_filters, require_data,
    pct, usd, num, C_WIN, C_LOSS, C_PRIMARY,
)
from performance import compute_kpis, monthly_pnl

st.set_page_config(page_title="Overview — QTrade OS", page_icon="📈", layout="wide")
st.title("📈 Overview")

df_all = load_trades()
df     = sidebar_filters(df_all)

if not require_data(df):
    st.stop()

k = compute_kpis(df)

# ── KPI row ────────────────────────────────────────────────────────────────────
c1, c2, c3, c4, c5 = st.columns(5)
c1.metric("Win Rate",     pct(k["win_rate"]),
          f"{k['win_count']}W / {k['loss_count']}L")
c2.metric("Profit Factor", num(k["profit_factor"]) if k["profit_factor"] else "∞",
          "≥1.5 target" if k["profit_factor"] and k["profit_factor"] >= 1.5 else "⚠ Below 1.5")
c3.metric("Expectancy",   usd(k["expectancy"]), "per trade")
c4.metric("Net PnL",      usd(k["net_pnl"]),    f"{k['total_trades']:,} trades")
c5.metric("Max Drawdown", usd(k["max_drawdown"]), f"Sharpe {num(k['sharpe'], 1)}")

st.divider()

# ── Equity curve ───────────────────────────────────────────────────────────────
st.subheader("Equity Curve & Drawdown")

fig = go.Figure()
fig.add_trace(go.Scatter(
    x=df["trade_num"], y=df["cum_pnl"],
    mode="lines", name="Equity",
    line=dict(color=C_PRIMARY, width=2),
    fill="tozeroy", fillcolor="rgba(92,107,192,0.08)",
))
fig.add_trace(go.Scatter(
    x=df["trade_num"], y=df["peak"],
    mode="lines", name="Peak",
    line=dict(color="#546e7a", width=1, dash="dot"),
))
fig.add_trace(go.Scatter(
    x=df["trade_num"], y=df["drawdown"],
    mode="lines", name="Drawdown",
    line=dict(color=C_LOSS, width=1),
    fill="tozeroy", fillcolor="rgba(239,83,80,0.10)",
    yaxis="y2",
))
fig.update_layout(
    height=360, hovermode="x unified",
    yaxis =dict(title="PnL (USD)", gridcolor="#1e2130"),
    yaxis2=dict(title="Drawdown", overlaying="y", side="right",
                gridcolor="rgba(0,0,0,0)"),
    xaxis =dict(title="Trade #", gridcolor="#1e2130"),
    legend=dict(orientation="h", y=1.05),
    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
    margin=dict(l=0, r=0, t=10, b=0),
)
st.plotly_chart(fig, use_container_width=True)

# ── Monthly PnL bars ───────────────────────────────────────────────────────────
st.subheader("Monthly PnL")
monthly = monthly_pnl(df)
if not monthly.empty:
    fig2 = go.Figure(go.Bar(
        x=monthly["month_dt"].dt.strftime("%b %Y"),
        y=monthly["net_pnl"],
        marker_color=monthly["color"],
        text=monthly["net_pnl"].apply(lambda v: usd(v, 0)),
        textposition="outside",
        hovertemplate="<b>%{x}</b><br>PnL: $%{y:,.2f}<br>"
                      "Trades: %{customdata[0]}<br>WR: %{customdata[1]:.1%}<extra></extra>",
        customdata=monthly[["trades", "win_rate"]].values,
    ))
    fig2.add_hline(y=0, line_color="#546e7a", line_width=1)
    fig2.update_layout(
        height=240,
        xaxis=dict(gridcolor="#1e2130"),
        yaxis=dict(gridcolor="#1e2130"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=10, b=0),
    )
    st.plotly_chart(fig2, use_container_width=True)

# ── Last 20 trades table ───────────────────────────────────────────────────────
st.subheader("Last 20 Trades")

show_cols = [c for c in [
    "open_time", "symbol", "strategy", "direction",
    "lot_size", "pnl_usd", "outcome", "regime",
    "session", "emotional_state",
] if c in df.columns]

recent = df.tail(20)[show_cols].copy()
if "open_time" in recent.columns:
    recent["open_time"] = recent["open_time"].dt.strftime("%Y-%m-%d %H:%M")

def _row_color(row):
    c = {"WIN": "color: #26a69a", "LOSS": "color: #ef5350"}.get(
        row.get("outcome", ""), "")
    return [c if col == "outcome" else "" for col in recent.columns]

st.dataframe(
    recent.style.apply(_row_color, axis=1),
    use_container_width=True, hide_index=True,
)
