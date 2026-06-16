"""
26_Risk_Principle_Matrix.py — Risk Intelligence Dashboard

4 tabs:
  Strategy × Regime Matrix    — Heatmap of regime compatibility per strategy
  Risk Rule Coverage          — Which strategies have each risk rule linked
  Behavior Loss Correlation   — Which behaviors cost the most (graph data)
  Edge Dependency Viewer      — What each validated edge depends on
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
import edge_stability as es

st.set_page_config(
    page_title="Risk Principle Matrix", page_icon="🛡️", layout="wide"
)

kg.run_migration()

st.title("🛡️ Risk Principle Matrix")
st.caption(
    "Strategic risk intelligence — regime compatibility, risk rule coverage, "
    "behavior impact, and edge dependency analysis."
)

# ── Header stats ───────────────────────────────────────────────────────────────

stats = kg.get_graph_stats()
strategies  = kg.get_all_nodes(node_type="strategy")
risk_rules  = kg.get_all_nodes(node_type="risk_rule")
behaviors   = kg.get_all_nodes(node_type="behavior")
edges_graph = kg.get_all_nodes(node_type="edge")

c1, c2, c3, c4 = st.columns(4)
c1.metric("Strategies",  len(strategies))
c2.metric("Risk Rules",  len(risk_rules))
c3.metric("Behaviors",   len(behaviors))
c4.metric("Validated Edges", len(edges_graph))

st.divider()

tab_matrix, tab_risk, tab_beh, tab_edge, tab_stab = st.tabs([
    "📊 Strategy × Regime",
    "🔒 Risk Rule Coverage",
    "🧠 Behavior Impact",
    "🔬 Edge Dependency",
    "🧱 Edge Stability",
])

# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — Strategy × Regime Compatibility Matrix
# ══════════════════════════════════════════════════════════════════════════════

with tab_matrix:
    st.subheader("Strategy × Regime Compatibility Matrix")
    st.markdown(
        "**Green** = strategy works best in this regime (positive score).  \n"
        "**Red** = strategy fails in this regime (negative score).  \n"
        "**Dark** = no relationship data."
    )

    matrix = kg.query_strategy_regime_matrix()

    if not matrix:
        st.info("No strategy or regime nodes found. Seed the graph from 🕸️ Knowledge Graph.")
    else:
        try:
            import plotly.graph_objects as go

            strategies_list = list(matrix.keys())
            regimes_list = list(next(iter(matrix.values())).keys()) if matrix else []
            z = [[matrix[s].get(r, 0.0) for r in regimes_list] for s in strategies_list]

            # Text annotations: show +/- with strength
            text_matrix = []
            for row in z:
                text_row = []
                for val in row:
                    if val > 0:
                        text_row.append(f"+{val:.0f}")
                    elif val < 0:
                        text_row.append(f"{val:.0f}")
                    else:
                        text_row.append("—")
                text_matrix.append(text_row)

            fig = go.Figure(data=go.Heatmap(
                z=z,
                x=regimes_list,
                y=strategies_list,
                colorscale=[
                    [0.0,  "#ef5350"],  # strong negative = fails
                    [0.45, "#b71c1c"],  # weak negative
                    [0.5,  "#1e2130"],  # zero
                    [0.55, "#1b5e20"],  # weak positive
                    [1.0,  "#26a69a"],  # strong positive = works
                ],
                zmid=0,
                zmin=-100,
                zmax=100,
                text=text_matrix,
                texttemplate="%{text}",
                textfont=dict(size=12, color="#ffffff"),
                hovertemplate=(
                    "<b>%{y}</b><br>Regime: <b>%{x}</b><br>"
                    "Score: %{z:.0f}<extra></extra>"
                ),
                colorbar=dict(
                    title="Score",
                    tickvals=[-100, -50, 0, 50, 100],
                    ticktext=["Fails", "Weak Fail", "No Data", "Works", "Best"],
                    bgcolor="#1e2130",
                    bordercolor="#2d3147",
                ),
            ))

            fig.update_layout(
                height=max(300, 80 * len(strategies_list)),
                paper_bgcolor="#0e1117",
                plot_bgcolor="#0e1117",
                font_color="#e0e0e0",
                xaxis=dict(tickfont=dict(size=11), side="top"),
                yaxis=dict(tickfont=dict(size=11)),
                margin=dict(l=20, r=20, t=40, b=20),
            )
            st.plotly_chart(fig, use_container_width=True)

        except ImportError:
            df_matrix = pd.DataFrame(matrix).T
            st.dataframe(df_matrix, use_container_width=True)

    st.divider()
    st.markdown("### Strategy Regime Details")
    if strategies:
        sel_strat = st.selectbox(
            "Select strategy for breakdown",
            [s["title"] for s in strategies],
            key="rpm_strat_detail",
        )
        strat_map = {s["title"]: s["node_id"] for s in strategies}
        if sel_strat:
            nid = strat_map[sel_strat]
            best = kg.query_best_sessions(nid)
            fails = kg.query_regime_breaks(nid)
            supports = kg.query_supports_strategy(nid)

            col_best, col_fail = st.columns(2)
            with col_best:
                st.markdown("**✅ Works best in (sessions)**")
                if best:
                    for r in best:
                        st.markdown(f"- {r['session_title']} — strength {r['strength']:.0f}")
                else:
                    st.caption("No session data")

            with col_fail:
                st.markdown("**❌ Fails in (regimes)**")
                if fails:
                    for r in fails:
                        st.markdown(f"- {r['regime_title']} — strength {r['strength']:.0f}")
                else:
                    st.caption("No failure data")

            st.markdown("**🔗 Supported by**")
            if supports:
                for r in supports:
                    icon = "✅" if r["rel_type"] in ("supports","validated_by") else "📌"
                    st.markdown(
                        f"{icon} [{r['from_type']}] **{r['from_title']}** "
                        f"— `{r['rel_type']}` (strength {r['strength']:.0f})"
                    )
            else:
                st.caption("No supporting relationships")

# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — Risk Rule Coverage
# ══════════════════════════════════════════════════════════════════════════════

with tab_risk:
    st.subheader("Risk Rule Coverage per Strategy")
    st.markdown(
        "Which risk rules are explicitly linked to each strategy? "
        "Unlinked strategies may be missing documented risk controls."
    )

    if not strategies or not risk_rules:
        st.info("No strategies or risk rules found in graph. Seed from 🕸️ Knowledge Graph.")
    else:
        all_rels = kg.get_all_relationships()
        risk_rel_types = {"linked_to_risk_model", "supports", "required_by"}

        coverage: dict[str, dict[str, bool]] = {}
        for s in strategies:
            coverage[s["title"]] = {}
            for rr in risk_rules:
                # Check if any relationship links this strategy to this risk rule
                linked = any(
                    (r["from_node_id"] == s["node_id"] and r["to_node_id"] == rr["node_id"] and r["rel_type"] in risk_rel_types)
                    or
                    (r["to_node_id"] == s["node_id"] and r["from_node_id"] == rr["node_id"] and r["rel_type"] in risk_rel_types)
                    for r in all_rels
                )
                coverage[s["title"]][rr["title"]] = linked

        # Build coverage dataframe
        df_cov = pd.DataFrame(coverage).T
        # Replace True/False with emoji
        df_display = df_cov.applymap(lambda v: "✅" if v else "—")

        st.dataframe(df_display, use_container_width=True)

        # Coverage score per strategy
        st.markdown("### Coverage Score")
        coverage_scores = []
        for strat_title, rules in coverage.items():
            n_linked = sum(1 for v in rules.values() if v)
            pct = (n_linked / len(risk_rules) * 100) if risk_rules else 0.0
            coverage_scores.append({
                "Strategy": strat_title,
                "Rules Linked": n_linked,
                "Total Rules": len(risk_rules),
                "Coverage %": f"{pct:.0f}%",
                "Gap": len(risk_rules) - n_linked,
            })

        df_scores = pd.DataFrame(coverage_scores).sort_values("Rules Linked", ascending=False)
        st.dataframe(df_scores, use_container_width=True, hide_index=True)

        # Alert: strategies with < 50% coverage
        uncovered = [row for row in coverage_scores if int(row["Coverage %"].rstrip("%")) < 50]
        if uncovered:
            st.warning(
                f"⚠️ {len(uncovered)} strategy/strategies have < 50% risk rule coverage: "
                + ", ".join(r["Strategy"] for r in uncovered)
            )

    st.divider()
    st.markdown("### Risk Rules Reference")
    if risk_rules:
        for rr in risk_rules:
            with st.expander(f"🔒 {rr['title']}"):
                st.markdown(rr.get("description","_No description_"))
                st.caption(f"Confidence: {rr['confidence']:.0f}/100 | Tags: {rr.get('tags','—')}")
                rels = kg.get_node_relationships(rr["node_id"])
                if rels:
                    st.markdown("**Linked to:**")
                    for r in rels:
                        direction = "→" if r["from_node_id"] == rr["node_id"] else "←"
                        other = r["to_title"] if r["from_node_id"] == rr["node_id"] else r["from_title"]
                        st.caption(f"{direction} [{r['rel_type']}] {other}")

# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — Behavior Impact
# ══════════════════════════════════════════════════════════════════════════════

with tab_beh:
    st.subheader("Behavior Impact on Risk Rules")
    st.markdown(
        "Each behavior (FOMO, Revenge Trading, etc.) has documented contradictions "
        "with specific risk rules. The higher the contradiction strength, the more dangerous "
        "the behavior is to the trading system."
    )

    behavior_impact = kg.query_behavior_impact()

    if not behavior_impact:
        st.info("No behavior-rule contradictions found in graph.")
    else:
        # Group by behavior
        by_behavior: dict[str, list[dict]] = {}
        for row in behavior_impact:
            by_behavior.setdefault(row["behavior"], []).append(row)

        try:
            import plotly.graph_objects as go

            beh_names  = list(by_behavior.keys())
            beh_scores = [
                sum(r["strength"] for r in rows) / len(rows)
                for rows in by_behavior.values()
            ]
            colors = ["#ef5350" if s >= 90 else "#ffa726" if s >= 75 else "#ffd600"
                      for s in beh_scores]

            fig = go.Figure(go.Bar(
                x=beh_names,
                y=beh_scores,
                marker_color=colors,
                text=[f"{s:.0f}" for s in beh_scores],
                textposition="outside",
                hovertemplate="<b>%{x}</b><br>Avg Contradiction Strength: %{y:.0f}/100<extra></extra>",
            ))
            fig.update_layout(
                height=300,
                paper_bgcolor="#0e1117",
                plot_bgcolor="#0e1117",
                font_color="#e0e0e0",
                xaxis=dict(tickfont=dict(size=11)),
                yaxis=dict(range=[0, 115], gridcolor="#2d3147"),
                margin=dict(l=20, r=20, t=20, b=20),
                showlegend=False,
            )
            st.plotly_chart(fig, use_container_width=True)

        except ImportError:
            for beh, rows in by_behavior.items():
                avg = sum(r["strength"] for r in rows) / len(rows)
                st.markdown(f"**{beh}** — avg contradiction strength: {avg:.0f}/100")

        st.divider()

        for beh, rows in by_behavior.items():
            with st.expander(f"🧠 {beh}", expanded=False):
                for r in rows:
                    strength_color = "#ef5350" if r["strength"] >= 90 else "#ffa726"
                    st.markdown(
                        f"<span style='color:{strength_color}'>⚡ **Contradicts:** {r['rule_broken']}</span>  \n"
                        f"Strength: {r['strength']:.0f}/100  \n_{r['rationale']}_",
                        unsafe_allow_html=True,
                    )
                    st.markdown("---")

    st.divider()
    st.markdown("### Behavior Prevention Checklist")
    st.markdown("""
