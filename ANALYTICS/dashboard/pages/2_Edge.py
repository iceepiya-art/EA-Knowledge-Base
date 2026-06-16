import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import plotly.express as px

from utils import (
    load_trades, sidebar_filters, require_data,
    group_stats, pct, usd, C_WIN, C_LOSS, REGIME_COLORS,
)
from performance import heatmap_regime_session, rr_distribution, rolling_winrate

st.set_page_config(page_title="Edge — QTrade OS", page_icon="🎯", layout="wide")
st.title("🎯 Edge Analysis")

df_all = load_trades()
df     = sidebar_filters(df_all)

if not require_data(df, min_rows=10):
    st.stop()

tab1, tab2, tab3, tab4 = st.tabs(["Strategy", "Session & Regime", "Heatmap", "RR & Streak"])

# ════ TAB 1 ════════════════════════════════════════════════════════════════════
with tab1:
    st.subheader("Strategy Comparison")
    ss = group_stats(df, "strategy")
    if ss.empty:
        st.info("No strategy data. Import trades with strategy tags.")
    else:
        fmt = {"WR":"{:.1%}","PF":"{:.2f}","Expectancy":"${:.2f}",
               "Net PnL":"${:,.2f}","Avg Win":"${:.2f}","Avg Loss":"${:.2f}"}
        st.dataframe(
            ss.style.format(fmt)
              .background_gradient(subset=["WR"],    cmap="RdYlGn", vmin=0.3, vmax=0.8)
              .background_gradient(subset=["PF"],    cmap="RdYlGn", vmin=0.5, vmax=3.0)
              .background_gradient(subset=["Net PnL"], cmap="RdYlGn"),
            use_container_width=True, hide_index=True,
        )
        fig = go.Figure(go.Bar(
            x=ss["strategy"], y=ss["WR"],
            marker_color=[C_WIN if v >= 0.5 else C_LOSS for v in ss["WR"]],
            text=ss["WR"].apply(pct), textposition="outside",
        ))
        fig.add_hline(y=0.5, line_dash="dot", line_color="#546e7a",
                      annotation_text="50% baseline")
        fig.update_layout(
            height=260, yaxis_tickformat=".0%", yaxis_range=[0,1],
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=0,t=20,b=0),
        )
        st.plotly_chart(fig, use_container_width=True)

# ════ TAB 2 ════════════════════════════════════════════════════════════════════
with tab2:
    cl, cr = st.columns(2)

    with cl:
        st.subheader("By Session")
        sess = group_stats(df, "session")
        if not sess.empty:
            fig = go.Figure(go.Bar(
                x=sess["WR"], y=sess["session"], orientation="h",
                marker_color=[C_WIN if v >= 0.5 else C_LOSS for v in sess["WR"]],
                text=sess.apply(lambda r: f"{pct(r['WR'])}  N={r['N']}", axis=1),
                textposition="outside",
            ))
            fig.add_vline(x=0.5, line_dash="dot", line_color="#546e7a")
            fig.update_layout(
                height=280, xaxis_tickformat=".0%", xaxis_range=[0,1],
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0,r=0,t=10,b=0),
            )
            st.plotly_chart(fig, use_container_width=True)
            st.dataframe(
                sess[["session","N","WR","PF","Net PnL"]]
                    .style.format({"WR":"{:.1%}","PF":"{:.2f}","Net PnL":"${:,.2f}"}),
                hide_index=True, use_container_width=True,
            )
        else:
            st.info("No session data.")

    with cr:
        st.subheader("By Regime")
        reg = group_stats(df, "regime")
        if not reg.empty:
            colors = [REGIME_COLORS.get(r, "#5c6bc0") for r in reg["regime"]]
            fig = go.Figure(go.Bar(
                x=reg["WR"], y=reg["regime"], orientation="h",
                marker_color=colors,
                text=reg.apply(lambda r: f"{pct(r['WR'])}  N={r['N']}", axis=1),
                textposition="outside",
            ))
            fig.add_vline(x=0.5, line_dash="dot", line_color="#546e7a")
            fig.update_layout(
                height=280, xaxis_tickformat=".0%", xaxis_range=[0,1],
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0,r=0,t=10,b=0),
            )
            st.plotly_chart(fig, use_container_width=True)
            st.dataframe(
                reg[["regime","N","WR","PF","Net PnL"]]
                    .style.format({"WR":"{:.1%}","PF":"{:.2f}","Net PnL":"${:,.2f}"}),
                hide_index=True, use_container_width=True,
            )
        else:
            st.info("No regime data. Import ea_fix20_trades.csv or run SC100 tagger.")

