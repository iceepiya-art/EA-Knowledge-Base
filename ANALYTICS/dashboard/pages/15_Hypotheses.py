"""
15_Hypotheses.py — Hypothesis-to-Validation Pipeline

5-state lifecycle: idea → testing → observing → validated | rejected

Tabs:
  Tracker  — filterable table with confidence scores
  Pipeline — kanban cards with live stats + actions
  Create   — new hypothesis form
  Edges    — validated edges with edge_score + drift alerts
  Archive  — rejected hypotheses
"""

import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd

from utils import load_trades, pct, usd, num, C_WIN, C_LOSS, C_PRIMARY
from hypothesis_tracker import (
    run_migration, ensure_folders,
    STATUSES, STATUS_COLORS, PRIORITIES, ALERT_COLORS, EV_TYPES,
    create_hypothesis, update_hypothesis, get_hypotheses, get_hypothesis,
    compute_live_stats, refresh_all_stats, compute_confidence_score, compute_edge_score,
    advance_to_observing, auto_check_observing, reject_hypothesis,
    record_evidence, get_evidence, get_audit_trail,
    promote_to_edge,
    get_edges, refresh_edge_stats, deactivate_edge,
    sync_test_ideas_to_db,
)

st.set_page_config(
    page_title="Hypotheses — QTrade OS",
    page_icon="🧬",
    layout="wide",
)

run_migration()
ensure_folders()

# ── Load data ─────────────────────────────────────────────────────────────────
df_all    = load_trades()
all_hyps  = get_hypotheses()
edges_all = get_edges(active_only=False)

# ── Header ────────────────────────────────────────────────────────────────────
st.title("🧬 Hypothesis-to-Validation Pipeline")
st.caption(
    "Research ideas become trading rules **only** after sufficient evidence "
    "is collected and a human manually promotes them. No autonomous rule changes."
)

counts = all_hyps["status"].value_counts().to_dict() if not all_hyps.empty else {}
live_edges = int(edges_all["is_active"].sum()) if not edges_all.empty else 0

h1, h2, h3, h4, h5, h6 = st.columns(6)
h1.metric("💡 Ideas",      counts.get("idea",      0))
h2.metric("🔬 Testing",    counts.get("testing",   0), delta="collecting evidence")
h3.metric("🔭 Observing",  counts.get("observing", 0), delta="awaiting review")
h4.metric("✅ Validated",  counts.get("validated", 0))
h5.metric("❌ Rejected",   counts.get("rejected",  0))
h6.metric("🔗 Live Edges", live_edges)

st.divider()

tab_tracker, tab_pipeline, tab_create, tab_edges, tab_archive = st.tabs([
    "📋 Tracker", "📊 Pipeline", "➕ Create", "✅ Edges", "🗄 Archive",
])


# ══════════════════════════════════════════════════════════════════════════════
# SHARED: hypothesis detail panel
# Must be defined before any tab that calls it.
# ══════════════════════════════════════════════════════════════════════════════

