"""
24_Knowledge_Graph.py — Knowledge Graph Explorer

4 tabs:
  Graph View      — Plotly circular-layout interactive graph
  Intelligence    — Query engine: which regimes break this? best sessions? etc.
  Pipeline        — Import Learning Arena → nodes → relationships → evidence
  Build           — Add nodes and relationships manually
"""

import sys
import os

_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import math
import knowledge_graph as kg
import graph_pipeline as gp
import graph_integrity as gi
import evidence_extractor as ee

st.set_page_config(page_title="Knowledge Graph", page_icon="🕸️", layout="wide")

# ── Init migration + seed ──────────────────────────────────────────────────────

@st.cache_resource(show_spinner=False)
def _init():
    kg.run_migration()
    stats = kg.get_graph_stats()
    if stats["total_nodes"] == 0:
        kg.seed_nodes_and_relationships()
    kg.sync_nodes_from_db()
    return True

_init()

# ── Header ─────────────────────────────────────────────────────────────────────

st.title("🕸️ Knowledge Graph Explorer")
st.caption("Relationships between strategies, regimes, principles, concepts, behaviors, and risk rules.")

stats = kg.get_graph_stats()
c1, c2, c3, c4, c5 = st.columns(5)
c1.metric("Nodes",        stats["total_nodes"])
c2.metric("Relationships",stats["total_rels"])
c3.metric("Avg Confidence", f"{stats['avg_confidence']:.0f}/100")
c4.metric("Strategies",   stats["type_counts"].get("strategy", 0))
c5.metric("Contradictions", len(kg.detect_contradictions()))

st.divider()

tab_graph, tab_intel, tab_pipeline, tab_build = st.tabs([
    "🗺️ Graph View", "🔍 Intelligence Queries",
    "⚙️ Pipeline", "🔧 Build Relationships",
])

# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — Graph View
# ══════════════════════════════════════════════════════════════════════════════

