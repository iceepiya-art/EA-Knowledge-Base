"""
12_Pairs.py — Pair & Regime Performance by EA

Heatmaps: EA × Symbol and EA × Regime.
Per-EA pair deep-dive with direction analysis.
"""

import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd
import numpy as np

from utils import load_trades, sidebar_filters, require_data, pct, usd, num, C_WIN, C_LOSS, C_PRIMARY, REGIME_COLORS
from ea_engine import run_migration, pair_breakdown, regime_breakdown

st.set_page_config(page_title="Pair & Regime — QTrade OS", page_icon="💱", layout="wide")
run_migration()

df_all = load_trades()
df     = sidebar_filters(df_all)

if not require_data(df, min_rows=5):
    st.stop()

st.title("💱 Pair & Regime Performance by EA")

def _heatmap(z_vals, x_labels, y_labels, colorscale, zmin, zmax, fmt, cb_title):
    fig = go.Figure(go.Heatmap(
        z=z_vals, x=x_labels, y=y_labels,
        colorscale=colorscale, zmin=zmin, zmax=zmax,
        text=[[f"{v:{fmt}}" if pd.notna(v) else "—" for v in row] for row in z_vals],
        texttemplate="%{text}",
        textfont=dict(size=11),
        colorbar=dict(title=cb_title),
        hoverongaps=False,
    ))
    fig.update_layout(
        height=max(280, len(y_labels) * 55 + 80),
        xaxis=dict(side="bottom"),
        paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
        margin=dict(l=0, r=0, t=10, b=0),
    )
    return fig

# ══════════════════════════════════════════════════════════════════════════════
# TAB: PAIRS  |  REGIME
# ══════════════════════════════════════════════════════════════════════════════

tab_pair, tab_regime, tab_detail = st.tabs(
    ["Symbol Heatmap", "Regime Heatmap", "EA Deep-Dive"]
)

# ── Pair breakdown ─────────────────────────────────────────────────────────────
with tab_pair:
    sub_p = pair_breakdown(df)
    if not sub_p or sub_p.get("wr") is None or sub_p["wr"].empty:
        st.warning("Not enough symbol data for heatmap.")
    else:
        wr_p   = sub_p["wr"]
        pnl_p  = sub_p["pnl"]
        cnt_p  = sub_p["count"]
        syms   = wr_p.columns.tolist()

        ptab_wr, ptab_pnl, ptab_cnt = st.tabs(["Win Rate", "Net PnL", "Trades"])

        with ptab_wr:
            fig = _heatmap(wr_p.values.tolist(), syms, wr_p.index.tolist(),
                           "RdYlGn", 0, 1, ".0%", "WR")
            st.plotly_chart(fig, use_container_width=True)
            st.caption("Rows = EA, Columns = Symbol. Green = high WR.")

        with ptab_pnl:
            absmax = float(np.nanmax(np.abs(pnl_p.fillna(0).values)))
            fig2   = _heatmap(pnl_p.values.tolist(), syms, pnl_p.index.tolist(),
                              "RdYlGn", -absmax, absmax, ".0f", "PnL $")
            st.plotly_chart(fig2, use_container_width=True)

        with ptab_cnt:
            fig3 = _heatmap(cnt_p.values.tolist(), syms, cnt_p.index.tolist(),
                            "Blues", 0, None, ".0f", "Trades")
            st.plotly_chart(fig3, use_container_width=True)

        # Best symbol per EA table
        st.markdown("##### Best Symbol per EA")
        best_sym_rows = []
        for ea in wr_p.index:
            row = wr_p.loc[ea].dropna()
            if not row.empty:
                best = row.idxmax()
                best_sym_rows.append({
                    "EA": ea,
                    "Best Symbol": best,
                    "WR":     pct(row.max()),
                    "Net PnL":usd(pnl_p.loc[ea, best]) if best in pnl_p.columns else "—",
                    "Trades": int(cnt_p.loc[ea, best]) if best in cnt_p.columns else 0,
                })
        if best_sym_rows:
            st.dataframe(pd.DataFrame(best_sym_rows), use_container_width=True, hide_index=True)

