"""
9_EA_Risk.py — Per-EA Risk Matrix

Max drawdown waterfall, Sharpe comparison, Kelly sizing,
VaR, and consecutive-loss heatmap across all EAs.
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
from ea_engine import run_migration, ea_risk_table

st.set_page_config(page_title="EA Risk Matrix — QTrade OS", page_icon="⚠", layout="wide")
run_migration()

df_all = load_trades()
df     = sidebar_filters(df_all)

if not require_data(df, min_rows=1):
    st.stop()

st.title("⚠ EA Risk Matrix")
st.caption("Per-EA risk metrics: drawdown, Sharpe, VaR(95%), Kelly position sizing, consecutive losses.")

risk_df = ea_risk_table(df)
if risk_df.empty:
    st.warning("Need at least 3 trades per EA to compute risk metrics.")
    st.stop()

# ── Summary risk table ─────────────────────────────────────────────────────────
def _risk_color(row):
    out = []
    for col, val in row.items():
        if col == "Max DD":
            try:
                out.append("color:#ef5350" if float(val) < -500 else "")
            except Exception:
                out.append("")
        elif col == "Sharpe":
            try:
                out.append("color:#26a69a" if float(val) >= 1.0 else "color:#ffa726" if float(val) >= 0 else "color:#ef5350")
            except Exception:
                out.append("")
        elif col == "Max Consec L":
            try:
                out.append("color:#ef5350" if float(val) >= 5 else "color:#ffa726" if float(val) >= 3 else "")
            except Exception:
                out.append("")
        else:
            out.append("")
    return out

disp = risk_df.copy()
for c in ["Net PnL", "Max DD", "VaR 95%"]:
    if c in disp.columns:
        disp[c] = disp[c].apply(lambda v: usd(v) if pd.notna(v) else "—")
for c in ["Sharpe", "Recovery F", "Kelly f", "Half-Kelly"]:
    if c in disp.columns:
        disp[c] = disp[c].apply(lambda v: num(v, 3) if pd.notna(v) else "—")

st.dataframe(
    disp.style.apply(_risk_color, axis=1),
    use_container_width=True, hide_index=True,
)

st.divider()

# ── Drawdown waterfall ─────────────────────────────────────────────────────────
st.subheader("Max Drawdown by EA")

ea_list = sorted(df["strategy"].dropna().unique().tolist())
fig_dd  = go.Figure()

for ea in ea_list:
    grp   = df[df.strategy == ea].sort_values("open_time")
    cum   = grp["pnl_usd"].cumsum().reset_index(drop=True)
    dd    = (cum - cum.cummax()).reset_index(drop=True)
    fig_dd.add_trace(go.Scatter(
        x=list(range(len(dd))), y=dd,
        mode="lines", name=ea, fill="tozeroy",
        fillcolor="rgba(239,83,80,0.08)",
        line=dict(width=1.5),
    ))

fig_dd.update_layout(
    height=320, hovermode="x unified",
    xaxis=dict(title="Trade #", gridcolor="#1e2130"),
    yaxis=dict(title="Drawdown (USD)", gridcolor="#1e2130"),
    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
    legend=dict(orientation="h", y=1.05),
    margin=dict(l=0, r=0, t=10, b=0),
)
st.plotly_chart(fig_dd, use_container_width=True)

# ── Sharpe + VaR comparison ────────────────────────────────────────────────────
st.divider()
rc1, rc2 = st.columns(2)

with rc1:
    st.subheader("Sharpe Ratio")
    risk_s = risk_df.sort_values("Sharpe", ascending=True)
    fig_sh = go.Figure(go.Bar(
        x=risk_s["Sharpe"],
        y=risk_s["EA"],
        orientation="h",
        marker_color=[
            C_WIN if v >= 1.0 else "#ffa726" if v >= 0 else C_LOSS
            for v in risk_s["Sharpe"]
        ],
        text=risk_s["Sharpe"].apply(lambda v: num(v, 2) if pd.notna(v) else "—"),
        textposition="outside",
    ))
    fig_sh.add_vline(x=1.0, line_color="#ffd600", line_dash="dash", line_width=1,
                    annotation_text="1.0 target")
    fig_sh.add_vline(x=0.0, line_color="#546e7a", line_width=1)
    fig_sh.update_layout(
        height=max(250, len(risk_s) * 40),
        xaxis=dict(gridcolor="#1e2130"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=60, t=10, b=0),
    )
    st.plotly_chart(fig_sh, use_container_width=True)

with rc2:
    st.subheader("VaR 95%  (worst 5% of trades)")
    risk_v = risk_df.sort_values("VaR 95%", ascending=True)
    fig_var = go.Figure(go.Bar(
        x=risk_v["VaR 95%"],
        y=risk_v["EA"],
        orientation="h",
        marker_color=C_LOSS,
        text=risk_v["VaR 95%"].apply(lambda v: usd(v) if pd.notna(v) else "—"),
        textposition="outside",
    ))
    fig_var.update_layout(
        height=max(250, len(risk_v) * 40),
        xaxis=dict(title="USD (negative = loss)", gridcolor="#1e2130"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=80, t=10, b=0),
    )
    st.plotly_chart(fig_var, use_container_width=True)

# ── Kelly sizing guidance ──────────────────────────────────────────────────────
st.divider()
st.subheader("Kelly Position Sizing Guide")

kelly_df = risk_df[["EA", "Kelly f", "Half-Kelly"]].dropna(subset=["Kelly f"]).copy()
if kelly_df.empty:
    st.caption("Kelly requires RR actual data. Annotate trades with rr_actual to enable.")
else:
    kc1, kc2, kc3 = st.columns([2, 1, 1])
    with kc1:
        fig_k = go.Figure(go.Bar(
            x=kelly_df["Kelly f"],
            y=kelly_df["EA"],
            orientation="h",
            marker_color=[C_WIN if v > 0 else C_LOSS for v in kelly_df["Kelly f"]],
            name="Kelly f",
        ))
        fig_k.add_trace(go.Bar(
            x=kelly_df["Half-Kelly"],
            y=kelly_df["EA"],
            orientation="h",
            marker_color="#5c6bc0",
            name="Half-Kelly (recommended)",
        ))
        fig_k.add_vline(x=0, line_color="#546e7a", line_width=1)
        fig_k.update_layout(
            height=max(200, len(kelly_df) * 40),
            barmode="overlay", xaxis=dict(title="Fraction of capital"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            legend=dict(orientation="h", y=1.05),
            margin=dict(l=0, r=0, t=10, b=0),
        )
        st.plotly_chart(fig_k, use_container_width=True)

    with kc2:
        st.markdown("**Kelly formula**")
        st.latex(r"f = WR - \frac{1 - WR}{\text{Avg RR}}")
        st.caption("Positive f → edge exists. Negative → no edge at current WR + RR.")

    with kc3:
        st.markdown("**Practical sizing**")
        for _, kr in kelly_df.iterrows():
            hk = kr["Half-Kelly"]
            if hk and hk > 0:
                st.metric(kr["EA"], f"{hk*100:.1f}% / trade")

# ── Max consecutive losses heatmap ────────────────────────────────────────────
st.divider()
st.subheader("Consecutive Loss Streaks")

streak_rows = []
for ea in ea_list:
    grp = df[df.strategy == ea].sort_values("open_time")
    is_loss = (grp["outcome"] == "LOSS").astype(int).values
    max_streak = cur = 0
    for v in is_loss:
        cur = cur + 1 if v else 0
        max_streak = max(max_streak, cur)
    streak_rows.append({"EA": ea, "Max Streak": max_streak})

streak_df = pd.DataFrame(streak_rows).sort_values("Max Streak", ascending=False)
fig_str = go.Figure(go.Bar(
    x=streak_df["Max Streak"],
    y=streak_df["EA"],
    orientation="h",
    marker_color=[
        C_LOSS if v >= 5 else "#ffa726" if v >= 3 else "#546e7a"
        for v in streak_df["Max Streak"]
    ],
    text=streak_df["Max Streak"],
    textposition="outside",
))
fig_str.add_vline(x=3, line_color="#ffa726", line_dash="dash", line_width=1,
                  annotation_text="warn at 3", annotation_position="top right")
fig_str.add_vline(x=5, line_color=C_LOSS, line_dash="dash", line_width=1,
                  annotation_text="halt at 5", annotation_position="bottom right")
fig_str.update_layout(
    height=max(250, len(streak_df) * 40),
    xaxis=dict(title="Consecutive Losses", gridcolor="#1e2130"),
    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
    margin=dict(l=0, r=60, t=10, b=0),
)
st.plotly_chart(fig_str, use_container_width=True)