with tab_graph:
    col_ctrl, col_graph = st.columns([1, 3])

    with col_ctrl:
        st.subheader("Filters")

        all_node_types = kg.NODE_TYPES
        sel_types = st.multiselect(
            "Node types", all_node_types,
            default=["strategy","regime","session","concept","risk_rule","behavior"],
            key="graph_node_types",
        )

        all_rel_types = kg.REL_TYPES
        sel_rels = st.multiselect(
            "Relationship types", all_rel_types,
            default=["works_best_in","fails_in","contradicts","derived_from","supports"],
            key="graph_rel_types",
        )

        min_str = st.slider("Min strength", 0, 100, 50, key="graph_min_str")

        show_labels = st.checkbox("Show edge labels", value=False, key="graph_edge_labels")

        if st.button("🔄 Sync from DB", key="graph_sync"):
            result = kg.sync_nodes_from_db()
            st.success(f"Synced — principles: {result['principles']}, hypotheses: {result['hypotheses']}")
            st.rerun()

        if st.button("🌱 Re-seed defaults", key="graph_seed"):
            result = kg.seed_nodes_and_relationships()
            st.success(f"Seeded {result['nodes']} nodes, {result['relationships']} relationships")
            st.rerun()

        st.divider()
        st.caption("**Node type colours**")
        for nt, color in kg.NODE_COLORS.items():
            st.markdown(
                f"<span style='background:{color};color:#fff;border-radius:4px;"
                f"padding:2px 8px;font-size:0.75rem'>{nt}</span>",
                unsafe_allow_html=True,
            )

    with col_graph:
        graph_data = kg.get_graph_data(
            node_types=sel_types or None,
            rel_types=sel_rels or None,
            min_strength=float(min_str),
        )
        nodes = graph_data["nodes"]
        edges = graph_data["edges"]

        if not nodes:
            st.info("No nodes match the current filter. Adjust node types or reduce min strength.")
        else:
            try:
                import plotly.graph_objects as go

                # Circular layout — group nodes by type in arc segments
                type_groups: dict[str, list[dict]] = {}
                for n in nodes:
                    type_groups.setdefault(n["type"], []).append(n)

                pos: dict[str, tuple[float, float]] = {}
                n_types = len(type_groups)
                for i, (ntype, nlist) in enumerate(type_groups.items()):
                    base_angle = (2 * math.pi * i) / n_types
                    radius_base = 1.0 + (len(nlist) * 0.05)
                    for j, node in enumerate(nlist):
                        spread = (2 * math.pi / n_types) * 0.85
                        angle = base_angle + spread * (j - (len(nlist) - 1) / 2) / max(len(nlist), 1)
                        r = radius_base + (j % 3) * 0.25
                        pos[node["id"]] = (r * math.cos(angle), r * math.sin(angle))

                fig = go.Figure()

                # Draw edges
                for e in edges:
                    if e["from"] not in pos or e["to"] not in pos:
                        continue
                    x0, y0 = pos[e["from"]]
                    x1, y1 = pos[e["to"]]
                    mx, my = (x0 + x1) / 2, (y0 + y1) / 2
                    edge_color = e["color"]
                    fig.add_trace(go.Scatter(
                        x=[x0, x1, None], y=[y0, y1, None],
                        mode="lines",
                        line=dict(color=edge_color, width=max(1.0, e["strength"] / 35)),
                        hoverinfo="skip",
                        showlegend=False,
                    ))
                    if show_labels:
                        fig.add_annotation(
                            x=mx, y=my, text=e["label"],
                            showarrow=False,
                            font=dict(size=8, color=edge_color),
                            bgcolor="rgba(20,22,34,0.7)",
                        )

                # Draw nodes by type for legend grouping
                for ntype, nlist in type_groups.items():
                    x_vals, y_vals, labels, hover = [], [], [], []
                    for n in nlist:
                        if n["id"] not in pos:
                            continue
                        x, y = pos[n["id"]]
                        x_vals.append(x)
                        y_vals.append(y)
                        labels.append(n["label"])
                        hover.append(
                            f"<b>{n['label']}</b><br>"
                            f"Type: {n['type']}<br>"
                            f"Confidence: {n['confidence']:.0f}/100"
                        )

                    fig.add_trace(go.Scatter(
                        x=x_vals, y=y_vals,
                        mode="markers+text",
                        text=labels,
                        textposition="top center",
                        textfont=dict(size=9, color="#e0e0e0"),
                        marker=dict(
                            size=18,
                            color=kg.NODE_COLORS.get(ntype, "#90a4ae"),
                            line=dict(color="#1e2130", width=2),
                        ),
                        hovertext=hover,
                        hoverinfo="text",
                        name=ntype,
                        legendgroup=ntype,
                    ))

                fig.update_layout(
                    height=620,
                    paper_bgcolor="#0e1117",
                    plot_bgcolor="#0e1117",
                    font_color="#e0e0e0",
                    showlegend=True,
                    legend=dict(
                        bgcolor="#1e2130", bordercolor="#2d3147", borderwidth=1,
                        font=dict(size=10),
                    ),
                    xaxis=dict(showgrid=False, zeroline=False, showticklabels=False),
                    yaxis=dict(showgrid=False, zeroline=False, showticklabels=False),
                    margin=dict(l=20, r=20, t=20, b=20),
                )
                st.plotly_chart(fig, use_container_width=True)

            except ImportError:
                st.warning("Install plotly: `pip install plotly`")

        # Node detail panel
        st.subheader("Node Detail")
        all_node_list = kg.get_all_nodes()
        node_options = {n["title"]: n["node_id"] for n in all_node_list}
        selected_title = st.selectbox("Select node", ["—"] + list(node_options.keys()), key="graph_detail_node")
        if selected_title != "—":
            nid = node_options[selected_title]
            node = kg.get_node(nid)
            rels = kg.get_node_relationships(nid)
            if node:
                col_a, col_b = st.columns(2)
                with col_a:
                    st.markdown(f"**Type:** `{node['node_type']}`")
                    st.markdown(f"**Confidence:** {node['confidence']:.0f}/100")
                    st.markdown(f"**Tags:** {node.get('tags','—')}")
                    if node.get("description"):
                        st.markdown(f"**Description:** {node['description']}")
                with col_b:
                    if rels:
                        import pandas as pd
                        rel_rows = []
                        for r in rels:
                            direction = "→" if r["from_node_id"] == nid else "←"
                            other = r["to_title"] if r["from_node_id"] == nid else r["from_title"]
                            rel_rows.append({
                                "Dir": direction, "Relationship": r["rel_type"],
                                "Other Node": other, "Strength": f"{r['strength']:.0f}",
                            })
                        st.dataframe(pd.DataFrame(rel_rows), use_container_width=True, hide_index=True)
                    else:
                        st.info("No relationships found for this node.")

                if st.button("📝 Write to Obsidian", key=f"write_{nid}"):
                    path = kg.generate_node_note(nid)
                    if path:
                        st.success(f"Written: `{path}`")
                    else:
                        st.error("Failed to write note.")

# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — Intelligence Queries
# ══════════════════════════════════════════════════════════════════════════════

with tab_intel:
    import pandas as pd

    st.subheader("Research Intelligence Queries")
    st.caption("Ask strategic questions — the graph answers with relationship chains.")

    strategies = kg.get_all_nodes(node_type="strategy")
    strategy_map = {s["title"]: s["node_id"] for s in strategies}

    query_type = st.selectbox(
        "Query",
        [
            "Which regimes break a strategy's edge?",
            "Best sessions for a strategy",
            "What supports a strategy?",
            "Behavior impact on risk rules",
            "Concept dependency map",
            "Strategy × Regime compatibility matrix",
            "Low sample alerts (N < 30)",
        ],
        key="intel_query_type",
    )

    st.divider()

    if query_type == "Which regimes break a strategy's edge?":
        sel_strat = st.selectbox("Strategy", list(strategy_map.keys()), key="iq1_strat")
        if sel_strat:
            rows = kg.query_regime_breaks(strategy_map[sel_strat])
            if rows:
                df = pd.DataFrame([{
                    "Regime": r["regime_title"],
                    "Strength": f"{r['strength']:.0f}",
                    "Rationale": r["rationale"],
                } for r in rows])
                st.dataframe(df, use_container_width=True, hide_index=True)
            else:
                st.info("No 'fails_in' relationships found for this strategy.")

    elif query_type == "Best sessions for a strategy":
        sel_strat = st.selectbox("Strategy", list(strategy_map.keys()), key="iq2_strat")
        if sel_strat:
            rows = kg.query_best_sessions(strategy_map[sel_strat])
            if rows:
                for r in rows:
                    st.markdown(
                        f"✅ **{r['session_title']}** — strength {r['strength']:.0f}/100  \n"
                        f"_{r['rationale']}_"
                    )
            else:
                st.info("No session relationships found for this strategy.")

    elif query_type == "What supports a strategy?":
        sel_strat = st.selectbox("Strategy", list(strategy_map.keys()), key="iq3_strat")
        if sel_strat:
            rows = kg.query_supports_strategy(strategy_map[sel_strat])
            if rows:
                df = pd.DataFrame([{
                    "From": r["from_title"],
                    "Type": r["from_type"],
                    "Relationship": r["rel_type"],
                    "Strength": f"{r['strength']:.0f}",
                    "Rationale": r["rationale"],
                } for r in rows])
                st.dataframe(df, use_container_width=True, hide_index=True)
            else:
                st.info("No supporting relationships found.")

    elif query_type == "Behavior impact on risk rules":
        behaviors = kg.get_all_nodes(node_type="behavior")
        beh_map = {b["title"]: b["node_id"] for b in behaviors}
        sel_beh = st.selectbox("Behavior (or All)", ["— All —"] + list(beh_map.keys()), key="iq4_beh")
        bid = beh_map.get(sel_beh) if sel_beh != "— All —" else None
        rows = kg.query_behavior_impact(bid)
        if rows:
            df = pd.DataFrame([{
                "Behavior": r["behavior"],
                "Contradicts": r["rule_broken"],
                "Rule Type": r["rule_type"],
                "Strength": f"{r['strength']:.0f}",
                "Rationale": r["rationale"],
            } for r in rows])
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info("No contradictions found.")

    elif query_type == "Concept dependency map":
        concepts = kg.get_all_nodes(node_type="concept")
        concept_map = {c["title"]: c["node_id"] for c in concepts}
        sel_con = st.selectbox("Concept", list(concept_map.keys()), key="iq5_con")
        if sel_con:
            rows = kg.query_concept_dependencies(concept_map[sel_con])
            if rows:
                df = pd.DataFrame([{
                    "Depends On This": r["dependent"],
                    "Type": r["dep_type"],
                    "Relationship": r["rel_type"],
                    "Strength": f"{r['strength']:.0f}",
                } for r in rows])
                st.dataframe(df, use_container_width=True, hide_index=True)
            else:
                st.info("Nothing depends on this concept yet.")

    elif query_type == "Strategy × Regime compatibility matrix":
        matrix = kg.query_strategy_regime_matrix()
        if matrix:
            try:
                import plotly.graph_objects as go
                strategies_list = list(matrix.keys())
                regimes_list = list(next(iter(matrix.values())).keys()) if matrix else []
                z = [[matrix[s].get(r, 0.0) for r in regimes_list] for s in strategies_list]
                colors = []
                for row in z:
                    for val in row:
                        colors.append(val)

                fig = go.Figure(data=go.Heatmap(
                    z=z,
                    x=regimes_list,
                    y=strategies_list,
                    colorscale=[
                        [0.0,  "#ef5350"],   # negative = fails
                        [0.5,  "#1e2130"],   # zero = no data
                        [1.0,  "#26a69a"],   # positive = works
                    ],
                    zmid=0,
                    text=[[f"{v:+.0f}" for v in row] for row in z],
                    texttemplate="%{text}",
                    hovertemplate="<b>%{y}</b> in <b>%{x}</b><br>Score: %{z:.0f}<extra></extra>",
                ))
                fig.update_layout(
                    height=350,
                    paper_bgcolor="#0e1117", plot_bgcolor="#0e1117",
                    font_color="#e0e0e0",
                    xaxis=dict(tickfont=dict(size=10)),
                    yaxis=dict(tickfont=dict(size=10)),
                    margin=dict(l=20, r=20, t=10, b=20),
                )
                st.plotly_chart(fig, use_container_width=True)
                st.caption("Green = works best in regime | Red = fails in regime | Score = relationship strength (with sign)")
            except ImportError:
                df = pd.DataFrame(matrix).T
                st.dataframe(df, use_container_width=True)
        else:
            st.info("No strategies or regimes in graph yet.")

    elif query_type == "Low sample alerts (N < 30)":
        alerts = kg.low_sample_alerts()
        if alerts:
            for a in alerts:
                st.warning(
                    f"⚠️ **{a['title']}** (N={a['actual_n']}) — {a['alert']}  \n"
                    f"Status: `{a['status']}`"
                )
        else:
            st.success("✅ All hypotheses meet N≥30 threshold (or no hypotheses yet).")

# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — Build Relationships
# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — Pipeline
# ══════════════════════════════════════════════════════════════════════════════

with tab_pipeline:
    import pandas as pd

    st.subheader("Learning Arena → Knowledge Graph Pipeline")
    st.caption(
        "Imports 429 arena items and 1,305 atoms as research nodes + relationships + evidence. "
        "Run once, then use Incremental Sync for updates."
    )

    # ── Coverage summary ──────────────────────────────────────────────────────
    coverage = gp.get_pipeline_coverage()
    c1, c2, c3, c4, c5 = st.columns(5)
    c1.metric("Arena Items",   coverage["arena_total_items"])
    c2.metric("Nodes in Graph",coverage["nodes_in_graph"])
    c3.metric("Coverage",      f"{coverage['coverage_pct']:.0f}%")
    c4.metric("Pipeline Rels", coverage["pipeline_rels"])
    c5.metric("Evidence Links",coverage["evidence_links"])

    st.divider()

    col_run, col_inc = st.columns(2)

    with col_run:
        st.markdown("#### Full Pipeline Run")
        st.markdown(
            "Runs all steps: migrate → seed → import nodes → atom extraction → "
            "content extraction → confidence update → DB sync."
        )
        if st.button("🚀 Run Full Pipeline", key="pipe_run_full", type="primary"):
            with st.spinner("Running pipeline… this may take 30-60 seconds."):
                result = gp.run_full_pipeline()
            st.success("Pipeline complete.")
            st.json({
                "import_nodes": result["steps"]["import_nodes"],
                "atom_rels":    result["steps"]["atom_rels"],
                "graph_stats":  result["graph_stats"],
                "weak_evidence":result["weak_evidence_summary"],
            })

    with col_inc:
        st.markdown("#### Incremental Sync")
        st.markdown(
            "Only syncs new arena items and DB records (principles, hypotheses, edges). "
            "Fast — use after adding new Learning Arena items."
        )
        if st.button("🔄 Incremental Sync", key="pipe_inc"):
            with st.spinner("Syncing…"):
                import_r = gp.import_arena_items_as_nodes()
                sync_r   = kg.sync_nodes_from_db()
                conf_r   = gp.update_node_confidence_from_evidence()
            st.success(
                f"Created {import_r['created']} new nodes | "
                f"DB sync: principles {sync_r['principles']}, hypotheses {sync_r['hypotheses']} | "
                f"Confidence updated: {conf_r['nodes_updated']}"
            )

    st.divider()

    # ── Weak evidence warnings ────────────────────────────────────────────────
    st.subheader("Weak Evidence Warnings")
    weak = gp.get_weak_evidence_summary()
    wc1, wc2, wc3, wc4 = st.columns(4)
    wc1.metric("Total Warnings",  weak["total"])
    wc2.metric("High Severity",   weak["by_severity"]["high"],   delta_color="inverse")
    wc3.metric("Medium Severity", weak["by_severity"]["medium"])
    wc4.metric("Low Severity",    weak["by_severity"]["low"])

    severity_filter = st.selectbox(
        "Filter by severity", ["All", "high", "medium", "low"], key="pipe_sev_filter"
    )
    type_filter = st.selectbox(
        "Filter by risk type",
        ["All"] + list(weak["by_type"].keys()),
        key="pipe_type_filter",
    )

    warnings = weak["warnings"]
    if severity_filter != "All":
        warnings = [w for w in warnings if w["severity"] == severity_filter]
    if type_filter != "All":
        warnings = [w for w in warnings if w["risk_type"].startswith(type_filter)]

    if warnings:
        df_warn = pd.DataFrame([{
            "Severity": w["severity"],
            "Type":     w["risk_type"],
            "Node":     w["title"][:60],
            "Message":  w["message"][:80],
            "Action":   w["action"][:80],
        } for w in warnings[:200]])
        st.dataframe(df_warn, use_container_width=True, hide_index=True)
        st.caption(f"Showing {len(df_warn)} of {len(weak['warnings'])} warnings")
    else:
        st.success("No warnings match the current filter.")

    st.divider()

    # ── Top research nodes by relationship count ──────────────────────────────
    st.subheader("Research Node Coverage")
    node_stats = gp.get_item_relationship_stats()

    col_top, col_bot = st.columns(2)
    with col_top:
        st.markdown("**Top 15 — best connected**")
        df_top = pd.DataFrame([{
            "Title":   s["title"][:55],
            "Rels":    s["rel_count"],
            "Atoms":   s["atom_count"],
            "Conf":    f"{s['confidence']:.0f}",
        } for s in node_stats[:15]])
        st.dataframe(df_top, use_container_width=True, hide_index=True)

    with col_bot:
        st.markdown("**Bottom 15 — least connected**")
        df_bot = pd.DataFrame([{
            "Title":   s["title"][:55],
            "Rels":    s["rel_count"],
            "Atoms":   s["atom_count"],
            "Conf":    f"{s['confidence']:.0f}",
        } for s in sorted(node_stats, key=lambda x: x["rel_count"])[:15]])
        st.dataframe(df_bot, use_container_width=True, hide_index=True)

    st.divider()

    # ── Evidence pipeline — real trade performance ────────────────────────────
    st.subheader("Evidence Pipeline — Real Trade Performance")
    st.caption(
        "Links actual WR, PF, MaxDD, and N from the trades database to knowledge graph "
        "strategy/session/regime nodes. Creates `trade_batch` evidence_links with real metrics."
    )

    # Live performance summary
    try:
        perf_sum = ee.get_performance_summary(since_date="2025-01-01")
        strats = perf_sum.get("strategies", [])
        sessions = perf_sum.get("sessions", [])

        if strats:
            st.markdown("**Live Strategy Performance (2025+, N≥10)**")
            df_strats = pd.DataFrame([{
                "Strategy":  s["strategy"],
                "Symbol":    s["symbol"],
                "N":         s["n"],
                "WR":        f"{s['wr']:.1%}",
                "PF":        f"{s['profit_factor']:.2f}",
                "MaxDD":     f"${s['max_dd']:.0f}",
                "Expectancy": f"${s['expectancy']:.2f}",
                "Net P&L":   f"${s['net_pnl']:,.0f}",
            } for s in strats])
            st.dataframe(df_strats, use_container_width=True, hide_index=True)
        else:
            st.info("No strategy performance data available (min N=10 required).")

        if sessions:
            st.markdown("**QField Session Breakdown (2025+, N≥10)**")
            df_sess = pd.DataFrame([{
                "Session":    s["session"],
                "N":          s["n"],
                "WR":         f"{s['wr']:.1%}",
                "PF":         f"{s['profit_factor']:.2f}",
                "Expectancy": f"${s['expectancy']:.2f}",
                "Net P&L":    f"${s['net_pnl']:,.0f}",
            } for s in sessions])
            st.dataframe(df_sess, use_container_width=True, hide_index=True)

    except Exception as e:
        st.warning(f"Could not load performance summary: {e}")

    st.divider()
    ev_col1, ev_col2 = st.columns(2)

    with ev_col1:
        st.markdown("**Link Performance Evidence to Graph**")
        since_date = st.date_input("Since date", value=None, key="ev_since")
        since_str  = str(since_date) if since_date else "2025-01-01"
        min_n_ev   = st.number_input("Min trade count (N)", 10, 200, 30, key="ev_min_n")

        if st.button("📊 Link Performance Evidence", key="ev_link", type="primary"):
            with st.spinner("Extracting performance and creating evidence links…"):
                result = ee.link_performance_to_graph(
                    since_date=since_str, min_n=int(min_n_ev)
                )
            st.success(
                f"Done — Evidence links created: {result['evidence_created']} | "
                f"Relationships upserted: {result['rels_created_or_updated']}"
            )
            st.json({
                "strategy_records":   result["strategy_records"],
                "session_records":    result["session_records"],
                "regime_records":     result["regime_records"],
            })

    with ev_col2:
        st.markdown("**Generate Hypothesis Candidates**")
        st.caption(
            "Scans trade performance for session/strategy combinations that meet "
            "edge criteria. Returns candidates for human review before inserting."
        )
        min_n_hyp = st.number_input("Min trade count (N)", 10, 200, 30, key="hyp_min_n")

        if st.button("🔍 Preview Hypothesis Candidates", key="hyp_preview"):
            with st.spinner("Scanning trades…"):
                candidates = ee.auto_generate_hypotheses(
                    since_date="2025-01-01", min_n=int(min_n_hyp)
                )
            if candidates:
                st.info(f"Found **{len(candidates)}** hypothesis candidates:")
                for c in candidates:
                    st.markdown(
                        f"- **{c['title']}**  \n"
                        f"  N={c['actual_n']} | WR={c['actual_wr']:.1%} | "
                        f"PF={c['actual_pf']:.2f} | Status: `{c['status']}`"
                    )
                if st.button("➕ Insert All Candidates (human-reviewed)", key="hyp_insert"):
                    ins = ee.insert_hypothesis_candidates(candidates, dry_run=False)
                    st.success(f"Inserted {ins['inserted']} | Skipped {ins['skipped']} duplicates")
                    st.rerun()
            else:
                st.info("No hypothesis candidates meet the minimum criteria.")