def _render_hyp_detail(hyp_id: str, df) -> None:
    hyp = get_hypothesis(hyp_id)
    if not hyp:
        st.error(f"{hyp_id} not found")
        return

    status = hyp["status"]
    color  = STATUS_COLORS.get(status, "#8892b0")
    n      = int(hyp.get("actual_n") or 0)
    min_n  = int(hyp.get("min_trades") or 30)
    conf   = float(hyp.get("confidence_score") or 0)

    st.markdown(
        f"### {hyp_id}: {hyp['title']}  "
        f"<span style='color:{color};font-size:0.85rem'>[{status.upper()}]</span>",
        unsafe_allow_html=True,
    )

    di1, di2, di3 = st.columns([3, 2, 2])

    with di1:
        if hyp.get("rationale"):
            st.markdown(f"**Rationale:** {hyp['rationale']}")
        if hyp.get("description"):
            st.caption(hyp["description"])
        dims = []
        for k, lbl in [("ea_name","EA"),("symbol","Symbol"),("session","Session"),
                        ("regime","Regime"),("direction","Dir")]:
            if hyp.get(k):
                dims.append(f"**{lbl}:** {hyp[k]}")
        if dims:
            st.markdown("  ·  ".join(dims))
        if hyp.get("custom_filter"):
            st.caption(f"Filter: {hyp['custom_filter']}")

    with di2:
        st.metric("N trades",   f"{n:,}")
        st.metric("Win Rate",   pct(hyp.get("actual_wr"))  if hyp.get("actual_wr")  else "—")
        st.metric("PF",         num(hyp.get("actual_pf"))  if hyp.get("actual_pf")  else "—")
        st.metric("Expectancy", usd(hyp.get("actual_exp")) if hyp.get("actual_exp") else "—")

    with di3:
        st.markdown("**Confidence score**")
        st.progress(conf / 100, text=f"{conf:.0f} / 100")

        if status in ("testing", "observing"):
            prog = min(n / max(min_n, 1), 1.0)
            st.markdown("**Sample progress**")
            st.progress(prog, text=f"{n} / {min_n} trades needed")

        twr = hyp.get("target_wr")
        tpf = hyp.get("target_pf")
        if twr or tpf:
            parts = []
            if twr: parts.append(f"WR ≥ {pct(float(twr))}")
            if tpf: parts.append(f"PF ≥ {num(float(tpf))}")
            st.caption("Targets: " + "  |  ".join(parts))

    # Actions
    st.markdown("**Actions**")
    a1, a2, a3, a4, a5 = st.columns(5)

    if status == "idea":
        if a1.button("▶ Start Testing", key=f"act_test_{hyp_id}"):
            update_hypothesis(hyp_id, {"status": "testing"})
            st.rerun()
        if a4.button("❌ Reject idea", key=f"act_rej_idea_{hyp_id}"):
            reject_hypothesis(hyp_id)
            st.rerun()

    if status == "testing":
        if a1.button("🔭 Mark Observing", key=f"act_obs_{hyp_id}",
                     help=f"Need {min_n} trades (have {n})", disabled=(n < min_n)):
            ok, msg = advance_to_observing(hyp_id)
            st.success(msg) if ok else st.error(msg)
            st.rerun()

    if status in ("testing", "observing"):
        if a2.button("✅ Promote to Edge", key=f"act_promo_{hyp_id}"):
            ok, eid, msg = promote_to_edge(hyp_id, confidence=3, df=df)
            st.success(msg) if ok else st.error(msg)
            st.rerun()

        if a3.button("❌ Reject", key=f"act_rej_{hyp_id}"):
            st.session_state[f"rej_confirm_{hyp_id}"] = True

        if st.session_state.get(f"rej_confirm_{hyp_id}"):
            rej_reason = st.text_input("Rejection reason", key=f"rej_reason_{hyp_id}")
            if st.button("Confirm reject", key=f"rej_ok_{hyp_id}"):
                reject_hypothesis(hyp_id, rej_reason)
                st.session_state.pop(f"rej_confirm_{hyp_id}", None)
                st.rerun()

        if a5.button("⏸ Pause → Idea", key=f"act_pause_{hyp_id}"):
            update_hypothesis(hyp_id, {"status": "idea"})
            st.rerun()

    if status == "rejected":
        if a1.button("↺ Reopen as Idea", key=f"act_reopen_{hyp_id}"):
            update_hypothesis(hyp_id, {"status": "idea"})
            st.rerun()

    if status == "validated":
        st.caption("✅ Validated edge created. View in the Edges tab.")

    st.divider()

    # Evidence + Audit in sub-tabs
    ev_tab, audit_tab, ev_add_tab = st.tabs([
        "📎 Evidence", "📜 Audit Trail", "➕ Add Evidence",
    ])

    with ev_tab:
        ev_df = get_evidence(hyp_id)
        if ev_df.empty:
            st.info("No evidence recorded yet.")
        else:
            for _, ev in ev_df.iterrows():
                icon = "✅" if ev.get("supports") == 1 else "⛔"
                strength_stars = "★" * int(ev.get("strength") or 3)
                with st.expander(
                    f"{icon} {ev['title']}  ·  `{ev['ev_type']}`  ·  {strength_stars}",
                    expanded=False,
                ):
                    if ev.get("description"):
                        st.markdown(ev["description"])
                    cols = st.columns(4)
                    if ev.get("trades_n"):        cols[0].metric("N",   ev["trades_n"])
                    if ev.get("win_rate"):        cols[1].metric("WR",  pct(ev["win_rate"]))
                    if ev.get("profit_factor"):   cols[2].metric("PF",  num(ev["profit_factor"]))
                    if ev.get("expectancy"):      cols[3].metric("Exp", usd(ev["expectancy"]))
                    if ev.get("source_ref"):
                        st.caption(f"Source: {ev['source_ref']}")
                    st.caption(f"Recorded: {str(ev.get('recorded_at',''))[:16]}")

    with audit_tab:
        audit_df = get_audit_trail(hyp_id)
        if audit_df.empty:
            st.info("No audit trail yet.")
        else:
            disp = audit_df[["changed_at","field_name","old_value","new_value","changed_by"]].copy()
            disp.columns = ["When","Field","Old","New","By"]
            st.dataframe(disp, use_container_width=True, hide_index=True)

    with ev_add_tab:
        with st.form(f"ev_form_{hyp_id}"):
            ev_title = st.text_input("Title *", placeholder="London session backtest Q1 2026")
            ev_type  = st.selectbox("Evidence type", EV_TYPES)
            ev_desc  = st.text_area("Description", height=80)
            ec1, ec2, ec3 = st.columns(3)
            ev_n  = ec1.number_input("N trades",        min_value=0,     value=0)
            ev_wr = ec2.number_input("Win Rate (%)",    0.0, 100.0, 0.0, step=1.0)
            ev_pf = ec3.number_input("Profit Factor",   0.0,  20.0, 0.0, step=0.1)
            ec4, ec5 = st.columns(2)
            ev_exp = ec4.number_input("Expectancy ($)", -1000.0, 1000.0, 0.0, step=0.5)
            ev_net = ec5.number_input("Net PnL ($)",  -100000.0, 100000.0, 0.0, step=1.0)
            es1, es2, es3 = st.columns(3)
            ev_sup = es1.selectbox("Supports?", ["Yes (supports)", "No (contradicts)"])
            ev_str = es2.selectbox(
                "Strength", [1, 2, 3, 4, 5], index=2,
                format_func=lambda x: f"{x} — {['Weak','Weak-Mod','Moderate','Mod-Strong','Strong'][x-1]}",
            )
            ev_ref    = es3.text_input("Source ref")
            ev_submit = st.form_submit_button("Add Evidence", type="primary")

        if ev_submit:
            if not ev_title.strip():
                st.error("Title is required.")
            else:
                ok, ev_id, msg = record_evidence(
                    hyp_id        = hyp_id,
                    title         = ev_title.strip(),
                    description   = ev_desc.strip(),
                    ev_type       = ev_type,
                    trades_n      = int(ev_n) if ev_n > 0 else None,
                    win_rate      = ev_wr / 100 if ev_wr > 0 else None,
                    profit_factor = ev_pf if ev_pf > 0 else None,
                    expectancy    = ev_exp if ev_exp != 0 else None,
                    net_pnl       = ev_net if ev_net != 0 else None,
                    supports      = 1 if ev_sup.startswith("Yes") else 0,
                    strength      = int(ev_str),
                    source_ref    = ev_ref.strip(),
                )
                st.success(msg) if ok else st.error(msg)
                st.rerun()


# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — TRACKER  (table view with confidence scores)
# ══════════════════════════════════════════════════════════════════════════════
with tab_tracker:
    st.subheader("All Hypotheses")

    fc1, fc2, fc3 = st.columns([2, 1, 1])
    filter_status = fc1.radio(
        "Filter by status",
        ["All"] + STATUSES,
        horizontal=True,
        key="tracker_filter",
    )
    show_with_data = fc2.toggle("Only with trade data", value=False)
    sort_col = fc3.selectbox("Sort by", ["priority", "created_at", "confidence_score", "actual_n"])

    status_q = None if filter_status == "All" else filter_status
    hyps_t   = get_hypotheses(status_q)

    if show_with_data and not hyps_t.empty:
        hyps_t = hyps_t[hyps_t["actual_n"].fillna(0) > 0]

    if not hyps_t.empty and sort_col in hyps_t.columns:
        asc = sort_col == "priority"
        hyps_t = hyps_t.sort_values(sort_col, ascending=asc, na_position="last")

    if hyps_t.empty:
        st.info("No hypotheses match the current filter.")
    else:
        # Refresh + auto-check buttons
        rb1, rb2 = st.columns(2)
        if rb1.button("🔄 Refresh Live Stats", key="t_refresh"):
            n = refresh_all_stats(df_all)
            st.success(f"Refreshed {n} hypotheses.")
            st.rerun()
        if rb2.button("⚡ Auto-check Observing", key="t_autocheck",
                      help="Advances testing→observing if N≥min_trades"):
            n = auto_check_observing(df_all)
            st.success(f"Advanced {n} hypothesis(es) to Observing.")
            st.rerun()

        st.caption(f"{len(hyps_t)} hypotheses")

        # Build display table
        rows = []
        for _, r in hyps_t.iterrows():
            n     = int(r.get("actual_n") or 0)
            min_n = int(r.get("min_trades") or 30)
            conf  = float(r.get("confidence_score") or 0)
            status = r["status"]
            rows.append({
                "ID":         r["hyp_id"],
                "Title":      r["title"],
                "Status":     status.upper(),
                "Priority":   PRIORITIES.get(int(r.get("priority") or 2), "Medium"),
                "EA":         r.get("ea_name") or "—",
                "Symbol":     r.get("symbol")  or "—",
                "N / Min":    f"{n} / {min_n}",
                "Confidence": conf,
                "WR":         pct(r.get("actual_wr"))  if r.get("actual_wr")  else "—",
                "PF":         num(r.get("actual_pf"))  if r.get("actual_pf")  else "—",
                "Created":    str(r.get("created_at") or "")[:10],
            })
        tdf = pd.DataFrame(rows)

        st.dataframe(
            tdf,
            use_container_width=True,
            hide_index=True,
            column_config={
                "Confidence": st.column_config.ProgressColumn(
                    "Confidence", min_value=0, max_value=100, format="%.0f"
                ),
            },
        )

        # Expand to see details + actions
        st.caption("Select a hypothesis to view details and actions:")
        sel_id = st.selectbox(
            "Hypothesis",
            ["—"] + hyps_t["hyp_id"].tolist(),
            key="tracker_sel",
        )
        if sel_id and sel_id != "—":
            _render_hyp_detail(sel_id, df_all)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — PIPELINE  (grouped kanban-style cards)
