"""
11_Session.py — Session Performance by EA

Heatmaps: EA × Session for WR, Net PnL, Trade Count.
Best session per EA. Session time-of-day distribution.
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
from ea_engine import run_migration, session_breakdown

st.set_page_config(page_title="Session Performance — QTrade OS", page_icon="⏰", layout="wide")
run_migration()

df_all = load_trades()
df     = sidebar_filters(df_all)

if not require_data(df, min_rows=5):
    st.stop()

SESSION_ORDER = ["Asian", "London", "Pre_NY", "London_NY", "NY", "Other"]

st.title("⏰ Session Performance by EA")

# ── Fill missing session labels ────────────────────────────────────────────────
missing_sess = df["session"].isna().sum()
if missing_sess > 0:
    st.info(f"{missing_sess} trades have no session label — auto-tagging them now.")
    from annotator import batch_auto_tag
    batch_auto_tag(fields=["session"])
    st.cache_data.clear()
    st.rerun()

sub = session_breakdown(df)
if not sub or sub.get("wr") is None or sub["wr"].empty:
    st.warning("Not enough session data. Check that trades have session labels.")
    st.stop()

wr_piv  = sub["wr"]
pnl_piv = sub["pnl"]
cnt_piv = sub["count"]

# Reorder columns to session order
sess_cols = [s for s in SESSION_ORDER if s in wr_piv.columns]
extra     = [s for s in wr_piv.columns if s not in sess_cols]
col_order = sess_cols + extra

wr_piv  = wr_piv.reindex(columns=col_order)
pnl_piv = pnl_piv.reindex(columns=col_order)
cnt_piv = cnt_piv.reindex(columns=col_order)

tab_wr, tab_pnl, tab_cnt = st.tabs(["Win Rate Heatmap", "Net PnL Heatmap", "Trade Count"])

def _heatmap(z, x, y, title, fmt=".1%", colorscale="Teal", zmin=None, zmax=None):
    fig = go.Figure(go.Heatmap(
        z=z,
        x=x,
        y=y,
        colorscale=colorscale,
        zmin=zmin, zmax=zmax,
        text=[[f"{v:{fmt}}" if not np.isnan(v) else "—" for v in row] for row in z],
        texttemplate="%{text}",
        textfont=dict(size=11),
        colorbar=dict(title=title),
        hoverongaps=False,
    ))
    fig.update_layout(
        height=max(280, len(y) * 55 + 80),
        xaxis=dict(side="bottom"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=10, b=0),
    )
    return fig

with tab_wr:
    st.caption("Green = high win rate. Red = low. Grey = no data.")
    z = wr_piv.values.tolist()
    fig = _heatmap(z, col_order, wr_piv.index.tolist(), "WR",
                   fmt=".0%", colorscale="RdYlGn", zmin=0, zmax=1)
    st.plotly_chart(fig, use_container_width=True)

    # Best session per EA
    st.markdown("##### Best Session per EA")
    best_rows = []
    for ea in wr_piv.index:
        row = wr_piv.loc[ea].dropna()
        if not row.empty:
            best_sess = row.idxmax()
            best_wr   = row.max()
            pnl_val   = pnl_piv.loc[ea, best_sess] if best_sess in pnl_piv.columns else None
            cnt_val   = int(cnt_piv.loc[ea, best_sess]) if best_sess in cnt_piv.columns else 0
            best_rows.append({
                "EA": ea, "Best Session": best_sess,
                "WR": pct(best_wr), "Net PnL": usd(pnl_val), "Trades": cnt_val,
            })
    if best_rows:
        st.dataframe(pd.DataFrame(best_rows), use_container_width=True, hide_index=True)

with tab_pnl:
    st.caption("Cell color = net PnL. Dark green = profitable. Dark red = losing.")
    pnl_z  = pnl_piv.values.tolist()
    absmax = float(np.nanmax(np.abs(pnl_piv.values)))
    fig2   = _heatmap(pnl_z, col_order, pnl_piv.index.tolist(), "PnL USD",
                      fmt=".0f", colorscale="RdYlGn",
                      zmin=-absmax, zmax=absmax)
    st.plotly_chart(fig2, use_container_width=True)

with tab_cnt:
    cnt_z = cnt_piv.values.tolist()
    fig3  = _heatmap(cnt_z, col_order, cnt_piv.index.tolist(), "Trades",
                     fmt=".0f", colorscale="Blues", zmin=0)
    st.plotly_chart(fig3, use_container_width=True)

# ── Per-EA session bar charts ──────────────────────────────────────────────────
st.divider()
st.subheader("Per-EA Session Breakdown")

ea_list = sorted(df["strategy"].dropna().unique().tolist())
sel_ea  = st.selectbox("Select EA", ea_list, key="sess_ea_sel")

grp = df[df.strategy == sel_ea].dropna(subset=["session"])
if grp.empty:
    st.caption(f"No session data for {sel_ea}.")
else:
    sess_grp = grp.groupby("session").agg(
        trades    = ("pnl_usd", "count"),
        net_pnl   = ("pnl_usd", "sum"),
        win_rate  = ("is_win",  "mean"),
        avg_pnl   = ("pnl_usd", "mean"),
    ).reset_index()
    sess_grp = sess_grp.sort_values("net_pnl", ascending=False)

    bc1, bc2 = st.columns(2)
    with bc1:
        fig_bar = go.Figure(go.Bar(
            x=sess_grp["session"], y=sess_grp["net_pnl"],
            marker_color=[C_WIN if v >= 0 else C_LOSS for v in sess_grp["net_pnl"]],
            text=sess_grp["net_pnl"].apply(lambda v: f"${v:,.0f}"),
            textposition="outside",
            name="Net PnL",
        ))
        fig_bar.add_hline(y=0, line_color="#546e7a", line_width=1)
        fig_bar.update_layout(
            title=f"{sel_ea} — Net PnL by Session",
            height=300, yaxis=dict(title="USD", gridcolor="#1e2130"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0, r=0, t=40, b=0),
        )
        st.plotly_chart(fig_bar, use_container_width=True)

    with bc2:
        fig_wr = go.Figure(go.Bar(
            x=sess_grp["session"], y=sess_grp["win_rate"],
            marker_color=[C_WIN if v >= 0.5 else C_LOSS for v in sess_grp["win_rate"]],
            text=sess_grp["win_rate"].apply(lambda v: f"{v:.0%}"),
            textposition="outside",
            name="Win Rate",
        ))
        fig_wr.add_hline(y=0.5, line_color="#ffd600", line_dash="dash", line_width=1)
        fig_wr.update_layout(
            title=f"{sel_ea} — Win Rate by Session",
            height=300,
            yaxis=dict(title="Win Rate", tickformat=".0%", range=[0, 1.1], gridcolor="#1e2130"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0, r=0, t=40, b=0),
        )
        st.plotly_chart(fig_wr, use_container_width=True)

    # Summary table
    disp = sess_grp.copy()
    disp["win_rate"] = disp["win_rate"].apply(pct)
    disp["net_pnl"]  = disp["net_pnl"].apply(lambda v: usd(v))
    disp["avg_pnl"]  = disp["avg_pnl"].apply(lambda v: usd(v))
    disp.columns     = ["Session", "Trades", "Net PnL", "WR", "Avg PnL"]
    st.dataframe(disp[["Session", "Trades", "WR", "Net PnL", "Avg PnL"]],
                 use_container_width=True, hide_index=True)

# ── Hour-of-day PnL distribution ───────────────────────────────────────────────
st.divider()
st.subheader("Hour-of-Day PnL Heatmap  (EA × Broker Hour)")

df_h = df.copy()
df_h["hour"] = df_h["open_time"].dt.hour
hourly = df_h.groupby(["strategy", "hour"])["pnl_usd"].mean().unstack("hour")

if not hourly.empty:
    fig_h = go.Figure(go.Heatmap(
        z=hourly.values,
        x=hourly.columns.tolist(),
        y=hourly.index.tolist(),
        colorscale="RdYlGn",
        colorbar=dict(title="Avg PnL"),
        hoverongaps=False,
        texttemplate="%{z:.0f}",
        textfont=dict(size=9),
    ))
    fig_h.update_layout(
        height=max(280, len(hourly) * 50 + 80),
        xaxis=dict(title="Broker Hour (EET)", dtick=1),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=10, b=0),
    )
    st.plotly_chart(fig_h, use_container_width=True)
    st.caption("Broker time = EET (UTC+2). Rows = EA, Columns = hour. Color = avg PnL per trade in that hour.")
