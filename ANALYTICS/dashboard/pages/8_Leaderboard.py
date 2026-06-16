"""
8_Leaderboard.py — EA Ranking & Expectancy Comparison

Ranked table with composite score + bar chart comparisons.
Expectancy breakdown: WR × AvgWin vs (1-WR) × |AvgLoss|.
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
import numpy as np

from utils import load_trades, sidebar_filters, require_data, pct, usd, num, C_WIN, C_LOSS, C_PRIMARY
from ea_engine import get_registry, run_migration, build_leaderboard, expectancy_table

st.set_page_config(page_title="EA Leaderboard — QTrade OS", page_icon="🏆", layout="wide")
run_migration()

df_all   = load_trades()
df       = sidebar_filters(df_all)
registry = get_registry()

if not require_data(df, min_rows=1):
    st.stop()

st.title("🏆 EA Leaderboard")

lb = build_leaderboard(df, registry)
if lb.empty:
    st.warning("Not enough data to rank EAs.")
    st.stop()

# ── Rank strip ─────────────────────────────────────────────────────────────────
st.caption("Rank score = WR×35 + PF×20 + Expectancy×15 + DrawdownSafety×20 + Sharpe×10")
lb.insert(0, "Rank", range(1, len(lb) + 1))

# ── Styled leaderboard table ───────────────────────────────────────────────────
display_cols = [
    "Rank", "EA", "rank_score", "total_trades", "win_rate", "profit_factor",
    "expectancy", "net_pnl", "max_drawdown", "sharpe",
    "avg_rr_actual", "avg_duration_min",
]
if "ea_type"    in lb.columns: display_cols.insert(2, "ea_type")
if "risk_level" in lb.columns: display_cols.insert(3, "risk_level")
if "status"     in lb.columns: display_cols.insert(4, "status")

disp = lb[[c for c in display_cols if c in lb.columns]].copy()
disp = disp.rename(columns={
    "rank_score":      "Score",
    "total_trades":    "Trades",
    "win_rate":        "WR",
    "profit_factor":   "PF",
    "expectancy":      "Expect $",
    "net_pnl":         "Net PnL",
    "max_drawdown":    "Max DD",
    "sharpe":          "Sharpe",
    "avg_rr_actual":   "Avg RR",
    "avg_duration_min":"Avg Min",
    "ea_type":         "Type",
    "risk_level":      "Risk",
    "status":          "Status",
})

# Format numeric columns
fmt_map = {
    "WR":       lambda v: pct(v) if pd.notna(v) else "—",
    "PF":       lambda v: num(v) if pd.notna(v) else "—",
    "Expect $": lambda v: usd(v) if pd.notna(v) else "—",
    "Net PnL":  lambda v: usd(v) if pd.notna(v) else "—",
    "Max DD":   lambda v: usd(v) if pd.notna(v) else "—",
    "Sharpe":   lambda v: num(v, 2) if pd.notna(v) else "—",
    "Avg RR":   lambda v: num(v, 2) if pd.notna(v) else "—",
    "Score":    lambda v: f"{v:.1f}" if pd.notna(v) else "—",
}
for col, fn in fmt_map.items():
    if col in disp.columns:
        disp[col] = disp[col].apply(fn)

def _color_row(row):
    rank = row.get("Rank", 99)
    if rank == 1:   return ["background-color:#1a3a2a"] * len(row)
    if rank == 2:   return ["background-color:#1e2f3a"] * len(row)
    if rank == 3:   return ["background-color:#2a2a1e"] * len(row)
    return [""] * len(row)

st.dataframe(
    disp.style.apply(_color_row, axis=1),
    use_container_width=True, hide_index=True,
)

st.divider()

# ── Comparison Charts ──────────────────────────────────────────────────────────
tab_score, tab_exp, tab_pf, tab_dd = st.tabs(
    ["Rank Score", "Expectancy", "Profit Factor", "Drawdown"]
)

with tab_score:
    fig = go.Figure(go.Bar(
        x=lb["rank_score"],
        y=lb["EA"],
        orientation="h",
        marker_color=[
            "#26a69a" if s >= 65 else "#ffa726" if s >= 40 else "#ef5350"
            for s in lb["rank_score"]
        ],
        text=lb["rank_score"].apply(lambda v: f"{v:.1f}"),
        textposition="outside",
    ))
    fig.update_layout(
        height=max(300, len(lb) * 42), yaxis=dict(autorange="reversed"),
        xaxis=dict(range=[0, 105], title="Score (0–100)"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=60, t=10, b=0),
    )
    st.plotly_chart(fig, use_container_width=True)

with tab_exp:
    et = expectancy_table(df)
    if not et.empty:
        fig2 = go.Figure()
        fig2.add_trace(go.Bar(
            name="WR × AvgWin",
            x=et["EA"],
            y=et["WR"] * et["Avg Win"],
            marker_color=C_WIN,
            text=(et["WR"] * et["Avg Win"]).apply(lambda v: f"${v:,.1f}"),
            textposition="outside",
        ))
        fig2.add_trace(go.Bar(
            name="(1-WR) × |AvgLoss|",
            x=et["EA"],
            y=(1 - et["WR"]) * et["Avg Loss"],
            marker_color=C_LOSS,
            text=((1 - et["WR"]) * et["Avg Loss"]).apply(lambda v: f"${v:,.1f}"),
            textposition="outside",
        ))
        fig2.add_trace(go.Scatter(
            name="Expectancy",
            x=et["EA"], y=et["Expectancy"],
            mode="markers+text",
            marker=dict(size=10, color=C_PRIMARY, symbol="diamond"),
            text=et["Expectancy"].apply(lambda v: f"${v:,.1f}"),
            textposition="top center",
        ))
        fig2.add_hline(y=0, line_color="#546e7a", line_width=1)
        fig2.update_layout(
            barmode="relative", height=400,
            yaxis=dict(title="USD", gridcolor="#1e2130"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            legend=dict(orientation="h", y=1.05),
            margin=dict(l=0, r=0, t=10, b=0),
        )
        st.plotly_chart(fig2, use_container_width=True)

        st.dataframe(
            et.style.format({
                "WR":         "{:.1%}",
                "Avg Win":    "${:,.2f}",
                "Avg Loss":   "${:,.2f}",
                "Expectancy": "${:,.2f}",
                "Edge Ratio": "{:.2f}",
            }),
            use_container_width=True, hide_index=True,
        )

with tab_pf:
    lb_sorted = lb.sort_values("profit_factor", ascending=True, na_position="first")
    fig3 = go.Figure(go.Bar(
        x=lb_sorted["profit_factor"].clip(upper=5),
        y=lb_sorted["EA"],
        orientation="h",
        marker_color=[
            "#26a69a" if v and v >= 1.5 else "#ffa726" if v and v >= 1.0 else "#ef5350"
            for v in lb_sorted["profit_factor"]
        ],
        text=lb_sorted["profit_factor"].apply(lambda v: num(v) if pd.notna(v) else "—"),
        textposition="outside",
    ))
    fig3.add_vline(x=1.5, line_color="#ffd600", line_dash="dash", line_width=1,
                   annotation_text="1.5 target", annotation_position="top right")
    fig3.update_layout(
        height=max(300, len(lb) * 42), yaxis=dict(autorange="reversed"),
        xaxis=dict(title="Profit Factor (capped 5)"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=60, t=10, b=0),
    )
    st.plotly_chart(fig3, use_container_width=True)

with tab_dd:
    lb_sorted2 = lb.sort_values("max_drawdown", ascending=True)
    fig4 = go.Figure(go.Bar(
        x=lb_sorted2["max_drawdown"],
        y=lb_sorted2["EA"],
        orientation="h",
        marker_color=C_LOSS,
        text=lb_sorted2["max_drawdown"].apply(lambda v: usd(v) if pd.notna(v) else "—"),
        textposition="outside",
    ))
    fig4.update_layout(
        height=max(300, len(lb) * 42), yaxis=dict(autorange="reversed"),
        xaxis=dict(title="Max Drawdown (USD)"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=80, t=10, b=0),
    )
    st.plotly_chart(fig4, use_container_width=True)

# ── Win rate vs Net PnL scatter ────────────────────────────────────────────────
st.divider()
st.subheader("Win Rate × Net PnL  (bubble = trade count)")

if len(lb) >= 2:
    bubble_size = lb["total_trades"].apply(lambda v: max(v ** 0.5, 5))
    fig5 = go.Figure(go.Scatter(
        x=lb["win_rate"],
        y=lb["net_pnl"],
        mode="markers+text",
        text=lb["EA"],
        textposition="top center",
        marker=dict(
            size=bubble_size * 2,
            color=lb["rank_score"],
            colorscale="Teal",
            showscale=True,
            colorbar=dict(title="Score"),
            line=dict(width=1, color="#1e2130"),
        ),
        hovertemplate=(
            "<b>%{text}</b><br>"
            "WR: %{x:.1%}<br>"
            "Net PnL: $%{y:,.2f}<extra></extra>"
        ),
    ))
    fig5.add_vline(x=0.5, line_color="#546e7a", line_dash="dot", line_width=1)
    fig5.add_hline(y=0,   line_color="#546e7a", line_dash="dot", line_width=1)
    fig5.update_layout(
        height=420,
        xaxis=dict(title="Win Rate", tickformat=".0%", gridcolor="#1e2130"),
        yaxis=dict(title="Net PnL (USD)",              gridcolor="#1e2130"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=10, b=0),
    )
    st.plotly_chart(fig5, use_container_width=True)
