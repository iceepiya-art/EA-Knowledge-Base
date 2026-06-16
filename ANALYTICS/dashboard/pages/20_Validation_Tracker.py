"""
20_Validation_Tracker.py — Validation Tracker

Statistical validation dashboard for all active hypotheses.
Shows: N progress, confidence scores, evidence strength, promotion readiness.
Focused on the question: "Is this hypothesis ready to validate?"
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

from utils import load_trades, pct, usd, num, C_WIN, C_LOSS, C_PRIMARY
from hypothesis_tracker import (
    run_migration,
    STATUSES, STATUS_COLORS,
    get_hypotheses, get_hypothesis,
    get_edges, refresh_edge_stats,
    compute_confidence_score, compute_edge_score,
    get_evidence, refresh_all_stats, promote_to_edge,
)

st.set_page_config(
    page_title="Validation Tracker — QTrade OS",
    page_icon="📊",
    layout="wide",
)

run_migration()

df_all = load_trades()

# ── Header ────────────────────────────────────────────────────────────────────
st.title("📊 Validation Tracker")
st.caption(
    "Track validation progress for all active hypotheses. "
    "Confidence score = statistical readiness for promotion. "
    "All validation decisions are **human-only** — no auto-promotion."
)

all_hyps = get_hypotheses()
edges    = get_edges(active_only=True)

if not all_hyps.empty:
    counts = all_hyps["status"].value_counts().to_dict()
else:
    counts = {}

vh1, vh2, vh3, vh4 = st.columns(4)
vh1.metric("🔬 In Testing",   counts.get("testing",   0))
vh2.metric("🔭 In Observing", counts.get("observing", 0))
vh3.metric("✅ Validated",    counts.get("validated", 0))
vh4.metric("🔗 Live Edges",   len(edges))

st.divider()

# ── Refresh ───────────────────────────────────────────────────────────────────
rb1, rb2, _ = st.columns([1, 1, 3])
if rb1.button("🔄 Refresh All Stats"):
    n = refresh_all_stats(df_all)
    st.success(f"Refreshed {n} hypotheses.")
    st.rerun()
if rb2.button("🔄 Refresh Edge Stats"):
    n = refresh_edge_stats(df_all)
    st.success(f"Refreshed {n} edges.")
    st.rerun()

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1 — VALIDATION PROGRESS TABLE
# ══════════════════════════════════════════════════════════════════════════════
st.subheader("Validation Progress")

active = all_hyps[all_hyps["status"].isin(["testing", "observing"])].copy()

if active.empty:
    st.info("No hypotheses in testing or observing. Start testing ideas in **Hypotheses** (page 15).")
else:
    rows = []
    for _, row in active.iterrows():
        n     = int(row.get("actual_n") or 0)
        min_n = int(row.get("min_trades") or 30)
        wr    = row.get("actual_wr")
        pf_v  = row.get("actual_pf")
        twr   = row.get("target_wr")
        tpf   = row.get("target_pf")
        conf  = float(row.get("confidence_score") or 0)
        status = row["status"]

        # WR vs target
        wr_hit   = "✅" if (wr and twr and float(wr) >= float(twr)) else ("⚠️" if wr else "—")
        pf_hit   = "✅" if (pf_v and tpf and float(pf_v) >= float(tpf)) else ("⚠️" if pf_v else "—")
        n_ready  = "✅" if n >= min_n else f"{n}/{min_n}"
        ready    = (n >= min_n and conf >= 60)

        rows.append({
            "ID":          row["hyp_id"],
            "Title":       row["title"][:45],
            "Status":      status.upper(),
            "N / Min":     f"{n:,} / {min_n}",
            "Sample %":    min(n / max(min_n, 1), 1.0) * 100,
            "WR":          pct(wr) if wr else "—",
            "WR Target":   wr_hit,
            "PF":          num(pf_v) if pf_v else "—",
            "PF Target":   pf_hit,
            "Confidence":  conf,
            "Promote?":    "✅ Ready" if ready else "⏳ Not yet",
        })

    df_tbl = pd.DataFrame(rows)
    st.dataframe(
        df_tbl, use_container_width=True, hide_index=True,
        column_config={
            "Sample %": st.column_config.ProgressColumn(
                "Sample %", min_value=0, max_value=100, format="%.0f%%",
            ),
            "Confidence": st.column_config.ProgressColumn(
                "Confidence", min_value=0, max_value=100, format="%.0f",
            ),
        },
    )

    st.divider()

    # ── Confidence score bar chart ────────────────────────────────────────────
    if len(active) >= 2:
        fig_conf = go.Figure(go.Bar(
            x=active["hyp_id"],
            y=active["confidence_score"].fillna(0),
            marker_color=[
                C_WIN if float(v or 0) >= 60 else (C_PRIMARY if float(v or 0) >= 40 else C_LOSS)
                for v in active["confidence_score"]
            ],
            text=active["confidence_score"].fillna(0).apply(lambda x: f"{x:.0f}"),
            textposition="auto",
        ))
        fig_conf.add_hline(y=60, line_dash="dash", line_color="#ffd600",
                           annotation_text="Promote threshold (60)")
        fig_conf.update_layout(
            height=250, title="Confidence Score by Hypothesis",
            xaxis=dict(gridcolor="#1e2130"),
            yaxis=dict(range=[0, 100], title="Confidence Score", gridcolor="#1e2130"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0, r=0, t=40, b=0),
        )
        st.plotly_chart(fig_conf, use_container_width=True)

    st.divider()

    # ── Per-hypothesis detail ──────────────────────────────────────────────────
    st.subheader("Hypothesis Detail")
    sel_hyp = st.selectbox(
        "Select hypothesis",
        ["—"] + active["hyp_id"].tolist(),
        key="val_sel",
    )

    if sel_hyp and sel_hyp != "—":
        hyp = get_hypothesis(sel_hyp)
        if hyp:
            n     = int(hyp.get("actual_n") or 0)
            min_n = int(hyp.get("min_trades") or 30)
            conf  = compute_confidence_score(hyp)
            wr    = hyp.get("actual_wr")
            pf_v  = hyp.get("actual_pf")
            exp   = hyp.get("actual_exp")
            status = hyp["status"]

            # Confidence gauge
            gc1, gc2 = st.columns([1, 2])
            with gc1:
                fig_gauge = go.Figure(go.Indicator(
                    mode="gauge+number",
                    value=conf,
                    title={"text": "Confidence"},
                    gauge={
                        "axis": {"range": [0, 100]},
                        "bar":  {"color": C_WIN if conf >= 60 else (C_PRIMARY if conf >= 40 else C_LOSS)},
                        "steps": [
                            {"range": [0, 40],  "color": "#1a1a2e"},
                            {"range": [40, 60], "color": "#1e2130"},
                            {"range": [60, 100],"color": "#0d2137"},
                        ],
                        "threshold": {
                            "line": {"color": "#ffd600", "width": 2},
                            "thickness": 0.75,
                            "value": 60,
                        },
                    },
                    number={"suffix": "/100"},
                ))
                fig_gauge.update_layout(
                    height=220,
                    paper_bgcolor="rgba(0,0,0,0)",
                    margin=dict(l=20, r=20, t=40, b=20),
                    font=dict(color="#e0e0e0"),
                )
                st.plotly_chart(fig_gauge, use_container_width=True)

            with gc2:
                st.markdown(f"**{sel_hyp}: {hyp['title']}**")
                _sc = STATUS_COLORS.get(status, "#8892b0")
                st.markdown(
                    f"Status: <span style='color:{_sc}'>"
                    f"**{status.upper()}**</span>",
                    unsafe_allow_html=True,
                )

                m1, m2, m3, m4 = st.columns(4)
                m1.metric("N",         f"{n:,}")
                m2.metric("Win Rate",  pct(wr)   if wr   else "—")
                m3.metric("PF",        num(pf_v) if pf_v else "—")
                m4.metric("Exp/trade", usd(exp)  if exp  else "—")

                # Target comparison
                twr = hyp.get("target_wr")
                tpf = hyp.get("target_pf")
                if twr or tpf:
                    t1, t2 = st.columns(2)
                    if twr and wr:
                        hit = float(wr) >= float(twr)
                        t1.metric(
                            "WR vs Target",
                            pct(wr),
                            delta=f"{float(wr)-float(twr):+.1%}",
                            delta_color="normal" if hit else "inverse",
                        )
                    if tpf and pf_v:
                        hit = float(pf_v) >= float(tpf)
                        t2.metric(
                            "PF vs Target",
                            num(pf_v),
                            delta=f"{float(pf_v)-float(tpf):+.2f}",
                            delta_color="normal" if hit else "inverse",
                        )

                # Sample progress bar
                st.markdown(f"**Sample progress** ({n}/{min_n} trades)")
                st.progress(min(n/max(min_n,1), 1.0),
                            text=f"{n} / {min_n} minimum trades")

                if conf >= 60 and status == "observing":
                    st.success(
                        f"✅ **Ready for promotion.** "
                        f"Confidence = {conf:.0f}/100. "
                        "Use **🧬 Hypotheses** page to review evidence and promote."
                    )
                elif n < min_n:
                    remaining = min_n - n
                    st.warning(f"⏳ Need {remaining} more trades before observing.")
                elif conf < 60:
                    st.info(
                        f"Confidence = {conf:.0f}/100. "
                        "Need more evidence or targets to be met before promoting."
                    )

            # Evidence strength summary
            ev_df = get_evidence(sel_hyp)
            if not ev_df.empty:
                st.markdown("**Evidence summary**")
                supporting   = ev_df[ev_df["supports"] == 1]
                contradicting = ev_df[ev_df["supports"] == 0]
                ev1, ev2, ev3 = st.columns(3)
                ev1.metric("Total evidence", len(ev_df))
                ev2.metric("Supporting",     len(supporting),   delta=f"+{len(supporting)}")
                ev3.metric("Contradicting",  len(contradicting),
                           delta=f"-{len(contradicting)}" if contradicting.shape[0] else None,
                           delta_color="inverse" if contradicting.shape[0] else "off")

                avg_strength = ev_df["strength"].mean() if not ev_df.empty else 0
                st.caption(f"Average evidence strength: {avg_strength:.1f}/5 "
                           f"({'★' * round(avg_strength)}{'☆' * (5 - round(avg_strength))})")

                with st.expander("View evidence items", expanded=False):
                    for _, ev in ev_df.iterrows():
                        icon = "✅" if ev.get("supports") == 1 else "⛔"
                        st.markdown(
                            f"- {icon} **{ev['title']}** "
                            f"(`{ev['ev_type']}`, strength={ev.get('strength',3)}/5)"
                        )
            else:
                st.info("No evidence recorded yet. Add evidence in the **🧬 Hypotheses** page.")


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2 — VALIDATED EDGE HEALTH
# ══════════════════════════════════════════════════════════════════════════════
st.divider()
st.subheader("✅ Validated Edge Health")

if edges.empty:
    st.info("No validated edges yet.")
else:
    # Alert level summary
    alert_counts = edges["alert_level"].value_counts().to_dict() if "alert_level" in edges.columns else {}
    al1, al2, al3, al4 = st.columns(4)
    al1.metric("🟢 OK",       alert_counts.get("ok",      0))
    al2.metric("👁 Watch",    alert_counts.get("watch",   0))
    al3.metric("⚠️ Warn",    alert_counts.get("warn",    0))
    al4.metric("🚨 Degrade",  alert_counts.get("degrade", 0))

    # Edge score vs drift scatter
    if "edge_score" in edges.columns and "wr_drift" in edges.columns:
        plot_edges = edges.dropna(subset=["edge_score"])
        if not plot_edges.empty:
            fig_scatter = go.Figure()
            for alert, color in [("ok","#26a69a"),("watch","#ffd600"),
                                  ("warn","#fb8c00"),("degrade","#ef5350")]:
                sub = plot_edges[plot_edges["alert_level"] == alert] if "alert_level" in plot_edges.columns else plot_edges
                if not sub.empty:
                    fig_scatter.add_trace(go.Scatter(
                        x=sub["wr_drift"].fillna(0) * 100,
                        y=sub["edge_score"].fillna(0),
                        mode="markers+text",
                        name=alert.capitalize(),
                        marker=dict(color=color, size=12),
                        text=sub["edge_id"],
                        textposition="top center",
                        hovertemplate=(
                            "<b>%{text}</b><br>"
                            "WR Drift: %{x:.1f}%<br>"
                            "Edge Score: %{y:.0f}/100<extra></extra>"
                        ),
                    ))
            fig_scatter.add_vline(x=0, line_dash="dash", line_color="#546e7a")
            fig_scatter.add_vline(x=-5, line_dash="dot",  line_color="#ffd600",
                                   annotation_text="Watch")
            fig_scatter.add_vline(x=-10, line_dash="dot", line_color="#fb8c00",
                                   annotation_text="Warn")
            fig_scatter.update_layout(
                height=320,
                title="Edge Score vs WR Drift (right = improving, left = degrading)",
                xaxis=dict(title="WR Drift (%)", gridcolor="#1e2130"),
                yaxis=dict(title="Edge Score (0-100)", range=[0, 100], gridcolor="#1e2130"),
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                legend=dict(orientation="h", y=1.05),
                margin=dict(l=0, r=0, t=60, b=0),
            )
            st.plotly_chart(fig_scatter, use_container_width=True)

    # Edge table
    edge_cols = ["edge_id", "title", "edge_score", "alert_level",
                 "current_wr", "validated_wr", "wr_drift", "current_n"]
    edge_display_cols = [c for c in edge_cols if c in edges.columns]
    disp = edges[edge_display_cols].copy()

    if "current_wr" in disp.columns:
        disp["current_wr"] = disp["current_wr"].apply(lambda x: pct(x) if x else "—")
    if "validated_wr" in disp.columns:
        disp["validated_wr"] = disp["validated_wr"].apply(lambda x: pct(x) if x else "—")
    if "wr_drift" in disp.columns:
        disp["wr_drift"] = disp["wr_drift"].apply(
            lambda x: f"{x:+.1%}" if x is not None else "—"
        )

    disp.columns = [c.replace("_"," ").title() for c in disp.columns]
    st.dataframe(disp, use_container_width=True, hide_index=True)

st.divider()
st.caption(
    "For full evidence management and promotion workflow, use **🧬 Hypotheses** (page 15). "
    "For research ingestion, use **📥 Research Inbox** (page 17)."
)
