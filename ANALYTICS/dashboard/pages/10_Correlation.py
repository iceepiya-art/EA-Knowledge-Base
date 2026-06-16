"""
10_Correlation.py — EA Correlation & Portfolio Analysis

Pearson correlation heatmap between EA daily PnL streams.
Portfolio equity with diversification metrics.
Scatter plots: pairwise EA PnL days.
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
from ea_engine import run_migration, correlation_matrix, portfolio_equity

st.set_page_config(page_title="EA Correlation — QTrade OS", page_icon="🔗", layout="wide")
run_migration()

df_all = load_trades()
df     = sidebar_filters(df_all)

if not require_data(df, min_rows=10):
    st.stop()

st.title("🔗 EA Correlation & Portfolio")
st.caption("Daily PnL correlation (Pearson). Low/negative correlation = good diversification.")

# ── Build daily PnL pivot ──────────────────────────────────────────────────────
df2 = df.copy()
df2["date"] = pd.to_datetime(df2["open_time"]).dt.date

daily = df2.pivot_table(
    values="pnl_usd", index="date", columns="strategy",
    aggfunc="sum", fill_value=0,
)

# Filter: EAs with ≥ 10 trading days
active_eas = [c for c in daily.columns if (daily[c] != 0).sum() >= 10]
if len(active_eas) < 2:
    st.warning(
        "Need at least 2 EAs with ≥10 trading days each to compute correlations.  \n"
        f"Currently available: {list(daily.columns)}"
    )
    st.stop()

daily = daily[active_eas]
corr  = daily.corr(method="pearson").round(3)


# ── Pair label helpers (defined before use) ────────────────────────────────────
def _get_max_pair(c: pd.DataFrame) -> str:
    mask = np.triu(np.ones(c.shape), k=1).astype(bool)
    vals = c.where(mask).stack()
    if vals.empty: return "—"
    idx = vals.idxmax()
    return f"{idx[0]} / {idx[1]}  ({vals.max():.2f})"

def _get_min_pair(c: pd.DataFrame) -> str:
    mask = np.triu(np.ones(c.shape), k=1).astype(bool)
    vals = c.where(mask).stack()
    if vals.empty: return "—"
    idx = vals.idxmin()
    return f"{idx[0]} / {idx[1]}  ({vals.min():.2f})"


# ── Correlation heatmap ────────────────────────────────────────────────────────
st.subheader("Daily PnL Correlation Matrix")

fig_corr = go.Figure(go.Heatmap(
    z=corr.values,
    x=corr.columns.tolist(),
    y=corr.index.tolist(),
    colorscale=[
        [0.0,  "#ef5350"],   # -1.0  high positive correlation = bad (red)
        [0.5,  "#1e2130"],   # 0.0   uncorrelated = neutral
        [1.0,  "#26a69a"],   # +1.0  — wait, we want NEGATIVE correlation to be green
    ],
    # Flip: green for negative corr (diversifying), red for positive (concentrated)
    colorscale_flip=False,
    zmin=-1, zmax=1,
    text=corr.values.round(2),
    texttemplate="%{text}",
    textfont=dict(size=12),
    colorbar=dict(title="Pearson r"),
))

# Use a custom colorscale: negative = green (diversifying), positive = red (concentrated)
fig_corr.data[0].colorscale = [
    [0.0,  "#26a69a"],  # -1 → green (diversifying)
    [0.5,  "#37474f"],  # 0  → neutral
    [1.0,  "#ef5350"],  # +1 → red (concentrated risk)
]

fig_corr.update_layout(
    height=max(300, len(active_eas) * 70),
    xaxis=dict(side="bottom"),
    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
    margin=dict(l=0, r=0, t=10, b=0),
)
st.plotly_chart(fig_corr, use_container_width=True)

# ── Interpretation guide ───────────────────────────────────────────────────────
col_a, col_b, col_c = st.columns(3)
col_a.metric("Avg pairwise correlation",
             num(np.triu(corr.values, 1)[np.triu(corr.values, 1) != 0].mean(), 3))
col_b.metric("Most correlated pair",
             _get_max_pair(corr) if len(corr) > 1 else "—")
col_c.metric("Most diversifying pair",
             _get_min_pair(corr) if len(corr) > 1 else "—")

# ── Portfolio equity vs individual EAs ────────────────────────────────────────
st.divider()
st.subheader("Portfolio vs Individual EA Equity Curves")

port = portfolio_equity(df)
if port.empty:
    st.warning("No portfolio data.")
else:
    ea_cols = [c for c in port.columns if not c.startswith("cum_") and c not in ("date", "portfolio")]
    fig_port = go.Figure()

    # Individual EAs (muted)
    for ea in ea_cols:
        cum_col = f"cum_{ea}"
        if cum_col in port.columns:
            fig_port.add_trace(go.Scatter(
                x=port["date"], y=port[cum_col],
                mode="lines", name=ea,
                line=dict(width=1, dash="dot"),
                opacity=0.5,
            ))

    # Portfolio (bold)
    fig_port.add_trace(go.Scatter(
        x=port["date"], y=port["cum_portfolio"],
        mode="lines", name="Portfolio",
        line=dict(color=C_PRIMARY, width=3),
        fill="tozeroy", fillcolor="rgba(92,107,192,0.07)",
    ))
    fig_port.add_hline(y=0, line_color="#546e7a", line_width=1)
    fig_port.update_layout(
        height=380, hovermode="x unified",
        xaxis=dict(gridcolor="#1e2130"),
        yaxis=dict(title="Cumulative PnL (USD)", gridcolor="#1e2130"),
        legend=dict(orientation="h", y=1.05),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=10, b=0),
    )
    st.plotly_chart(fig_port, use_container_width=True)

    # ── Portfolio stats ────────────────────────────────────────────────────────
    cum_port = port["cum_portfolio"]
    port_dd  = cum_port - cum_port.cummax()
    p1, p2, p3, p4 = st.columns(4)
    p1.metric("Portfolio Net PnL",  usd(float(port["portfolio"].sum())))
    p2.metric("Portfolio Max DD",   usd(float(port_dd.min())))
    daily_ret = port["portfolio"]
    p3.metric("Portfolio Sharpe",
              num(float(daily_ret.mean() / daily_ret.std() * np.sqrt(252))
                  if daily_ret.std() > 0 else 0, 2))
    p4.metric("Trading Days", str(len(port)))

# ── Pairwise PnL scatter (all EA pairs) ───────────────────────────────────────
if len(active_eas) >= 2:
    st.divider()
    st.subheader("Pairwise Daily PnL Scatter")

    pairs = [(active_eas[i], active_eas[j])
             for i in range(len(active_eas)) for j in range(i+1, len(active_eas))]

    if len(pairs) <= 6:
        n_cols = min(len(pairs), 3)
        cols   = st.columns(n_cols)
        for pi, (ea_a, ea_b) in enumerate(pairs):
            corr_val = float(corr.loc[ea_a, ea_b]) if ea_a in corr.index else 0
            corr_color = C_WIN if corr_val < 0 else "#ffa726" if corr_val < 0.5 else C_LOSS
            with cols[pi % n_cols]:
                fig_sc = px.scatter(
                    x=daily[ea_a], y=daily[ea_b],
                    labels={"x": ea_a, "y": ea_b},
                    title=f"r = {corr_val:.2f}",
                )
                fig_sc.add_hline(y=0, line_color="#546e7a", line_width=0.8)
                fig_sc.add_vline(x=0, line_color="#546e7a", line_width=0.8)
                fig_sc.update_traces(
                    marker=dict(color=corr_color, size=5, opacity=0.7)
                )
                fig_sc.update_layout(
                    height=260,
                    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                    margin=dict(l=0, r=0, t=30, b=0),
                    xaxis=dict(gridcolor="#1e2130"),
                    yaxis=dict(gridcolor="#1e2130"),
                )
                st.plotly_chart(fig_sc, use_container_width=True)
    else:
        st.caption(f"{len(pairs)} pairs — showing correlation table only (too many to scatter-plot).")

# ── Daily PnL distribution per EA ─────────────────────────────────────────────
st.divider()
st.subheader("Daily PnL Distribution")

fig_box = go.Figure()
for ea in active_eas:
    fig_box.add_trace(go.Box(
        y=daily[ea],
        name=ea,
        boxpoints="outliers",
        marker_color=C_PRIMARY,
        line_color=C_PRIMARY,
    ))
fig_box.add_hline(y=0, line_color="#546e7a", line_width=1)
fig_box.update_layout(
    height=360,
    yaxis=dict(title="Daily PnL (USD)", gridcolor="#1e2130"),
    paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
    margin=dict(l=0, r=0, t=10, b=0),
    showlegend=False,
)
st.plotly_chart(fig_box, use_container_width=True)