# ── Regime breakdown ───────────────────────────────────────────────────────────
with tab_regime:
    sub_r = regime_breakdown(df)
    if not sub_r or sub_r.get("wr") is None or sub_r["wr"].empty:
        st.warning("Not enough regime data. Tag regime via Annotate → Bulk Ops → Auto-Tag Regime.")
    else:
        REGIME_ORDER = ["TRENDING", "REVERTING", "WEAK", "CRASH", "UNKNOWN"]
        wr_r   = sub_r["wr"]
        pnl_r  = sub_r["pnl"]
        regs   = [r for r in REGIME_ORDER if r in wr_r.columns] + \
                 [r for r in wr_r.columns if r not in REGIME_ORDER]
        wr_r   = wr_r.reindex(columns=regs)
        pnl_r  = pnl_r.reindex(columns=regs)

        rtab_wr, rtab_pnl = st.tabs(["Win Rate", "Net PnL"])

        with rtab_wr:
            fig4 = _heatmap(wr_r.values.tolist(), regs, wr_r.index.tolist(),
                            "RdYlGn", 0, 1, ".0%", "WR")
            st.plotly_chart(fig4, use_container_width=True)
            st.caption("Which regime each EA performs best in. Crucial for regime-adaptive trading.")

        with rtab_pnl:
            absmax_r = float(np.nanmax(np.abs(pnl_r.fillna(0).values)))
            fig5     = _heatmap(pnl_r.values.tolist(), regs, pnl_r.index.tolist(),
                                "RdYlGn", -absmax_r, absmax_r, ".0f", "PnL $")
            st.plotly_chart(fig5, use_container_width=True)

        # Regime affinity summary
        st.markdown("##### Best Regime per EA")
        best_reg_rows = []
        for ea in wr_r.index:
            row = wr_r.loc[ea].dropna()
            if not row.empty:
                best = row.idxmax()
                best_reg_rows.append({
                    "EA": ea,
                    "Best Regime": best,
                    "WR": pct(row.max()),
                    "Net PnL": usd(pnl_r.loc[ea, best]) if best in pnl_r.columns else "—",
                })
        if best_reg_rows:
            st.dataframe(pd.DataFrame(best_reg_rows), use_container_width=True, hide_index=True)