# ════ TAB 3 ════════════════════════════════════════════════════════════════════
with tab3:
    st.subheader("Win Rate Heatmap — Regime × Session")
    st.caption("Find which regime+session combination has real edge.")
    pivot = heatmap_regime_session(df)
    if pivot is not None and not pivot.empty:
        fig = px.imshow(
            pivot,
            color_continuous_scale=[[0,"#ef5350"],[0.5,"#1e2130"],[1,"#26a69a"]],
            zmin=0.3, zmax=0.8,
            text_auto=".0%",
            aspect="auto",
            labels=dict(color="Win Rate"),
        )
        fig.update_traces(textfont_size=18)
        fig.update_layout(
            height=320,
            paper_bgcolor="rgba(0,0,0,0)",
            coloraxis_colorbar=dict(tickformat=".0%"),
            margin=dict(l=0,r=0,t=20,b=0),
        )
        st.plotly_chart(fig, use_container_width=True)
        max_idx = pivot.stack().idxmax()
        min_idx = pivot.stack().idxmin()
        cl2, cr2 = st.columns(2)
        cl2.success(f"**Best:** {max_idx[0]} × {max_idx[1]} → {pct(pivot.stack().max())} WR")
        cr2.error(f"**Worst:** {min_idx[0]} × {min_idx[1]} → {pct(pivot.stack().min())} WR")
    else:
        st.info("Need regime + session tags on ≥20 trades.")

# ════ TAB 4 ════════════════════════════════════════════════════════════════════
with tab4:
    cl, cr = st.columns(2)

    with cl:
        st.subheader("RR Distribution")
        rr_df = rr_distribution(df)
        if not rr_df.empty and "rr_actual" in rr_df.columns:
            clean = rr_df[rr_df["rr_actual"].abs() < 20].copy()
            fig = px.histogram(
                clean, x="rr_actual", color="outcome",
                color_discrete_map={"WIN":C_WIN,"LOSS":C_LOSS,"BREAKEVEN":"#bdbdbd"},
                nbins=40, barmode="overlay", opacity=0.75,
                labels={"rr_actual":"RR Actual"},
            )
            fig.add_vline(x=1.5, line_dash="dot", line_color=C_WIN,
                          annotation_text="1.5R target")
            fig.update_layout(
                height=280, paper_bgcolor="rgba(0,0,0,0)",
                plot_bgcolor="rgba(0,0,0,0)", margin=dict(l=0,r=0,t=20,b=0),
            )
            st.plotly_chart(fig, use_container_width=True)
        else:
            st.info("No RR data available.")

    with cr:
        st.subheader("Rolling 20-Trade Win Rate")
        roll = rolling_winrate(df, 20)
        if not roll.empty:
            fig = go.Figure(go.Scatter(
                x=roll.index, y=roll,
                mode="lines", line=dict(color="#5c6bc0", width=2),
                fill="tozeroy", fillcolor="rgba(92,107,192,0.08)",
            ))
            fig.add_hline(y=0.5, line_dash="dot", line_color="#546e7a", annotation_text="50%")
            fig.add_hrect(y0=0, y1=0.4, fillcolor="rgba(239,83,80,0.06)", line_width=0)
            fig.update_layout(
                height=280, yaxis_tickformat=".0%", yaxis_range=[0,1],
                xaxis_title="Trade #",
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0,r=0,t=20,b=0),
            )
            st.plotly_chart(fig, use_container_width=True)
            cur = roll.iloc[-1]
            (st.success if cur >= 0.5 else st.warning if cur >= 0.4 else st.error)(
                f"Current rolling WR: **{pct(cur)}**"
            )
        else:
            st.info("Need ≥20 trades for rolling win rate.")