# ══════════════════════════════════════════════════════════════════════════════
with tab_pipeline:

    p1, p2 = st.columns([3, 1])
    with p2:
        if st.button("🔄 Refresh Stats", key="pipe_refresh"):
            n = refresh_all_stats(df_all)
            st.success(f"Refreshed {n}")
            st.rerun()
        if st.button("⚡ Auto-check", key="pipe_auto"):
            n = auto_check_observing(df_all)
            st.success(f"Advanced {n}")
            st.rerun()

    # Pipeline funnel
    if not all_hyps.empty and len(all_hyps) >= 2:
        funnel_data = [(s, counts.get(s, 0))
                       for s in ["idea","testing","observing","validated","rejected"]]
        fig_f = go.Figure(go.Funnel(
            y=[s.capitalize() for s, _ in funnel_data],
            x=[n for _, n in funnel_data],
            textinfo="value+percent initial",
            marker=dict(color=[STATUS_COLORS[s] for s, _ in funnel_data]),
        ))
        fig_f.update_layout(
            height=220,
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0, r=0, t=10, b=0),
        )
        st.plotly_chart(fig_f, use_container_width=True)

    st.divider()

    # Active statuses: idea / testing / observing
    active_statuses = ["idea", "testing", "observing"]
    cols = st.columns(3)

    for ci, st_name in enumerate(active_statuses):
        h_color = STATUS_COLORS[st_name]
        hyps_s  = get_hypotheses(st_name)

        with cols[ci]:
            st.markdown(
                f"<div style='background:{h_color}20;border-left:3px solid {h_color};"
                f"padding:6px 10px;border-radius:4px;margin-bottom:8px'>"
                f"<b style='color:{h_color}'>{st_name.upper()}</b> "
                f"<span style='color:#8892b0'>({len(hyps_s)})</span></div>",
                unsafe_allow_html=True,
            )

            if hyps_s.empty:
                st.caption("None")
            else:
                for _, row in hyps_s.iterrows():
                    hyp_id = row["hyp_id"]
                    n      = int(row.get("actual_n") or 0)
                    min_n  = int(row.get("min_trades") or 30)
                    conf   = float(row.get("confidence_score") or 0)

                    with st.expander(f"**{hyp_id}**  {row['title'][:35]}", expanded=False):
                        if row.get("ea_name") or row.get("symbol"):
                            tag_parts = []
                            if row.get("ea_name"):  tag_parts.append(row["ea_name"])
                            if row.get("symbol"):   tag_parts.append(row["symbol"])
                            if row.get("session"):  tag_parts.append(row["session"])
                            st.caption("  ·  ".join(tag_parts))

                        mc1, mc2 = st.columns(2)
                        mc1.metric("N", f"{n:,}")
                        mc2.metric("WR", pct(row.get("actual_wr")) if row.get("actual_wr") else "—")

                        if st_name in ("testing", "observing"):
                            prog = min(n / max(min_n, 1), 1.0)
                            st.progress(prog, text=f"{n}/{min_n}")

                        st.progress(conf / 100, text=f"Conf: {conf:.0f}")

                        if st_name == "idea":
                            if st.button("▶ Test", key=f"p_test_{hyp_id}"):
                                update_hypothesis(hyp_id, {"status": "testing"})
                                st.rerun()

                        if st_name == "testing":
                            pb1, pb2 = st.columns(2)
                            if pb1.button("🔭", key=f"p_obs_{hyp_id}",
                                          help="Move to Observing",
                                          disabled=(n < min_n)):
                                ok, msg = advance_to_observing(hyp_id)
                                st.toast(msg)
                                st.rerun()
                            if pb2.button("❌", key=f"p_rej_t_{hyp_id}"):
                                reject_hypothesis(hyp_id)
                                st.rerun()

                        if st_name == "observing":
                            ob1, ob2 = st.columns(2)
                            if ob1.button("✅", key=f"p_val_{hyp_id}",
                                          help="Promote to validated edge"):
                                ok, eid, msg = promote_to_edge(hyp_id, df=df_all)
                                st.toast(msg)
                                st.rerun()
                            if ob2.button("❌", key=f"p_rej_o_{hyp_id}"):
                                reject_hypothesis(hyp_id)
                                st.rerun()


# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — CREATE NEW HYPOTHESIS
# ══════════════════════════════════════════════════════════════════════════════
with tab_create:
    st.subheader("Create New Hypothesis")
    st.caption(
        "Define a testable idea with specific filter conditions. "
        "The dashboard auto-queries your trades DB for evidence."
    )

    ea_list  = [""] + sorted(df_all["strategy"].dropna().unique().tolist()) if not df_all.empty else [""]
    sym_list = [""] + sorted(df_all["symbol"].dropna().unique().tolist())   if not df_all.empty else [""]

    with st.form("new_hyp_form"):
        st.markdown("#### Core Idea")
        c_title = st.text_input(
            "Title *",
            placeholder="London session QField has WR > 60% in TRENDING regime",
        )
        c_rationale = st.text_area(
            "Rationale — WHY do you think this edge exists?",
            height=80,
            placeholder="Higher volatility during London open creates cleaner breakouts for QField's SC₁₀₀ filter...",
        )
        c_desc = st.text_area(
            "Hypothesis — WHAT is the specific testable claim?",
            height=80,
            placeholder="When QField trades during London session in TRENDING regime, WR exceeds 60% over ≥30 trades.",
        )

        st.markdown("#### Filter Conditions")
        st.caption("Leave blank = match any value. More specific = smaller sample.")
        fc1, fc2, fc3 = st.columns(3)
        f_ea  = fc1.selectbox("EA",        ea_list)
        f_sym = fc2.selectbox("Symbol",    sym_list)
        f_dir = fc3.selectbox("Direction", ["", "BUY", "SELL"])

        fc4, fc5 = st.columns(2)
        f_sess   = fc4.selectbox("Session",
            ["", "Asian", "London", "Pre_NY", "London_NY", "NY", "Other"])
        f_regime = fc5.selectbox("Regime",
            ["", "TRENDING", "REVERTING", "WEAK", "CRASH"])

        f_custom = st.text_input("Custom filter (free text)",
            placeholder="e.g. RSI < 40 at entry, or Monday only")

        st.markdown("#### Validation Targets")
        vc1, vc2, vc3, vc4 = st.columns(4)
        f_min_trades = vc1.number_input("Min trades needed", 10, 500, 30)
        f_target_wr  = vc2.number_input("Target WR (%)", 0.0, 100.0, 55.0, step=1.0)
        f_target_pf  = vc3.number_input("Target PF", 0.0, 10.0, 1.5, step=0.1)
        f_target_exp = vc4.number_input("Target Expectancy ($)", 0.0, 1000.0, 0.0, step=0.5)

        st.markdown("#### Meta")
        mc1, mc2 = st.columns(2)
        f_priority = mc1.selectbox("Priority", [1, 2, 3],
                                   format_func=lambda x: PRIORITIES[x], index=1)
        f_notes = mc2.text_area("Notes / Sources", height=60,
            placeholder="Links to NotebookLM notes, YouTube sources, strategy articles…")

        submitted = st.form_submit_button("➕ Create Hypothesis", type="primary",
                                          use_container_width=True)

    if submitted:
        if not c_title.strip():
            st.error("Title is required.")
        else:
            ok, hyp_id, msg = create_hypothesis(
                title         = c_title.strip(),
                description   = c_desc.strip(),
                rationale     = c_rationale.strip(),
                ea_name       = f_ea     or None,
                symbol        = f_sym    or None,
                session       = f_sess   or None,
                regime        = f_regime or None,
                direction     = f_dir    or None,
                custom_filter = f_custom.strip() or "",
                target_wr     = f_target_wr / 100 if f_target_wr > 0 else None,
                target_pf     = f_target_pf if f_target_pf > 0 else None,
                target_exp    = f_target_exp if f_target_exp > 0 else None,
                min_trades    = int(f_min_trades),
                priority      = int(f_priority),
                notes         = f_notes.strip(),
            )
            if ok:
                st.success(f"Created **{hyp_id}**. Go to Pipeline tab to start testing.")
            else:
                st.error(msg)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — VALIDATED EDGES