Use this checklist before each trading session:

- [ ] Am I trading to recover from yesterday's loss? → **Revenge Trading** risk
- [ ] Am I increasing lot size because I'm "sure" about this trade? → **Overconfidence** risk
- [ ] Am I entering because I fear missing a move? → **FOMO** risk
- [ ] Am I holding a losing position because I've already lost time on it? → **Sunk Cost** risk
- [ ] Have I checked today's daily loss limit before opening MT5? → **All behaviors**

> If you answer YES to any of the first four — stop, step away for 15 minutes, then re-evaluate.
    """)

# ══════════════════════════════════════════════════════════════════════════════
# ── Strategy Coverage Depth (sidebar to all tabs) ─────────────────────────────

with st.expander("📊 Strategy Coverage Depth & Node Centrality", expanded=False):
    col_cov, col_cent = st.columns(2)

    with col_cov:
        st.markdown("**Strategy Coverage** — relationship counts and gaps")
        coverage = gi.get_strategy_coverage_depth()
        df_cov = pd.DataFrame([{
            "Strategy":   s["strategy"],
            "Rels":       s["total_rels"],
            "Coverage %": f"{min(100, s['total_rels'] * 5):.0f}%",
            "Gaps":       ", ".join(s["gaps"]) if s["gaps"] else "✅ None",
        } for s in coverage])
        st.dataframe(df_cov, use_container_width=True, hide_index=True)

    with col_cent:
        st.markdown("**Node Centrality** — most connected / influential nodes")
        centrality = gi.compute_node_centrality()[:15]
        df_cent = pd.DataFrame([{
            "Node":       n["title"][:45],
            "Type":       n["node_type"],
            "Centrality": n["centrality"],
            "Conf":       f"{n['confidence']:.0f}",
        } for n in centrality])
        st.dataframe(df_cent, use_container_width=True, hide_index=True)

    st.markdown("**Relationship Type Health**")
    rel_health = gi.get_relationship_type_health()
    df_rh = pd.DataFrame([{
        "Type":         r["rel_type"],
        "Count":        r["count"],
        "Avg Strength": f"{r['avg_strength']:.0f}",
        "Avg Evidence": f"{r['avg_evidence']:.1f}",
        "No Evidence":  r["no_evidence_count"],
    } for r in rel_health])
    st.dataframe(df_rh, use_container_width=True, hide_index=True)

st.divider()

# TAB 4 — Edge Dependency Viewer
# ══════════════════════════════════════════════════════════════════════════════

with tab_edge:
    st.subheader("Validated Edge Dependency Viewer")
    st.markdown(
        "What concepts, principles, and regimes does each validated edge depend on? "
        "Tracing dependencies reveals fragility — if a dependency fails, the edge may fail too."
    )

    if not edges_graph:
        st.info(
            "No edge nodes in the knowledge graph yet.  \n"
            "Edges are synced from the `validated_edges` database table via the Sync button on page 24. "
            "Promote hypotheses to validated edges first (page 20 — Validation Tracker)."
        )
    else:
        edge_map = {e["title"]: e["node_id"] for e in edges_graph}
        sel_edge = st.selectbox("Select edge", list(edge_map.keys()), key="edge_dep_sel")
        if sel_edge:
            eid = edge_map[sel_edge]
            edge_node = kg.get_node(eid)
            rels = kg.get_node_relationships(eid)

            if edge_node:
                c1, c2 = st.columns(2)
                c1.metric("Confidence", f"{edge_node['confidence']:.0f}/100")
                c2.metric("Relationships", len(rels))
                if edge_node.get("description"):
                    st.caption(edge_node["description"])

            if rels:
                deps = [r for r in rels if r["to_node_id"] == eid]
                outs = [r for r in rels if r["from_node_id"] == eid]

                if deps:
                    st.markdown("#### Dependencies (what this edge depends on)")
                    for r in sorted(deps, key=lambda x: -x["strength"]):
                        icon = {
                            "derived_from":   "🔩",
                            "validated_by":   "✅",
                            "supports":       "💪",
                            "required_by":    "⚠️",
                            "works_best_in":  "✅",
                            "linked_to_regime":"📊",
                        }.get(r["rel_type"], "📌")
                        fragility = "🔴 High" if r["strength"] > 80 else "🟡 Medium" if r["strength"] > 50 else "🟢 Low"
                        st.markdown(
                            f"{icon} [{r['from_type']}] **{r['from_title']}**  \n"
                            f"Relationship: `{r['rel_type']}` | Strength: {r['strength']:.0f}/100 | "
                            f"Fragility if lost: {fragility}  \n"
                            f"_{r.get('rationale','')}_"
                        )

                if outs:
                    st.markdown("#### Downstream (what relies on this edge)")
                    for r in outs:
                        st.markdown(
                            f"📌 [{r['to_type']}] **{r['to_title']}** — `{r['rel_type']}`"
                        )
            else:
                st.info("No relationships found for this edge. Add them from 🕸️ Knowledge Graph → Build.")

    st.divider()
    st.markdown("### Research → Edge Traceability")
    st.markdown(
        "The full traceability chain runs:  \n"
        "**Learning Arena** → Research Inbox → Research Library → **Hypothesis** → "
        "Validation Tracker → **Validated Edge** → Knowledge Graph  \n\n"
        "View the full chain on **🔬 Research Pipeline** (page 21)."
    )

    # Try to show hypothesis → edge links from the DB
    try:
        import sqlite3
        from pathlib import Path
        db_path = Path(_ROOT) / "DATA" / "processed" / "trades.sqlite"
        con = sqlite3.connect(db_path)
        con.row_factory = sqlite3.Row
        rows = con.execute(
            """SELECT ve.edge_id, ve.hyp_id, ve.edge_score, ve.alert_level,
                      h.title AS hyp_title, h.status AS hyp_status,
                      h.actual_n, h.confidence_score
               FROM validated_edges ve
               LEFT JOIN hypotheses h ON h.hyp_id = ve.hyp_id
               ORDER BY ve.edge_score DESC"""
        ).fetchall()
        con.close()

        if rows:
            df_edges = pd.DataFrame([dict(r) for r in rows])
            st.dataframe(df_edges, use_container_width=True, hide_index=True)
        else:
            st.info("No validated edges in database yet.")
    except Exception:
        st.caption("_validated_edges table not available or empty._")

# ══════════════════════════════════════════════════════════════════════════════
# TAB 5 — Edge Stability Analysis
# ══════════════════════════════════════════════════════════════════════════════

with tab_stab:
    st.subheader("🧱 Edge Stability & Fragility Analysis")
    st.markdown(
        "Measures how robust each validated relationship is to out-of-sample conditions.  \n"
        "**Stability 100** = evidence is consistent across all contexts.  \n"
        "**Stability < 70** = fragile — evidence varies by year, session, or regime."
    )

    # Apply migration and run analysis button
    col_run1, col_run2 = st.columns([3, 1])
    with col_run2:
        if st.button("🔄 Run Stability Analysis", key="run_stab"):
            with st.spinner("Computing stability metrics for all relationships..."):
                es.apply_stability_migration()
                stab_result = es.run_stability_analysis()
            st.success(
                f"Updated {stab_result['updated']} relationships. "
                f"Avg stability: {stab_result['avg_stability_score']}"
            )
            st.rerun()

    # Load report
    report = es.get_stability_report()

    if "error" in report:
        st.warning(
            "Stability columns not yet applied. Click **🔄 Run Stability Analysis** to initialize."
        )
    else:
        avgs = report.get("averages", {})
        dd   = report.get("dd_sensitivity", {})
        tc   = report.get("temporal_consistency", {})
        vstatus = report.get("validation_status_distribution", {})

        # ── Metric summary row ────────────────────────────────────────────────
        m1, m2, m3, m4, m5 = st.columns(5)
        m1.metric("Avg Stability", f"{avgs.get('stability', 0):.0f}/100")
        m2.metric("Avg Fragility", f"{avgs.get('fragility', 0):.0f}/100",
                  help="CoV of confidence scores across evidence links. 0=robust, 100=fragile.")
        m3.metric("Regime Dependency", f"{avgs.get('regime_dependency', 0):.2f}",
                  help="0=works across all regimes, 1=regime-locked")
        m4.metric("Session Dependency", f"{avgs.get('session_dependency', 0):.2f}",
                  help="0=works across all sessions, 1=session-locked")
        m5.metric("QField Temporal", f"{tc.get('QField', 50):.0f}/100",
                  help="Consistency of annual net PnL across years")

        st.divider()

        # ── DD Sensitivity ────────────────────────────────────────────────────
        st.markdown("### Drawdown Sensitivity — QField")
        dd_qfield = dd.get("QField", {})
        if dd_qfield and dd_qfield.get("dd_sensitivity_score") is not None:
            ddc1, ddc2, ddc3, ddc4 = st.columns(4)
            ddc1.metric("WR Normal Periods", f"{dd_qfield.get('wr_normal', 0):.1%}",
                        help=f"N={dd_qfield.get('n_normal_trades', 0)} trades outside 5%+ drawdown")
            ddc2.metric("WR in Drawdown", f"{dd_qfield.get('wr_high_dd', 0):.1%}",
                        help=f"N={dd_qfield.get('n_high_dd_trades', 0)} trades inside 5%+ drawdown")
            ddc3.metric("DD Sensitivity Score", f"{dd_qfield.get('dd_sensitivity_score', 0):.3f}",
                        delta=None,
                        help="1.0=no change, <0.85=sensitive, <0.6=highly sensitive")
            sens = dd_qfield.get("interpretation", "unknown")
            ddc4.metric("Interpretation", sens.title())

            if dd_qfield.get("dd_sensitivity_score", 1.0) < 0.6:
                st.error(
                    "⚠️ **High DD Sensitivity** — WR drops significantly during drawdown periods. "
                    "This validates the Max Drawdown Cap rule: reduce lot size or stop trading when in drawdown."
                )
            elif dd_qfield.get("dd_sensitivity_score", 1.0) < 0.85:
                st.warning(
                    "🟡 **Moderate DD Sensitivity** — Some WR degradation during drawdown. Monitor closely."
                )
            else:
                st.success("✅ DD-robust — Win rate is stable during drawdown periods.")
        else:
            st.info("No DD sensitivity data. Run analysis first.")

        st.divider()

        # ── Fragile Relationships ─────────────────────────────────────────────
        st.markdown("### Fragile Relationships (Stability < 80)")
        fragile = es.get_fragile_relationships(max_stability=80.0)

        if fragile:
            df_frag = pd.DataFrame([{
                "From":        r["from_title"][:40],
                "Rel Type":    r["rel_type"],
                "To":          r["to_title"][:40],
                "Stability":   r["stability_score"],
                "Fragility":   r.get("fragility_score"),
                "Status":      r.get("validation_status", "—"),
                "N":           r.get("computed_n", 0),
                "WR":          f"{r['computed_wr']:.1%}" if r.get("computed_wr") else "—",
                "PF":          f"{r['computed_pf']:.2f}" if r.get("computed_pf") else "—",
            } for r in fragile])
            st.dataframe(
                df_frag.style.background_gradient(subset=["Stability"], cmap="RdYlGn", vmin=0, vmax=100),
                use_container_width=True, hide_index=True,
            )
            st.caption(
                f"**{len(fragile)} fragile relationships** — high fragility means evidence confidence "
                "varies significantly across years or sessions. These edges need more consistent evidence."
            )
        else:
            st.success("✅ No fragile relationships detected (all stability ≥ 80).")

        st.divider()

        # ── Validation Status Distribution ─────────────────────────────────────
        st.markdown("### Relationship Validation Status")
        col_vs, col_ms = st.columns([1, 2])

        with col_vs:
            total_rels = sum(vstatus.values())
            for status, count in sorted(vstatus.items(), key=lambda x: -x[1]):
                icon = {"validated": "✅", "observing": "👁️", "testing": "🧪", "unvalidated": "⬜"}.get(status, "—")
                pct = count / total_rels * 100 if total_rels else 0
                st.markdown(f"{icon} **{status.title()}**: {count} ({pct:.0f}%)")
            if not vstatus:
                st.info("Run analysis to compute validation status.")

        with col_ms:
            st.markdown("**Most Stable Relationships (top 10)**")
            most_stable = report.get("most_stable", [])[:10]
            if most_stable:
                df_ms = pd.DataFrame([{
                    "From":     r["from_title"][:35],
                    "→ To":     r["to_title"][:35],
                    "Type":     r["rel_type"],
                    "Stab":     r["stability_score"],
                    "N":        r.get("computed_n", 0),
                    "Status":   r.get("validation_status", "—"),
                } for r in most_stable])
                st.dataframe(df_ms, use_container_width=True, hide_index=True)
            else:
                st.info("No stability data yet. Run analysis first.")
