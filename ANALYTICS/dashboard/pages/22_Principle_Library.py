"""
22_Principle_Library.py — Mindset & Principles Library

Browse, search, and manage quantitative thinking principles.
Tabs: 📚 Library | 🧠 Mental Models | ⚠️ Danger Flags | ➕ Add Principle
"""

import sys, os, json
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import plotly.express as px
import pandas as pd

from utils import C_WIN, C_LOSS, C_PRIMARY
from mindset_tracker import (
    run_migration,
    MINDSET_TYPES, MINDSET_COLORS, MINDSET_TO_CATEGORY,
    OBSIDIAN_CATEGORIES, DANGER_FLAGS, STATUS_COLORS,
    get_principles, get_principle, get_sessions,
    create_principle, update_principle, record_session,
    detect_danger_flags, get_danger_summary,
    compute_quality_score, compute_confidence_score,
    get_principle_summary, write_principle_note,
    seed_additional_principles,
)
import obsidian_sync as obs

st.set_page_config(
    page_title="Principle Library — QTrade OS",
    page_icon="📚",
    layout="wide",
)

run_migration()

# ── Header ────────────────────────────────────────────────────────────────────
st.title("📚 Principle Library")
st.caption(
    "Quantitative thinking frameworks, trading principles, risk philosophy, "
    "and engineering standards. Not knowledge about markets — knowledge about "
    "**how to think** about markets."
)

summary = get_principle_summary()

h1, h2, h3, h4, h5, h6 = st.columns(6)
h1.metric("📚 Total Principles",   summary.get("total",              0))
h2.metric("✅ Applied",            summary.get("applied_total",       0), help="Total times any principle was logged as applied")
h3.metric("⚠️ Violations",        summary.get("violations_total",    0), delta_color="inverse", delta=None if not summary.get("violations_total") else f"-{summary['violations_total']}")
h4.metric("🎯 Avg Quality",        f"{summary.get('avg_quality',0):.0f}/100")
h5.metric("🔒 Avg Confidence",     f"{summary.get('avg_confidence',0):.0f}/100")
h6.metric("⚠️ Flagged",           summary.get("principles_with_flags", 0), help="Principles that contain danger flag warnings")

st.divider()

tab_lib, tab_models, tab_danger, tab_add, tab_sync = st.tabs([
    "📚 Library", "🧠 Mental Models", "⚠️ Danger Flags", "➕ Add Principle", "⚡ Sync & Expand"
])

# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — PRINCIPLE LIBRARY
# ══════════════════════════════════════════════════════════════════════════════
with tab_lib:
    f1, f2, f3, f4 = st.columns([3, 2, 2, 1])
    search_q     = f1.text_input("🔍 Search", placeholder="Title, concept, application…", key="lib_search")
    filter_type  = f2.selectbox(
        "Mindset type",
        ["All"] + list(MINDSET_TYPES.keys()),
        format_func=lambda x: MINDSET_TYPES.get(x, x) if x != "All" else "All types",
        key="lib_type",
    )
    filter_cat   = f3.selectbox(
        "Category",
        ["All"] + OBSIDIAN_CATEGORIES,
        key="lib_cat",
    )
    show_archived = f4.checkbox("Archived", key="lib_archived")

    df = get_principles(
        mindset_type=None if filter_type == "All" else filter_type,
        category    =None if filter_cat  == "All" else filter_cat,
        status      ="archived" if show_archived else "active",
    )

    if search_q and not df.empty:
        q = search_q.lower()
        mask = (
            df["title"].str.lower().str.contains(q, na=False) |
            df["concept"].str.lower().str.contains(q, na=False) |
            df["practical_applications"].str.lower().str.contains(q, na=False)
        )
        df = df[mask]

    st.caption(f"**{len(df)}** principles")

    if df.empty:
        st.info("No principles match the current filter.")
    else:
        # Summary bar chart
        if len(df) >= 3:
            type_counts = df["mindset_type"].value_counts()
            fig_bar = go.Figure(go.Bar(
                x=[MINDSET_TYPES.get(t, t) for t in type_counts.index],
                y=type_counts.values,
                marker_color=[MINDSET_COLORS.get(t, "#546e7a") for t in type_counts.index],
                text=type_counts.values, textposition="auto",
            ))
            fig_bar.update_layout(
                height=160, showlegend=False,
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0, r=0, t=10, b=0),
                xaxis=dict(gridcolor="#1e2130", tickfont=dict(size=10)),
                yaxis=dict(gridcolor="#1e2130"),
            )
            st.plotly_chart(fig_bar, use_container_width=True)

        # Card grid — 3 per row
        items = df.to_dict("records")
        for row_start in range(0, len(items), 3):
            row_items = items[row_start:row_start + 3]
            cols      = st.columns(3)
            for ci, p in enumerate(row_items):
                mc     = MINDSET_COLORS.get(p.get("mindset_type",""), "#546e7a")
                ml     = MINDSET_TYPES.get(p.get("mindset_type",""), "")
                flags  = json.loads(p.get("danger_flags") or "[]")
                flag_html = "".join(
                    f"<span style='background:#2d1a0f;color:#fb8c00;"
                    f"border-radius:4px;padding:1px 6px;font-size:0.68rem;"
                    f"margin-right:4px'>{DANGER_FLAGS.get(f,f)}</span>"
                    for f in flags
                )
                qs  = p.get("quality_score", 0)
                cs  = p.get("confidence_score", 0)
                qs_color = C_WIN if qs >= 80 else (C_PRIMARY if qs >= 60 else C_LOSS)

                with cols[ci]:
                    st.markdown(
                        f"<div style='border:1px solid {mc};border-radius:8px;"
                        f"padding:12px;margin-bottom:8px;background:#0e1117'>"
                        f"<div style='display:flex;justify-content:space-between;"
                        f"align-items:flex-start;margin-bottom:4px'>"
                        f"<span style='font-size:0.68rem;color:{mc}'>{ml}</span>"
                        f"<span style='font-size:0.72rem;color:{qs_color}'>Q:{qs:.0f}</span>"
                        f"</div>"
                        f"<div style='font-weight:600;font-size:0.9rem;margin-bottom:6px'>"
                        f"{p['title'][:60]}</div>"
                        f"<div style='font-size:0.75rem;color:#8892b0'>"
                        f"{str(p.get('concept',''))[:120]}…</div>"
                        f"{'<div style=margin-top:6px>' + flag_html + '</div>' if flags else ''}"
                        f"</div>",
                        unsafe_allow_html=True,
                    )
                    if st.button("View", key=f"view_{p['principle_id']}"):
                        st.session_state["lib_sel"] = p["principle_id"]

        # ── Detail panel ──────────────────────────────────────────────────────
        sel_pid = st.session_state.get("lib_sel")
        if sel_pid:
            p = get_principle(sel_pid)
            if p:
                st.divider()
                _mc = MINDSET_COLORS.get(p.get("mindset_type",""), "#546e7a")
                _ml = MINDSET_TYPES.get(p.get("mindset_type",""), "")
                _qs = p.get("quality_score", 0)
                _cs = p.get("confidence_score", 0)
                _flags = json.loads(p.get("danger_flags") or "[]")

                st.markdown(
                    f"## {p['title']}  "
                    f"<span style='color:{_mc};font-size:0.9rem'>[{_ml}]</span>",
                    unsafe_allow_html=True,
                )

                if _flags:
                    flag_labels = [DANGER_FLAGS.get(f, f) for f in _flags]
                    st.error(f"⚠️ **Danger flags detected:** {', '.join(flag_labels)}")

                pm1, pm2, pm3, pm4, pm5 = st.columns(5)
                pm1.metric("Quality",     f"{_qs:.0f}/100")
                pm2.metric("Confidence",  f"{_cs:.0f}/100")
                pm3.metric("Applied",     p.get("applied_count", 0))
                pm4.metric("Violations",  p.get("violation_count", 0))
                pm5.metric("Reviews",     p.get("review_count", 0))

                d1, d2, d3 = st.tabs(["📖 Content", "🛠 Actions", "📜 Log"])

                with d1:
                    def _jl(v):
                        try:
                            return json.loads(v or "[]")
                        except Exception:
                            return []

                    if p.get("concept"):
                        st.markdown("**Concept**")
                        st.markdown(p["concept"])

                    if p.get("why_it_matters"):
                        st.markdown("**Why It Matters**")
                        st.markdown(p["why_it_matters"])

                    fc = _jl(p.get("failure_cases"))
                    if fc:
                        st.markdown("**Failure Cases**")
                        for item in fc:
                            st.markdown(f"- ❌ {item}")

                    apps = _jl(p.get("practical_applications"))
                    if apps:
                        st.markdown("**Practical Applications**")
                        for item in apps:
                            st.markdown(f"- ✅ {item}")

                    strats = _jl(p.get("related_strategies"))
                    rules  = _jl(p.get("related_risk_rules"))
                    sess   = _jl(p.get("related_sessions"))
                    if strats or rules or sess:
                        ca, cb, cc = st.columns(3)
                        if strats:
                            ca.markdown("**Related Strategies**")
                            for s in strats:
                                ca.markdown(f"- {s}")
                        if rules:
                            cb.markdown("**Risk Rules**")
                            for r in rules:
                                cb.markdown(f"- {r}")
                        if sess:
                            cc.markdown("**Sessions / Regimes**")
                            for s in sess:
                                cc.markdown(f"- {s}")

                    checklist = _jl(p.get("implementation_checklist"))
                    if checklist:
                        st.markdown("**Implementation Checklist**")
                        for item in checklist:
                            st.markdown(f"- [ ] {item}")

                    if p.get("source_ref"):
                        st.caption(f"Source: {p['source_ref']}")

                with d2:
                    st.markdown("**Log an interaction**")
                    with st.form(f"sess_{sel_pid}"):
                        s1, s2 = st.columns(2)
                        sess_type = s1.selectbox(
                            "Type",
                            ["review", "apply", "violation", "note"],
                            format_func=lambda x: {
                                "review": "📖 Review",
                                "apply":  "✅ Applied",
                                "violation": "❌ Violated",
                                "note":   "📝 Note",
                            }.get(x, x),
                        )
                        trade_ctx = s2.text_input("Trade context (optional)")
                        sess_note = st.text_area("Notes", height=80)
                        if st.form_submit_button("Log", type="primary"):
                            ok = record_session(sel_pid, sess_type, sess_note, trade_ctx)
                            if ok:
                                st.success(f"Logged {sess_type}.")
                            else:
                                st.error("Failed to log session.")
                            st.rerun()

                    st.divider()
                    st.markdown("**Write to Obsidian vault**")
                    if st.button("📝 Write Note to Vault", key=f"write_{sel_pid}"):
                        path = write_principle_note(sel_pid)
                        if path:
                            st.success(f"Written to: `{path}`")
                        else:
                            st.error("Failed to write note.")

                with d3:
                    sessions = get_sessions(sel_pid)
                    if sessions.empty:
                        st.info("No sessions logged yet.")
                    else:
                        for _, row in sessions.iterrows():
                            icon = {"review":"📖","apply":"✅","violation":"❌","note":"📝"}.get(row["session_type"],"•")
                            st.markdown(
                                f"**{icon} {row['session_type'].title()}** — "
                                f"{str(row.get('created_at',''))[:16]}  \n"
                                f"{row.get('notes','') or ''}"
                                + (f"  ·  *{row['trade_context']}*" if row.get("trade_context") else "")
                            )


# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — MENTAL MODEL EXPLORER
# ══════════════════════════════════════════════════════════════════════════════
with tab_models:
    st.subheader("🧠 Mental Model Explorer")
    st.caption(
        "Quantitative mindset frameworks and decision principles — "
        "the cognitive tools behind professional research thinking."
    )

    model_types = ["quantitative_mindset", "decision_framework"]
    df_models = get_principles(status="active")
    if not df_models.empty:
        df_models = df_models[df_models["mindset_type"].isin(model_types)]

    if df_models.empty:
        st.info("No mental models or decision frameworks yet.")
    else:
        # Quality scatter: quality vs confidence
        fig_scatter = go.Figure()
        for mtype in model_types:
            sub = df_models[df_models["mindset_type"] == mtype]
            if not sub.empty:
                fig_scatter.add_trace(go.Scatter(
                    x=sub["confidence_score"].fillna(0),
                    y=sub["quality_score"].fillna(0),
                    mode="markers+text",
                    name=MINDSET_TYPES.get(mtype, mtype),
                    marker=dict(color=MINDSET_COLORS.get(mtype, "#546e7a"), size=12),
                    text=sub["title"].str[:30],
                    textposition="top center",
                    textfont=dict(size=9),
                    hovertemplate="<b>%{text}</b><br>Quality: %{y:.0f}<br>Confidence: %{x:.0f}<extra></extra>",
                ))
        fig_scatter.add_hline(y=80, line_dash="dash", line_color="#26a69a",
                              annotation_text="High quality threshold")
        fig_scatter.add_vline(x=60, line_dash="dash", line_color="#ffd600",
                              annotation_text="Confidence threshold")
        fig_scatter.update_layout(
            height=300, title="Quality vs Confidence: Mental Models",
            xaxis=dict(title="Confidence Score", range=[0,100], gridcolor="#1e2130"),
            yaxis=dict(title="Quality Score", range=[0,100], gridcolor="#1e2130"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            legend=dict(orientation="h", y=1.05),
            margin=dict(l=0, r=0, t=60, b=0),
        )
        st.plotly_chart(fig_scatter, use_container_width=True)

        st.divider()

        # Accordion view of each mental model
        for _, p in df_models.iterrows():
            _mc = MINDSET_COLORS.get(p.get("mindset_type",""), "#546e7a")
            _qs = p.get("quality_score", 0)
            _cs = p.get("confidence_score", 0)
            qs_color = C_WIN if _qs >= 80 else (C_PRIMARY if _qs >= 60 else C_LOSS)

            with st.expander(
                f"**{p['title']}**   Q:{_qs:.0f}  C:{_cs:.0f}",
                expanded=False,
            ):
                st.markdown(f"*{p.get('concept','')}*")

                apps = []
                try:
                    apps = json.loads(p.get("practical_applications") or "[]")
                except Exception:
                    pass
                if apps:
                    st.markdown("**Apply:**")
                    for a in apps[:3]:
                        st.markdown(f"  - {a}")

                checklist = []
                try:
                    checklist = json.loads(p.get("implementation_checklist") or "[]")
                except Exception:
                    pass
                if checklist:
                    st.markdown("**Checklist:**")
                    for c in checklist:
                        st.markdown(f"  - [ ] {c}")

                if st.button("Log Review", key=f"model_rev_{p['principle_id']}"):
                    record_session(p["principle_id"], "review", "Mental model review via explorer")
                    st.success("Logged review.")
                    st.rerun()


# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — DANGER FLAG DETECTOR
# ══════════════════════════════════════════════════════════════════════════════
with tab_danger:
    st.subheader("⚠️ Danger Flag Detector")
    st.caption(
        "Dangerous cognitive patterns identified in your knowledge base. "
        "These are principles **about** dangerous patterns — not the patterns themselves."
    )

    danger_summary = get_danger_summary()

    # Danger flag overview
    da1, da2, da3, da4 = st.columns(4)
    da1.metric("🎲 Martingale",      danger_summary.get("martingale_addiction", 0))
    da2.metric("📈 Overfitting",      danger_summary.get("overfitting",          0))
    da3.metric("🎯 Opt. Bias",        danger_summary.get("optimization_bias",    0))
    da4.metric("😠 Revenge Trading",  danger_summary.get("revenge_trading",      0))

    db1, db2, db3, db4 = st.columns(4)
    db1.metric("💪 Overconfidence",   danger_summary.get("overconfidence",       0))
    db2.metric("⚓ Sunk Cost",        danger_summary.get("sunk_cost",            0))
    db3.metric("📅 Recency Bias",     danger_summary.get("recency_bias",         0))
    db4.metric("🪦 Survivorship",     danger_summary.get("survivorship_bias",    0))

    st.divider()

    # Real-time text scanner
    st.markdown("**Scan text for dangerous concepts**")
    st.caption("Paste any research note, trading idea, or strategy description to detect anti-patterns.")
    scan_text = st.text_area("Text to scan", height=120, placeholder="Paste text here…", key="danger_scan")
    if scan_text:
        found = detect_danger_flags(scan_text)
        if found:
            st.error(f"🚨 **{len(found)} danger pattern(s) detected:**")
            for f in found:
                st.markdown(
                    f"- **{DANGER_FLAGS.get(f, f)}** — "
                    f"{'Review the **Principle Library** for the antidote to this pattern.'}"
                )
        else:
            st.success("✅ No dangerous patterns detected in this text.")

    st.divider()

    # Principles that address each danger
    st.markdown("**Principles that address dangerous patterns**")
    for flag_key, flag_label in DANGER_FLAGS.items():
        df_flag = get_principles(danger_flag=flag_key, status="active")
        if df_flag.empty:
            continue
        with st.expander(f"{flag_label} — {len(df_flag)} principle(s)", expanded=False):
            for _, p in df_flag.iterrows():
                _mc = MINDSET_COLORS.get(p.get("mindset_type",""), "#546e7a")
                st.markdown(
                    f"**{p['title']}**  "
                    f"<span style='color:{_mc};font-size:0.8rem'>"
                    f"[{MINDSET_TYPES.get(p.get('mindset_type',''),'')}]</span>  \n"
                    f"{str(p.get('concept',''))[:150]}…",
                    unsafe_allow_html=True,
                )


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — ADD PRINCIPLE
# ══════════════════════════════════════════════════════════════════════════════
with tab_add:
    st.subheader("➕ Add New Principle")

    with st.form("add_principle_form"):
        ap1, ap2 = st.columns(2)
        title = ap1.text_input("Title *", placeholder="Name this principle precisely")
        mindset_type = ap2.selectbox(
            "Mindset type *",
            list(MINDSET_TYPES.keys()),
            format_func=lambda x: MINDSET_TYPES.get(x, x),
        )

        concept = st.text_area("Concept *", height=80,
            placeholder="What is this principle? Define it precisely in 2-3 sentences.")
        why_it_matters = st.text_area("Why It Matters", height=70,
            placeholder="Why does violating this principle lead to loss?")

        col_fc, col_ap = st.columns(2)
        failure_cases_raw = col_fc.text_area("Failure Cases (one per line)", height=100,
            placeholder="Example: Running momentum EA in REVERTING regime")
        applications_raw  = col_ap.text_area("Practical Applications (one per line)", height=100,
            placeholder="Example: Check SC₁₀₀ at session open before any trade")

        col_s, col_r, col_sess = st.columns(3)
        strategies_raw  = col_s.text_area("Related Strategies (one per line)", height=80)
        risk_rules_raw  = col_r.text_area("Risk Rules (one per line)", height=80)
        sessions_raw    = col_sess.text_area("Sessions / Regimes (one per line)", height=80)

        checklist_raw = st.text_area("Implementation Checklist (one per line)", height=80,
            placeholder="Example: SC₁₀₀ computed on last 100 M1 bars")

        af1, af2, af3 = st.columns(3)
        danger_flags_sel = af1.multiselect(
            "Danger flags (if this principle addresses a dangerous pattern)",
            list(DANGER_FLAGS.keys()),
            format_func=lambda x: DANGER_FLAGS.get(x, x),
        )
        source_ref  = af2.text_input("Source reference", placeholder="Book / page / file name")
        source_type = af3.selectbox("Source type", ["manual", "research", "arena", "seed"])

        submitted = st.form_submit_button("➕ Create Principle", type="primary",
                                          use_container_width=True)

    if submitted:
        if not title or not concept:
            st.error("Title and Concept are required.")
        else:
            def _lines(raw):
                return [l.strip() for l in raw.strip().splitlines() if l.strip()] if raw else []

            ok, pid, msg = create_principle(
                title=title, mindset_type=mindset_type,
                concept=concept, why_it_matters=why_it_matters,
                failure_cases=_lines(failure_cases_raw),
                practical_applications=_lines(applications_raw),
                related_strategies=_lines(strategies_raw),
                related_risk_rules=_lines(risk_rules_raw),
                related_sessions=_lines(sessions_raw),
                implementation_checklist=_lines(checklist_raw),
                danger_flags=danger_flags_sel,
                source_ref=source_ref, source_type=source_type,
            )
            if ok:
                st.success(f"Created **{pid}** — {title[:50]}")
                st.session_state["lib_sel"] = pid
            else:
                st.error(msg)
            st.rerun()

# ══════════════════════════════════════════════════════════════════════════════
# TAB 5 — SYNC & EXPAND
# ══════════════════════════════════════════════════════════════════════════════
with tab_sync:
    st.subheader("⚡ Sync & Expand Principle Library")

    # ── Section A: Sync status ────────────────────────────────────────────────
    st.markdown("### Obsidian Sync Status")
    st.caption(
        "Shows which principles have been written to the Obsidian vault. "
        "note_path = DB column; files_exist = actual file on disk."
    )

    if st.button("🔄 Check Sync Status", key="check_sync"):
        status = obs.get_sync_status()
        p = status["principles"]
        sc1, sc2, sc3, sc4 = st.columns(4)
        sc1.metric("Total Active",  p["total"])
        sc2.metric("DB Path Set",   p["db_path_set"])
        sc3.metric("Files Exist",   p["files_exist"])
        sc4.metric("Needs Sync",    p["needs_sync"],
                   delta_color="inverse" if p["needs_sync"] > 0 else "normal")

        if p["missing"]:
            st.warning(f"**{len(p['missing'])} principles** not yet written to Obsidian:")
            for m in p["missing"][:10]:
                st.markdown(f"  - `{m['id']}` — {m['title']}")
            if len(p["missing"]) > 10:
                st.caption(f"… and {len(p['missing'])-10} more")

        kg_nodes = status.get("knowledge_nodes", {})
        if kg_nodes:
            st.markdown("**Knowledge Graph Node Sync:**")
            for ntype, counts in sorted(kg_nodes.items()):
                if ntype == "research":
                    continue
                bar = "█" * counts["on_disk"] + "░" * (counts["total"] - counts["on_disk"])
                st.caption(
                    f"`{ntype:<12}` {bar[:30]}  "
                    f"{counts['on_disk']}/{counts['total']} on disk"
                )

    st.divider()

    # ── Section B: Batch sync ─────────────────────────────────────────────────
    st.markdown("### Batch Write to Obsidian Vault")

    sync_col1, sync_col2 = st.columns(2)

    with sync_col1:
        st.markdown("**Principles → Obsidian**")
        force_p = st.checkbox("Force re-write (overwrite existing)", key="force_p_sync")
        if st.button("📝 Sync All Principles", key="sync_principles", type="primary"):
            with st.spinner("Writing principles to vault…"):
                result = obs.sync_all_principles(force=force_p)
            sc1, sc2, sc3 = st.columns(3)
            sc1.metric("Written",  result["written"])
            sc2.metric("Skipped",  result["skipped"])
            sc3.metric("Failed",   result["failed"], delta_color="inverse" if result["failed"] else "normal")
            if result["errors"]:
                for e in result["errors"][:5]:
                    st.error(e)
            elif result["written"] > 0:
                st.success(f"✅ {result['written']} principles written to vault.")
            else:
                st.info("All principles already synced. Use 'Force re-write' to refresh.")

    with sync_col2:
        st.markdown("**Knowledge Graph Nodes → Obsidian**")
        force_kg = st.checkbox("Force re-write (overwrite existing)", key="force_kg_sync")
        if st.button("🕸️ Sync KG Nodes", key="sync_kg_nodes"):
            with st.spinner("Writing knowledge nodes to vault…"):
                result = obs.sync_knowledge_nodes(force=force_kg)
            sc1, sc2, sc3 = st.columns(3)
            sc1.metric("Written",  result["written"])
            sc2.metric("Skipped",  result["skipped"])
            sc3.metric("Failed",   result["failed"], delta_color="inverse" if result["failed"] else "normal")
            if result.get("by_type"):
                st.markdown("**By node type:**")
                for ntype, count in sorted(result["by_type"].items()):
                    st.caption(f"  {ntype}: {count}")
            if result["errors"]:
                for e in result["errors"][:3]:
                    st.error(e)

    if st.button("⚡ Full Sync (Principles + KG Nodes)", key="full_sync"):
        with st.spinner("Running full Obsidian sync…"):
            result = obs.run_full_sync(force=False)
        st.success(
            f"✅ Full sync complete — "
            f"Written: {result['total_written']} | "
            f"Skipped: {result['total_skipped']} | "
            f"Failed: {result['total_failed']}"
        )
        if result["all_errors"]:
            st.warning(f"{len(result['all_errors'])} errors:")
            for e in result["all_errors"][:5]:
                st.error(e)

    st.divider()

    # ── Section C: Expand principle library ───────────────────────────────────
    st.markdown("### Expand Principle Library (Phase 2 Principles)")
    st.markdown(
        "Adds **16 new principles** across 4 categories:  \n"
        "- 🛡 Risk Philosophy ×5 (Max DD Cap, Consecutive Loss Pause, "
        "Equity Curve Filter, Volatility Risk Scaling, Portfolio Heat)  \n"
        "- 🔢 Quantitative Mindset ×3 (Walk-Forward, OOS Sacred, Monte Carlo)  \n"
        "- 📈 Trading Principle ×4 (SC₁₀₀ Discipline, Regime-Adaptive Sizing, "
        "WEAK Regime, CRASH Regime)  \n"
        "- ⚙️ Engineering Process ×4 (Session Discipline, Spread Filter, "
        "News Protocol, Slippage Budget)"
    )

    exp_col1, exp_col2 = st.columns(2)
    with exp_col1:
        if st.button("🔍 Preview (dry run)", key="preview_expand"):
            result = seed_additional_principles(dry_run=True)
            st.info(
                f"Would insert **{result['inserted']}** new principles, "
                f"skip **{result['skipped']}** duplicates."
            )
    with exp_col2:
        if st.button("➕ Insert 16 Principles", key="do_expand", type="primary"):
            result = seed_additional_principles(dry_run=False)
            if result["inserted"] > 0:
                st.success(
                    f"✅ Inserted **{result['inserted']}** principles. "
                    f"Skipped {result['skipped']} duplicates."
                )
                st.rerun()
            else:
                st.info(f"All principles already exist ({result['skipped']} duplicates found).")
            if result["errors"]:
                for e in result["errors"]:
                    st.error(e)

st.divider()
st.caption(
    "Research Standards & Engineering Workflow: **📐 Research Standards** (page 23)  ·  "
    "Danger scanning works on any pasted text — use it when reviewing new research or strategy ideas."
)