# ══════════════════════════════════════════════════════════════════════════════
with tab_edges:
    st.subheader("Validated Edges")
    st.caption(
        "Edges with statistically sufficient evidence. "
        "These inform strategy decisions — they do NOT auto-execute trades."
    )

    er1, er2 = st.columns(2)
    if er1.button("🔄 Refresh Edge Stats", key="refresh_edges"):
        n = refresh_edge_stats(df_all)
        st.success(f"Refreshed {n} edge(s).")
        st.rerun()
    show_inactive = er2.toggle("Show inactive edges", value=False)

    edges = get_edges(active_only=not show_inactive)

    if edges.empty:
        st.info(
            "No validated edges yet. Hypotheses promote here after reaching "
            "min_trades and human review."
        )
    else:
        # Top edges summary bar
        if "edge_score" in edges.columns:
            fig_es = go.Figure(go.Bar(
                x=edges["title"].str[:30],
                y=edges["edge_score"].fillna(0),
                marker_color=[
                    C_WIN if s >= 60 else (C_PRIMARY if s >= 40 else C_LOSS)
                    for s in edges["edge_score"].fillna(0)
                ],
                text=edges["edge_score"].fillna(0).apply(lambda x: f"{x:.0f}"),
                textposition="auto",
            ))
            fig_es.update_layout(
                height=200, title="Edge Scores",
                xaxis=dict(tickangle=-20, gridcolor="#1e2130"),
                yaxis=dict(range=[0, 100], gridcolor="#1e2130"),
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                margin=dict(l=0, r=0, t=40, b=0),
            )
            st.plotly_chart(fig_es, use_container_width=True)

        for _, edge in edges.iterrows():
            edge_id   = edge["edge_id"]
            c_wr      = edge.get("current_wr")
            v_wr      = edge.get("validated_wr")
            c_pf      = edge.get("current_pf")
            v_pf      = edge.get("validated_pf")
            wr_drift  = edge.get("wr_drift")
            alert     = str(edge.get("alert_level") or "ok")
            e_score   = float(edge.get("edge_score") or 0)
            is_active = bool(edge.get("is_active", 1))
            alert_col = ALERT_COLORS.get(alert, "#26a69a")

            title_badge = ""
            if alert == "degrade":   title_badge = " 🚨 DEGRADE"
            elif alert == "warn":    title_badge = " ⚠ WARN"
            elif alert == "watch":   title_badge = " 👁 WATCH"

            inactive_note = "" if is_active else " [INACTIVE]"

            with st.expander(
                f"**{edge_id}** — {edge['title']}{title_badge}{inactive_note}  "
                f"| Score: {e_score:.0f}/100",
                expanded=(alert in ("warn", "degrade")),
            ):
                # Alert banner
                if alert in ("warn", "degrade"):
                    st.markdown(
                        f"<div style='background:{alert_col}30;border:1px solid {alert_col};"
                        f"border-radius:4px;padding:6px 10px;margin-bottom:8px'>"
                        f"<b style='color:{alert_col}'>Alert: {alert.upper()}</b> — "
                        f"WR drift: {f'{wr_drift:+.1%}' if wr_drift else '—'}"
                        f"</div>",
                        unsafe_allow_html=True,
                    )
                elif alert == "watch":
                    st.info(f"Watch: WR drift {f'{wr_drift:+.1%}' if wr_drift else '—'}")

                ec1, ec2, ec3, ec4, ec5 = st.columns(5)
                ec1.metric("Edge Score", f"{e_score:.0f}/100")
                ec2.metric("Current N",  f"{edge.get('current_n', 0):,}")
                ec3.metric(
                    "Current WR",
                    pct(c_wr) if c_wr else "—",
                    delta=f"{wr_drift:+.1%}" if wr_drift else None,
                    delta_color="normal" if (not wr_drift or wr_drift >= -0.05) else "inverse",
                )
                ec4.metric("Current PF", num(c_pf) if c_pf else "—",
                           delta=f"{edge.get('pf_drift'):+.2f}" if edge.get("pf_drift") else None,
                           delta_color="normal" if (not edge.get("pf_drift") or edge.get("pf_drift", 0) >= -0.2) else "inverse")
                ec5.metric("Confidence", "★" * int(edge.get("confidence") or 3))

                # Filter dims
                dims = [f"**{lbl}:** {edge[k]}" for k, lbl in [
                    ("ea_name","EA"),("symbol","Sym"),("session","Session"),
                    ("regime","Regime"),("direction","Dir"),
                ] if pd.notna(edge.get(k)) and edge.get(k)]
                if dims:
                    st.markdown("  ·  ".join(dims))
                st.caption(f"Condition: `{edge.get('condition', '')}`")
                st.caption(
                    f"Validated: {str(edge.get('validated_at',''))[:10]} | "
                    f"At validation: N={edge.get('sample_n',0)}, "
                    f"WR={pct(v_wr)}, PF={num(v_pf)}"
                )
                if edge.get("notes"):
                    st.markdown(f"**Rule:** {edge['notes']}")

                if is_active:
                    da1, da2 = st.columns([1, 3])
                    reason = da1.text_input("Deactivation reason", key=f"reason_{edge_id}",
                                            label_visibility="collapsed",
                                            placeholder="Reason to deactivate…")
                    if da2.button(f"Deactivate {edge_id}", key=f"deact_{edge_id}"):
                        if reason:
                            deactivate_edge(edge_id, reason)
                            st.rerun()
                        else:
                            st.error("Enter a reason first.")

        # WR chart: current vs validated
        chart_rows = []
        for _, e in edges.iterrows():
            if e.get("current_wr") and e.get("validated_wr"):
                chart_rows.append({
                    "Edge":      f"{e['edge_id']}: {e['title'][:25]}",
                    "Validated": float(e["validated_wr"]),
                    "Current":   float(e["current_wr"]),
                })
        if chart_rows:
            st.divider()
            st.subheader("Current vs Validated Win Rate")
            cdf = pd.DataFrame(chart_rows)
            fig2 = go.Figure()
            fig2.add_trace(go.Bar(
                name="Validated WR", x=cdf["Edge"], y=cdf["Validated"],
                marker_color="#546e7a", opacity=0.65,
            ))
            fig2.add_trace(go.Bar(
                name="Current WR", x=cdf["Edge"], y=cdf["Current"],
                marker_color=[C_WIN if c >= v else C_LOSS
                              for c, v in zip(cdf["Current"], cdf["Validated"])],
            ))
            fig2.update_layout(
                barmode="group", height=300,
                yaxis=dict(title="Win Rate", tickformat=".0%", gridcolor="#1e2130"),
                paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
                legend=dict(orientation="h", y=1.05),
                margin=dict(l=0, r=0, t=10, b=0),
            )
            st.plotly_chart(fig2, use_container_width=True)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 5 — ARCHIVE  (rejected hypotheses)
