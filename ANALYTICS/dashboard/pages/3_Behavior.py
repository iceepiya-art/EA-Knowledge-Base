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
    pct, usd, C_WIN, C_LOSS, C_PRIMARY,
)
from performance import mistake_frequency

st.set_page_config(page_title="Behavior — QTrade OS", page_icon="🧠", layout="wide")
st.title("🧠 Behavior")
st.caption("The only part of trading fully in your control.")

df_all = load_trades()
df     = sidebar_filters(df_all)

if not require_data(df, min_rows=5):
    st.stop()

# ── Mistakes ───────────────────────────────────────────────────────────────────
st.subheader("Mistake Frequency & Cost")

mistakes = mistake_frequency(df)
if not mistakes.empty:
    cl, cr = st.columns([3, 2])
    with cl:
        fig = go.Figure()
        fig.add_trace(go.Bar(
            name="Frequency", x=mistakes["mistake"], y=mistakes["count"],
            marker_color=C_LOSS, opacity=0.85, yaxis="y",
        ))
        fig.add_trace(go.Scatter(
            name="Avg PnL", x=mistakes["mistake"], y=mistakes["avg_pnl"],
            mode="lines+markers",
            marker=dict(size=8, color=C_PRIMARY),
            line=dict(color=C_PRIMARY, width=2), yaxis="y2",
        ))
        fig.add_hline(y=0, line_color="#546e7a", line_width=1, yref="y2")
        fig.update_layout(
            height=300, hovermode="x unified",
            yaxis =dict(title="Count",        gridcolor="#1e2130"),
            yaxis2=dict(title="Avg PnL (USD)", overlaying="y", side="right",
                        gridcolor="rgba(0,0,0,0)"),
            legend=dict(orientation="h", y=1.1),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=0,t=20,b=0),
        )
        st.plotly_chart(fig, use_container_width=True)
    with cr:
        st.markdown("**Cost table**")
        disp = mistakes.copy()
        disp["avg_pnl"]   = disp["avg_pnl"].apply(usd)
        disp["total_pnl"] = disp["total_pnl"].apply(usd)
        st.dataframe(
            disp[["mistake","count","avg_pnl","total_pnl"]].rename(columns={
                "mistake":"Mistake","count":"N","avg_pnl":"Avg","total_pnl":"Total"
            }),
            hide_index=True, use_container_width=True,
        )
        top = mistakes.iloc[0]
        st.error(f"**Top mistake:** `{top['mistake']}` — {int(top['count'])}× | {usd(top['total_pnl'])} total cost")
else:
    st.info(
        "No mistake data yet.  \n"
        "Annotate with: `py -3.14 JOURNAL/journal_manager.py annotate --id ... --mistakes late_entry`"
    )

st.divider()

# ── Emotional state ────────────────────────────────────────────────────────────
st.subheader("Emotional State → Outcome")

EMOTION_COLORS = {
    "Calm":"#26a69a","Confident":"#66bb6a","Anxious":"#ffa726",
    "Bored":"#8d6e63","FOMO":"#ef5350","Revenge":"#b71c1c","Greedy":"#ff7043",
}

if "emotional_state" in df.columns and df["emotional_state"].notna().any():
    em = df[df["emotional_state"].notna()].copy()
    em_stats = (
        em.groupby("emotional_state")
          .agg(N=("pnl_usd","count"), win_rate=("is_win","mean"), avg_pnl=("pnl_usd","mean"))
          .reset_index()
          .sort_values("win_rate", ascending=True)
    )

    cl, cr = st.columns(2)
    with cl:
        colors = [EMOTION_COLORS.get(e, "#5c6bc0") for e in em_stats["emotional_state"]]
        fig = go.Figure(go.Bar(
            x=em_stats["win_rate"], y=em_stats["emotional_state"],
            orientation="h", marker_color=colors,
            text=em_stats.apply(lambda r: f"{pct(r['win_rate'])}  N={r['N']}", axis=1),
            textposition="outside",
        ))
        fig.add_vline(x=0.5, line_dash="dot", line_color="#546e7a")
        fig.update_layout(
            height=300, xaxis_tickformat=".0%", xaxis_range=[0,1],
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=0,t=10,b=0),
        )
        st.plotly_chart(fig, use_container_width=True)

    with cr:
        fig2 = px.scatter(
            em_stats, x="win_rate", y="avg_pnl", size="N",
            color="emotional_state", color_discrete_map=EMOTION_COLORS,
            text="emotional_state",
            labels={"win_rate":"Win Rate","avg_pnl":"Avg PnL (USD)"},
        )
        fig2.update_traces(textposition="top center")
        fig2.add_hline(y=0,   line_color="#546e7a", line_width=1)
        fig2.add_vline(x=0.5, line_dash="dot", line_color="#546e7a")
        fig2.update_layout(
            height=300, showlegend=False, xaxis_tickformat=".0%",
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=0,t=10,b=0),
        )
        st.plotly_chart(fig2, use_container_width=True)