# ── EA Deep-Dive ───────────────────────────────────────────────────────────────
with tab_detail:
    ea_list = sorted(df["strategy"].dropna().unique().tolist())
    sel_ea  = st.selectbox("Select EA", ea_list, key="pair_ea_sel")

    grp = df[df.strategy == sel_ea].copy()
    if grp.empty:
        st.warning(f"No data for {sel_ea}.")
        st.stop()

    # ── Pair performance ───────────────────────────────────────────────────────
    st.markdown(f"#### {sel_ea} — Symbol Analysis")
    sym_g = grp.groupby("symbol").agg(
        trades   = ("pnl_usd", "count"),
        net_pnl  = ("pnl_usd", "sum"),
        win_rate = ("is_win",  "mean"),
        avg_pnl  = ("pnl_usd", "mean"),
        best     = ("pnl_usd", "max"),
        worst    = ("pnl_usd", "min"),
    ).reset_index().sort_values("net_pnl", ascending=False)

    sc1, sc2 = st.columns(2)
    with sc1:
        fig_sym = go.Figure(go.Bar(
            x=sym_g["symbol"], y=sym_g["net_pnl"],
            marker_color=[C_WIN if v >= 0 else C_LOSS for v in sym_g["net_pnl"]],
            text=sym_g["net_pnl"].apply(lambda v: f"${v:,.0f}"),
            textposition="outside",
        ))
        fig_sym.add_hline(y=0, line_color="#546e7a", line_width=1)
        fig_sym.update_layout(
            title="Net PnL by Symbol", height=300,
            yaxis=dict(gridcolor="#1e2130"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0, r=0, t=40, b=0),
        )
        st.plotly_chart(fig_sym, use_container_width=True)

    with sc2:
        fig_sym2 = go.Figure(go.Bar(
            x=sym_g["symbol"], y=sym_g["win_rate"],
            marker_color=[C_WIN if v >= 0.5 else C_LOSS for v in sym_g["win_rate"]],
            text=sym_g["win_rate"].apply(lambda v: f"{v:.0%}"),
            textposition="outside",
        ))
        fig_sym2.add_hline(y=0.5, line_color="#ffd600", line_dash="dash", line_width=1)
        fig_sym2.update_layout(
            title="Win Rate by Symbol", height=300,
            yaxis=dict(tickformat=".0%", range=[0, 1.1], gridcolor="#1e2130"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0, r=0, t=40, b=0),
        )
        st.plotly_chart(fig_sym2, use_container_width=True)

    disp_s = sym_g.copy()
    for c in ["net_pnl", "avg_pnl", "best", "worst"]:
        disp_s[c] = disp_s[c].apply(lambda v: usd(v))
    disp_s["win_rate"] = disp_s["win_rate"].apply(pct)
    disp_s.columns = ["Symbol", "Trades", "Net PnL", "WR", "Avg PnL", "Best", "Worst"]
    st.dataframe(disp_s, use_container_width=True, hide_index=True)

    # ── Direction analysis ─────────────────────────────────────────────────────
    st.divider()
    st.markdown(f"#### {sel_ea} — Direction Analysis")

    dir_g = grp.groupby(["symbol", "direction"]).agg(
        trades   = ("pnl_usd", "count"),
        net_pnl  = ("pnl_usd", "sum"),
        win_rate = ("is_win",  "mean"),
    ).reset_index()

    dc1, dc2 = st.columns(2)
    for sym in grp["symbol"].dropna().unique():
        sym_dir = dir_g[dir_g.symbol == sym]
        if sym_dir.empty:
            continue
        fig_dir = go.Figure()
        for _, r in sym_dir.iterrows():
            color = C_WIN if r["direction"] == "BUY" else C_LOSS
            fig_dir.add_trace(go.Bar(
                name=r["direction"],
                x=[r["direction"]],
                y=[r["net_pnl"]],
                marker_color=color,
                text=[f"{pct(r['win_rate'])} WR<br>{r['trades']} trades"],
                textposition="outside",
            ))
        fig_dir.add_hline(y=0, line_color="#546e7a", line_width=1)
        fig_dir.update_layout(
            title=f"{sym} — BUY vs SELL", height=260,
            showlegend=False,
            yaxis=dict(title="Net PnL", gridcolor="#1e2130"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0, r=0, t=40, b=0),
        )
        col = dc1 if list(grp["symbol"].dropna().unique()).index(sym) % 2 == 0 else dc2
        col.plotly_chart(fig_dir, use_container_width=True)

    # ── Regime analysis for this EA ────────────────────────────────────────────
    regime_grp = grp.dropna(subset=["regime"])
    if not regime_grp.empty:
        st.divider()
        st.markdown(f"#### {sel_ea} — Regime Analysis")

        reg_g = regime_grp.groupby("regime").agg(
            trades   = ("pnl_usd", "count"),
            net_pnl  = ("pnl_usd", "sum"),
            win_rate = ("is_win",  "mean"),
            avg_pnl  = ("pnl_usd", "mean"),
        ).reset_index().sort_values("net_pnl", ascending=False)

        rcol1, rcol2 = st.columns(2)
        with rcol1:
            fig_reg = go.Figure(go.Bar(
                x=reg_g["regime"], y=reg_g["net_pnl"],
                marker_color=[REGIME_COLORS.get(r, "#546e7a") for r in reg_g["regime"]],
                text=reg_g["net_pnl"].apply(lambda v: f"${v:,.0f}"),
                textposition="outside",
            ))
            fig_reg.add_hline(y=0, line_color="#546e7a", line_width=1)
            fig_reg.update_layout(
                title="Net PnL by Regime", height=300,
                yaxis=dict(gridcolor="#1e2130"),
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0, r=0, t=40, b=0),
            )
            st.plotly_chart(fig_reg, use_container_width=True)

        with rcol2:
            fig_reg2 = go.Figure(go.Bar(
                x=reg_g["regime"], y=reg_g["win_rate"],
                marker_color=[REGIME_COLORS.get(r, "#546e7a") for r in reg_g["regime"]],
                text=reg_g["win_rate"].apply(lambda v: f"{v:.0%}"),
                textposition="outside",
            ))
            fig_reg2.add_hline(y=0.5, line_color="#ffd600", line_dash="dash", line_width=1)
            fig_reg2.update_layout(
                title="Win Rate by Regime", height=300,
                yaxis=dict(tickformat=".0%", range=[0, 1.1], gridcolor="#1e2130"),
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0, r=0, t=40, b=0),
            )
            st.plotly_chart(fig_reg2, use_container_width=True)

        # PnL distribution by regime (violin)
        pnl_data = []
        for reg, rg in regime_grp.groupby("regime"):
            for v in rg["pnl_usd"]:
                pnl_data.append({"Regime": reg, "PnL": v})
        if pnl_data:
            fig_vio = go.Figure()
            for reg in reg_g["regime"]:
                vals = [d["PnL"] for d in pnl_data if d["Regime"] == reg]
                if len(vals) >= 3:
                    fig_vio.add_trace(go.Violin(
                        y=vals, name=reg,
                        box_visible=True, meanline_visible=True,
                        fillcolor=REGIME_COLORS.get(reg, "#546e7a"),
                        opacity=0.7,
                        line_color="#1e2130",
                    ))
            fig_vio.add_hline(y=0, line_color="#546e7a", line_width=1)
            fig_vio.update_layout(
                title="PnL Distribution by Regime",
                height=320, showlegend=False,
                yaxis=dict(title="PnL (USD)", gridcolor="#1e2130"),
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0, r=0, t=40, b=0),
            )
            st.plotly_chart(fig_vio, use_container_width=True)
    else:
        st.caption("No regime labels on this EA's trades. Run Auto-Tag Regime in Annotate → Bulk Ops.")