# ══════════════════════════════════════════════════════════════════════════════
with tab_archive:
    st.subheader("Rejected Hypotheses")
    st.caption(
        "Ideas that were tested and found insufficient. "
        "Reopen as Idea to re-examine with new evidence."
    )

    rejected = get_hypotheses("rejected")

    if rejected.empty:
        st.info("No rejected hypotheses yet.")
    else:
        # Sync button + table
        ra1, ra2 = st.columns([3, 1])
        ra1.caption(f"{len(rejected)} rejected hypotheses")
        if ra2.button("🔄 Sync Test Ideas", key="arch_sync"):
            n = sync_test_ideas_to_db()
            st.success(f"Imported {n} new idea(s).") if n else st.info("Nothing new to import.")
            st.rerun()

        for _, row in rejected.iterrows():
            hyp_id = row["hyp_id"]
            with st.expander(
                f"**{hyp_id}** — {row['title']}  |  "
                f"N={int(row.get('actual_n') or 0)}, "
                f"WR={pct(row.get('actual_wr')) if row.get('actual_wr') else '—'}",
                expanded=False,
            ):
                if row.get("description"):
                    st.caption(row["description"])
                dims = [f"**{lbl}:** {row[k]}" for k, lbl in [
                    ("ea_name","EA"),("symbol","Sym"),("session","Session"),
                    ("regime","Regime"),("direction","Dir"),
                ] if pd.notna(row.get(k)) and row.get(k)]
                if dims:
                    st.markdown("  ·  ".join(dims))

                # Show rejection reason from audit
                audit = get_audit_trail(hyp_id)
                if not audit.empty:
                    rej_entry = audit[audit["field_name"] == "rejection_reason"]
                    if not rej_entry.empty:
                        st.markdown(f"**Rejection reason:** {rej_entry.iloc[0]['new_value']}")

                st.caption(
                    f"Rejected: {str(row.get('rejected_at',''))[:10]} | "
                    f"Created: {str(row.get('created_at',''))[:10]}"
                )

                if st.button(f"↺ Reopen as Idea", key=f"reopen_{hyp_id}"):
                    update_hypothesis(hyp_id, {"status": "idea"})
                    st.rerun()

    st.divider()

    # Sync section
    st.subheader("Sync External Ideas")
    st.write(
        "Import `.md` files from `10_Research/10_Test_Ideas/` as new hypotheses."
    )
    test_ideas_dir = os.path.join(_ROOT, "10_Research", "10_Test_Ideas")
    try:
        n_files = len([f for f in os.listdir(test_ideas_dir)
                       if f.endswith(".md") and f.lower() != "readme.md"])
        st.metric("Test idea files found", n_files)
    except Exception:
        st.caption("Could not read 10_Test_Ideas directory.")

    if st.button("🔄 Sync Test Ideas → Database", type="primary", key="sync_btn"):
        n = sync_test_ideas_to_db()
        if n:
            st.success(f"Imported {n} new test idea(s) as hypotheses.")
        else:
            st.info("All test ideas already in database (or none found).")
        st.rerun()

    st.divider()
    st.subheader("Safety Philosophy")
    st.markdown("""
| Stage | Gate |
|---|---|
| 💡 Idea | Captured, no action required |
| 🔬 Testing | Dashboard shows live stats — human monitors |
| 🔭 Observing | N ≥ min_trades, auto-advanced — human reviews evidence |
| ✅ Validated | **Human clicks Promote** — only then edge is created |
| 🔗 Live Edge | Informs strategy decisions, does NOT auto-trade |
| ⚙️ Rule change | Requires separate human decision in EA settings |
""")

