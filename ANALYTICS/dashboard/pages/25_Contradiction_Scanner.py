"""
25_Contradiction_Scanner.py — Reasoning Health Dashboard

4 tabs:
  Contradictions      — Conflicting relationship pairs in the knowledge graph
  Duplicate Detector  — Nodes with high title overlap
  Weak Evidence       — Relationships lacking evidence items
  Evidence Hierarchy  — Quality tier pyramid for all evidence
"""

import sys
import os

_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import pandas as pd
import knowledge_graph as kg
import graph_integrity as gi
import graph_pipeline as gp

st.set_page_config(
    page_title="Contradiction Scanner", page_icon="⚠️", layout="wide"
)

kg.run_migration()

st.title("⚠️ Contradiction Scanner")
st.caption(
    "Reasoning health checks — contradictions, duplicates, weak evidence, "
    "low sample alerts. Keeps the knowledge graph internally consistent."
)

# ── Generate full report once ──────────────────────────────────────────────────

@st.cache_data(ttl=300, show_spinner=False)
def _get_report():
    return gi.generate_integrity_report()

report = _get_report()

# ── Summary metrics ────────────────────────────────────────────────────────────

contradictions = report["checks"]["contradictions"]["items"]
duplicates     = report["checks"]["duplicate_concepts"]["items"]
weak_evidence  = kg.check_weak_evidence(min_evidence=1)
low_n_alerts   = kg.low_sample_alerts()

# Health score banner
health = report["health_score"]
health_color = "#26a69a" if health >= 90 else "#ffd600" if health >= 70 else "#ef5350"
st.markdown(
    f"<div style='background:{health_color}22;border:1px solid {health_color};"
    f"border-radius:8px;padding:10px 16px;margin-bottom:12px'>"
    f"<b>Graph Health: {health:.0f}/100</b> — {report['status'].upper()} | "
    f"Nodes: {report['graph_stats']['total_nodes']} | "
    f"Rels: {report['graph_stats']['total_rels']} | "
    f"Avg Confidence: {report['graph_stats']['avg_confidence']:.0f}/100"
    f"</div>",
    unsafe_allow_html=True,
)

if st.button("🔄 Refresh Report", key="refresh_report"):
    st.cache_data.clear()
    st.rerun()

c1, c2, c3, c4, c5 = st.columns(5)
c1.metric("Health Score", f"{health:.0f}/100")
c2.metric("Contradictions",   len(contradictions),
          delta=None if not contradictions else f"⚠️ {len(contradictions)} conflict(s)",
          delta_color="inverse")
c3.metric("Duplicate Concepts", len(duplicates))
c4.metric("Weak Relationships",   len(weak_evidence))
c5.metric("Low Sample Alerts",    len(low_n_alerts))

st.divider()

tab_contra, tab_dup, tab_weak, tab_hier = st.tabs([
    "🔴 Contradictions",
    "🔁 Duplicate Detector",
    "🔶 Weak Evidence",
    "🏛️ Evidence Hierarchy",
])

# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — Contradictions
# ══════════════════════════════════════════════════════════════════════════════

with tab_contra:
    st.subheader("Conflicting Relationship Pairs")
    st.markdown(
        "These pairs have **logically opposing relationships** between the same two nodes — "
        "e.g., A `supports` B and A `contradicts` B, or A `works_best_in` X and A `fails_in` X."
    )

    if not contradictions:
        st.success("✅ No contradictions detected. Knowledge graph is internally consistent.")
    else:
        for i, c in enumerate(contradictions):
            with st.expander(
                f"⚡ #{i+1} — **{c['from_title']}** ↔ **{c['to_title']}**",
                expanded=i == 0,
            ):
                col_a, col_b = st.columns(2)
                with col_a:
                    st.markdown(f"**Relationship A:** `{c['rel_a']}`  \nStrength: {c['str_a']:.0f}/100")
                with col_b:
                    st.markdown(f"**Relationship B:** `{c['rel_b']}`  \nStrength: {c['str_b']:.0f}/100")

                st.markdown(
                    f"**Resolution options:**\n"
                    f"1. Delete the weaker relationship (lower strength)\n"
                    f"2. Add context: maybe one is regime-specific and the other is not\n"
                    f"3. Keep both if the contradiction is intentional (documents a known paradox)"
                )

                # Show which rels these are so user can delete from page 24
                st.caption(
                    f"Node: {c['from_title']} → {c['to_title']}  |  "
                    f"Rel A type: {c['rel_a']}  |  Rel B type: {c['rel_b']}  \n"
                    "To resolve: go to 🕸️ Knowledge Graph → Build → delete the unwanted relationship."
                )

        st.divider()
        st.markdown("### Export Contradiction Report")
        df_contra = pd.DataFrame([{
            "From Node": c["from_title"],
            "To Node":   c["to_title"],
            "Relationship A": c["rel_a"],
            "Strength A": c["str_a"],
            "Relationship B": c["rel_b"],
            "Strength B": c["str_b"],
        } for c in contradictions])
        st.dataframe(df_contra, use_container_width=True, hide_index=True)

# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — Duplicate Detector
# ══════════════════════════════════════════════════════════════════════════════

with tab_dup:
    st.subheader("Potential Duplicate Nodes")
    st.markdown(
        "Nodes of the **same type** with high title token overlap (≥80%). "
        "These may represent the same concept under different names."
    )

    dup_threshold = st.slider("Overlap threshold (%)", 50, 100, 80, key="dup_thresh")
    duplicates = kg.detect_duplicate_nodes(threshold=float(dup_threshold))

    if not duplicates:
        st.success(f"✅ No duplicate nodes detected at {dup_threshold}% overlap threshold.")
    else:
        df_dups = pd.DataFrame([{
            "Node 1": d["node1_title"],
            "Node 2": d["node2_title"],
            "Type":   d["node_type"],
            "Overlap %": d["overlap_pct"],
            "node1_id": d["node1_id"],
            "node2_id": d["node2_id"],
        } for d in duplicates]).sort_values("Overlap %", ascending=False)

        for _, row in df_dups.iterrows():
            with st.expander(
                f"🔁 [{row['Type']}] **{row['Node 1']}** vs **{row['Node 2']}**  "
                f"— {row['Overlap %']:.0f}% overlap"
            ):
                col_a, col_b = st.columns(2)
                n1 = kg.get_node(row["node1_id"])
                n2 = kg.get_node(row["node2_id"])
                with col_a:
                    st.markdown(f"**{row['Node 1']}**")
                    if n1:
                        st.caption(n1.get("description","") or "_No description_")
                        st.caption(f"Confidence: {n1['confidence']:.0f}/100 | Tags: {n1.get('tags','—')}")
                with col_b:
                    st.markdown(f"**{row['Node 2']}**")
                    if n2:
                        st.caption(n2.get("description","") or "_No description_")
                        st.caption(f"Confidence: {n2['confidence']:.0f}/100 | Tags: {n2.get('tags','—')}")

                st.markdown(
                    "**Resolution:** Decide which node to keep. "
                    "Delete the duplicate from 🕸️ Knowledge Graph → Build → Node Management, "
                    "then re-point its relationships to the surviving node."
                )

# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — Weak Evidence
# ══════════════════════════════════════════════════════════════════════════════

with tab_weak:
    st.subheader("Relationships Without Evidence")
    st.markdown(
        "Relationships with **zero attached evidence items** are claims without proof. "
        "High-strength relationships with no evidence are the highest priority to address."
    )

    min_ev = st.number_input(
        "Flag relationships with fewer than N evidence items", min_value=1, max_value=10, value=1,
        key="weak_min_ev",
    )
    weak_evidence = kg.check_weak_evidence(min_evidence=int(min_ev))

    if not weak_evidence:
        st.success(f"✅ All relationships have at least {min_ev} evidence item(s).")
    else:
        # Priority score: high strength + no evidence = highest risk
        df_weak = pd.DataFrame([{
            "From": r["from_title"],
            "Relationship": r["rel_type"],
            "To": r["to_title"],
            "Strength": r["strength"],
            "Evidence Count": r["evidence_count"],
            "Rationale": (r.get("rationale","") or "")[:80],
            "Priority": round(r["strength"] * (1 - r["evidence_count"] * 0.1), 1),
        } for r in weak_evidence]).sort_values("Priority", ascending=False)

        st.caption(f"{len(weak_evidence)} relationships need evidence. Highest priority (high strength, no evidence) shown first.")
        st.dataframe(
            df_weak.drop(columns=["Priority"]),
            use_container_width=True,
            hide_index=True,
        )

        st.divider()
        st.markdown("### Why Evidence Matters")
        st.markdown("""
| Evidence Type | Quality Tier |
|---|---|
| `backtest` — In-sample historical validation | ⭐⭐ Medium |
| `trade_batch` — Live trade sample (N≥30) | ⭐⭐⭐ High |
| `research_paper` — Published research | ⭐⭐⭐ High |
| `hypothesis_result` — Formal hypothesis test | ⭐⭐⭐⭐ Highest |
| `manual_observation` — Expert judgment | ⭐ Low |
| `arena_item` — Learning Arena written item | ⭐⭐ Medium |
        """)

        st.markdown(
            "**Action:** For each high-priority relationship, add evidence via the Evidence Panel "
            "once you have a sufficient trade sample (N≥30) or research reference."
        )

        # Low-N alerts inline
        st.divider()
        st.subheader("Low Sample Alerts (N < 30)")
        alerts = kg.low_sample_alerts()
        if alerts:
            for a in alerts:
                st.warning(
                    f"⚠️ **{a['title']}** — N={a['actual_n']}  \n"
                    f"_{a['alert']}_  |  Status: `{a['status']}`"
                )
        else:
            st.success("✅ All hypotheses meet N≥30 threshold.")

# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — Evidence Hierarchy
# ══════════════════════════════════════════════════════════════════════════════

with tab_hier:
    st.subheader("Evidence Quality Hierarchy")
    st.markdown(
        "A **professional quantitative research process** treats evidence as a pyramid. "
        "Lower tiers can generate hypotheses; only upper tiers can validate an edge."
    )

    try:
        import plotly.graph_objects as go

        tiers = [
            ("Tier 5: Live Trade Batch (N≥30)", 5, "#26a69a",
             "30+ live trades under consistent conditions. Gold standard for edge validation."),
            ("Tier 4: Formal Hypothesis Test", 4, "#29b6f6",
             "Pre-registered hypothesis with explicit success criteria and statistical thresholds."),
            ("Tier 3: Published Research", 3, "#66bb6a",
             "Peer-reviewed or institutional research supporting the mechanism."),
            ("Tier 2: Backtest Evidence", 2, "#ffd600",
             "Historical simulation — useful for filtering, not sufficient for validation alone."),
            ("Tier 1: Manual Observation", 1, "#ef5350",
             "Expert judgment, chart pattern recognition, qualitative reasoning."),
        ]

        fig = go.Figure()
        for label, width_factor, color, desc in tiers:
            w = width_factor * 0.35
            y_pos = width_factor - 1
            fig.add_trace(go.Bar(
                x=[w],
                y=[label],
                orientation="h",
                marker_color=color,
                hovertext=desc,
                hoverinfo="text",
                showlegend=False,
                text=label,
                textposition="inside",
                insidetextanchor="middle",
                textfont=dict(size=11, color="#fff"),
            ))

        fig.update_layout(
            height=320,
            paper_bgcolor="#0e1117",
            plot_bgcolor="#0e1117",
            font_color="#e0e0e0",
            xaxis=dict(showgrid=False, zeroline=False, showticklabels=False, range=[0, 2.0]),
            yaxis=dict(showgrid=False, categoryorder="array",
                       categoryarray=[t[0] for t in tiers]),
            margin=dict(l=10, r=10, t=10, b=10),
        )
        st.plotly_chart(fig, use_container_width=True)

    except ImportError:
        for label, _, _, desc in tiers:
            st.markdown(f"- **{label}** — {desc}")

    st.divider()
    st.markdown("### Evidence Decision Rules")
    st.markdown("""
| Decision | Minimum Evidence Required |
|---|---|
| Generate hypothesis | Tier 1–2 (observation or backtest) |
| Promote to "Testing" | Tier 2 (backtest with N≥20) |
| Validate edge | Tier 3–5 (N≥30 live or published research) |
| Add to Principle Library | Tier 3–5 + documented failure cases |
| Add to Knowledge Graph as `validated_by` | Tier 4–5 only |
    """)

    st.divider()
    st.markdown("### Quantitative Mindset Standards")
    st.markdown("""
These standards come from the **Research Standards** page (📐) but apply directly to evidence quality:

1. **Statistical rigor** — Never claim an edge without N≥30 and win rate confidence interval
2. **Reproducibility** — Every validated relationship must have a source_ref (note path, URL, or trade ID range)
3. **Separation of concerns** — Backtest optimizes; live trading validates. Never promote backtest-only results as "validated"
4. **Contradiction documentation** — When a relationship contradicts a principle, document it rather than hiding it
5. **Confidence decay** — Relationships older than 90 days without new evidence should be flagged for review

> These are principles, not automation. All decisions remain human-supervised.
    """)