# ══════════════════════════════════════════════════════════════════════════════

with tab_build:
    col_add_node, col_add_rel = st.columns(2)

    # ── Add Node ──────────────────────────────────────────────────────────────
    with col_add_node:
        st.subheader("Add Node")
        with st.form("add_node_form"):
            n_title = st.text_input("Title *", key="an_title")
            n_type  = st.selectbox("Node type *", kg.NODE_TYPES, key="an_type")
            n_desc  = st.text_area("Description", height=80, key="an_desc")
            n_tags  = st.text_input("Tags (comma-separated)", key="an_tags")
            n_conf  = st.slider("Confidence", 0, 100, 70, key="an_conf")

            submitted = st.form_submit_button("➕ Add Node")
            if submitted:
                if not n_title.strip():
                    st.error("Title is required.")
                else:
                    import uuid as _uuid
                    nid = f"{n_type[:4]}_{_uuid.uuid4().hex[:8]}"
                    kg.upsert_node(
                        node_id=nid,
                        node_type=n_type,
                        title=n_title.strip(),
                        description=n_desc.strip(),
                        tags=n_tags.strip(),
                        confidence=float(n_conf),
                    )
                    st.success(f"Node created: `{nid}`")
                    st.rerun()

    # ── Add Relationship ──────────────────────────────────────────────────────
    with col_add_rel:
        st.subheader("Add Relationship")
        all_nodes = kg.get_all_nodes()
        node_opts = {f"[{n['node_type']}] {n['title']}": n["node_id"] for n in all_nodes}

        with st.form("add_rel_form"):
            from_sel = st.selectbox("From node *", list(node_opts.keys()), key="ar_from")
            rel_type = st.selectbox("Relationship type *", kg.REL_TYPES, key="ar_rel")
            to_sel   = st.selectbox("To node *", list(node_opts.keys()), key="ar_to")
            strength = st.slider("Strength", 0, 100, 70, key="ar_str")
            rationale = st.text_area("Rationale", height=80, key="ar_rat")
            bidir    = st.checkbox("Bidirectional", value=False, key="ar_bidir")

            submitted = st.form_submit_button("🔗 Add Relationship")
            if submitted:
                from_id = node_opts[from_sel]
                to_id   = node_opts[to_sel]
                if from_id == to_id:
                    st.error("From and To nodes must be different.")
                else:
                    result = kg.add_relationship(
                        from_node_id=from_id,
                        to_node_id=to_id,
                        rel_type=rel_type,
                        strength=float(strength),
                        rationale=rationale.strip(),
                        created_by="user",
                        is_bidirectional=bidir,
                    )
                    if result:
                        st.success(f"Relationship added: `{result}`")
                    else:
                        st.warning("Relationship already exists (same from→to→type).")
                    st.rerun()

    st.divider()

    # ── Existing relationships ────────────────────────────────────────────────
    st.subheader("All Relationships")
    import pandas as pd
    all_rels = kg.get_all_relationships()
    if all_rels:
        df_rels = pd.DataFrame([{
            "From": r["from_title"],
            "Rel": r["rel_type"],
            "To": r["to_title"],
            "Str": f"{r['strength']:.0f}",
            "By": r.get("created_by","—"),
            "Rationale": (r.get("rationale","") or "")[:60],
            "rel_id": r["rel_id"],
        } for r in all_rels])

        sel_rel = st.dataframe(
            df_rels.drop(columns=["rel_id"]),
            use_container_width=True,
            hide_index=True,
            selection_mode="single-row",
            on_select="rerun",
            key="rels_table",
        )
        if sel_rel and sel_rel.selection and sel_rel.selection.rows:
            idx = sel_rel.selection.rows[0]
            rel_id_sel = df_rels.iloc[idx]["rel_id"]
            if st.button(f"🗑️ Delete selected relationship ({rel_id_sel[:12]}…)", key="del_rel"):
                kg.delete_relationship(rel_id_sel)
                st.success("Deleted.")
                st.rerun()
    else:
        st.info("No relationships yet. Use the form above or re-seed defaults.")

    st.divider()

    # ── Node management ───────────────────────────────────────────────────────
    st.subheader("Node Management")
    all_nodes_df = pd.DataFrame([{
        "Title": n["title"], "Type": n["node_type"],
        "Confidence": f"{n['confidence']:.0f}",
        "Tags": n.get("tags",""),
        "node_id": n["node_id"],
    } for n in all_nodes])

    if not all_nodes_df.empty:
        sel_node = st.dataframe(
            all_nodes_df.drop(columns=["node_id"]),
            use_container_width=True, hide_index=True,
            selection_mode="single-row", on_select="rerun",
            key="nodes_table",
        )
        if sel_node and sel_node.selection and sel_node.selection.rows:
            idx = sel_node.selection.rows[0]
            nid_sel = all_nodes_df.iloc[idx]["node_id"]
            col_obs, col_del = st.columns(2)
            with col_obs:
                if st.button("📝 Write to Obsidian", key="node_obs"):
                    path = kg.generate_node_note(nid_sel)
                    st.success(f"Written: `{path}`") if path else st.error("Failed.")
            with col_del:
                if st.button("🗑️ Delete node (+ its relationships)", key="node_del"):
                    kg.delete_node(nid_sel)
                    st.success("Deleted.")
                    st.rerun()