else:
    st.info("No emotional state data. Annotate trades with `--emotional-state Calm/FOMO/Revenge`.")

st.divider()

# ── Plan discipline ────────────────────────────────────────────────────────────
st.subheader("Plan Discipline")

if "plan_followed" in df.columns and df["plan_followed"].notna().any():
    plan = (
        df.groupby("plan_followed")
          .agg(N=("pnl_usd","count"), win_rate=("is_win","mean"),
               avg_pnl=("pnl_usd","mean"), net_pnl=("pnl_usd","sum"))
          .reset_index()
    )
    plan["label"] = plan["plan_followed"].map({1:"Plan Followed", 0:"Plan Deviated"})

    cl, cr = st.columns(2)
    with cl:
        for _, row in plan.iterrows():
            st.metric(
                row["label"], pct(row["win_rate"]),
                f"N={int(row['N'])} | Avg: {usd(row['avg_pnl'])} | Net: {usd(row['net_pnl'])}"
            )
    with cr:
        if len(plan) == 2:
            wr_f = plan[plan.plan_followed==1]["win_rate"].values[0]
            wr_d = plan[plan.plan_followed==0]["win_rate"].values[0]
            cost = plan[plan.plan_followed==0]["net_pnl"].values[0]
            st.markdown(f"""
**Following plan:** {pct(wr_f)} WR
**Deviating:** {pct(wr_d)} WR
**Edge lost per deviated trade:** {pct(wr_f - wr_d)}
**Total PnL cost of deviation:** {usd(cost)}
""")
else:
    st.info("No plan_followed data. Annotate with `--plan-followed 1` or `0`.")

st.divider()

# ── Setup quality & execution score ───────────────────────────────────────────
cl, cr = st.columns(2)

with cl:
    st.subheader("Setup Quality vs Win Rate")
    if "setup_quality" in df.columns and df["setup_quality"].notna().any():
        sq = (
            df.groupby("setup_quality")
              .agg(N=("pnl_usd","count"), win_rate=("is_win","mean"))
              .reset_index()
        )
        fig = go.Figure(go.Bar(
            x=sq["setup_quality"].astype(str), y=sq["win_rate"],
            marker_color=[C_WIN if v >= 0.5 else C_LOSS for v in sq["win_rate"]],
            text=sq.apply(lambda r: f"{pct(r['win_rate'])} N={r['N']}", axis=1),
            textposition="outside",
        ))
        fig.update_layout(
            height=260, xaxis_title="Quality (1=poor, 5=textbook)",
            yaxis_tickformat=".0%", yaxis_range=[0,1],
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=0,t=10,b=0),
        )
        st.plotly_chart(fig, use_container_width=True)
    else:
        st.info("No setup quality scores.")

with cr:
    st.subheader("Execution Score Trend")
    if "execution_score" in df.columns and df["execution_score"].notna().any():
        ex = df[df["execution_score"].notna()].copy()
        roll = ex.set_index("trade_num")["execution_score"].rolling(10).mean().dropna()
        fig = go.Figure(go.Scatter(
            x=roll.index, y=roll,
            mode="lines", line=dict(color=C_PRIMARY, width=2),
            fill="tozeroy", fillcolor="rgba(92,107,192,0.08)",
        ))
        fig.add_hline(y=7, line_dash="dot", line_color=C_WIN, annotation_text="7 target")
        fig.update_layout(
            height=260, yaxis_range=[0,10],
            xaxis_title="Trade #", yaxis_title="Score (rolling 10)",
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=0,t=10,b=0),
        )
        st.plotly_chart(fig, use_container_width=True)
    else:
        st.info("No execution scores.")
