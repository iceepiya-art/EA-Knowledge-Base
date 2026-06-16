"""
23_Research_Standards.py — Research & Engineering Standards

Focused views for research methodology, validation standards, engineering process,
and AI workflow discipline.
Tabs: 📐 Research Standards | ⚙️ Engineering Workflow | 🤖 AI Workflow | 📊 Quality Dashboard
"""

import sys, os, json
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.graph_objects as go
import pandas as pd

from utils import C_WIN, C_LOSS, C_PRIMARY
from mindset_tracker import (
    run_migration,
    MINDSET_TYPES, MINDSET_COLORS, MINDSET_TO_CATEGORY,
    DANGER_FLAGS, STATUS_COLORS,
    get_principles, get_principle, record_session,
    get_principle_summary, write_principle_note,
    detect_danger_flags, compute_quality_score,
)

st.set_page_config(
    page_title="Research Standards — QTrade OS",
    page_icon="📐",
    layout="wide",
)

run_migration()

# ── Header ────────────────────────────────────────────────────────────────────
st.title("📐 Research & Engineering Standards")
st.caption(
    "The rules of how we research, validate, build, and operate — not what we trade, "
    "but **how** we decide what to trade and how to build reliable systems."
)

# Pull principles by type
df_research   = get_principles(mindset_type="research_methodology",  status="active")
df_validation = get_principles(mindset_type="validation_standard",   status="active")
df_engineering = get_principles(mindset_type="engineering_process",  status="active")
df_trading    = get_principles(mindset_type="trading_principle",     status="active")
df_risk       = get_principles(mindset_type="risk_philosophy",       status="active")
df_behavioral = get_principles(mindset_type="behavioral_lesson",     status="active")

def _count(df): return len(df) if not df.empty else 0

h1, h2, h3, h4, h5, h6 = st.columns(6)
h1.metric("🔍 Research",       _count(df_research))
h2.metric("✅ Validation",     _count(df_validation))
h3.metric("⚙️ Engineering",   _count(df_engineering))
h4.metric("📈 Trading",        _count(df_trading))
h5.metric("🛡 Risk",           _count(df_risk))
h6.metric("🧠 Behavioral",     _count(df_behavioral))

st.divider()

tab_research, tab_engineering, tab_ai, tab_quality = st.tabs([
    "📐 Research Standards", "⚙️ Engineering Workflow",
    "🤖 AI Workflow Principles", "📊 Quality Dashboard",
])


def _render_principle_cards(df: pd.DataFrame, expanded_first: bool = False):
    """Render a list of principles as expandable cards with checklist view."""
    if df.empty:
        st.info("No principles in this category yet. Add them in **📚 Principle Library** (page 22).")
        return

    for i, (_, p) in enumerate(df.iterrows()):
        _mc  = MINDSET_COLORS.get(p.get("mindset_type",""), "#546e7a")
        _ml  = MINDSET_TYPES.get(p.get("mindset_type",""), "")
        _qs  = p.get("quality_score", 0)
        _vc  = int(p.get("violation_count", 0))
        _ac  = int(p.get("applied_count",   0))
        flags = json.loads(p.get("danger_flags") or "[]")
        flag_str = "  ⚠️ " + ", ".join(DANGER_FLAGS.get(f,f) for f in flags) if flags else ""

        qs_bar = int(min(_qs, 100))

        with st.expander(
            f"**{p['title']}**  |  Q:{_qs:.0f}{flag_str}",
            expanded=(i == 0 and expanded_first),
        ):
            st.markdown(
                f"<span style='color:{_mc};font-size:0.8rem'>{_ml}</span>",
                unsafe_allow_html=True,
            )

            if p.get("concept"):
                st.markdown(p["concept"])

            if p.get("why_it_matters"):
                st.markdown(f"**Why:** {p['why_it_matters']}")

            # Checklist
            cl = []
            try:
                cl = json.loads(p.get("implementation_checklist") or "[]")
            except Exception:
                pass
            if cl:
                st.markdown("**Implementation Checklist:**")
                for item in cl:
                    st.markdown(f"- [ ] {item}")

            # Failure cases
            fc = []
            try:
                fc = json.loads(p.get("failure_cases") or "[]")
            except Exception:
                pass
            if fc:
                st.markdown("**Known Failure Cases:**")
                for item in fc:
                    st.markdown(f"- ❌ {item}")

            # Action buttons
            ba1, ba2, ba3 = st.columns(3)
            pid = p["principle_id"]
            if ba1.button("✅ Mark Applied",    key=f"apply_{pid}"):
                record_session(pid, "apply",     "Applied from Research Standards page")
                st.success("Logged: applied.")
                st.rerun()
            if ba2.button("❌ Log Violation",   key=f"viol_{pid}"):
                record_session(pid, "violation",  "Violation logged from Research Standards page")
                st.warning("Logged: violation.")
                st.rerun()
            if ba3.button("📝 Write to Vault",  key=f"vault_{pid}"):
                path = write_principle_note(pid)
                st.success(f"Written: `{path}`") if path else st.error("Write failed.")

            if p.get("source_ref"):
                st.caption(f"Source: {p['source_ref']}")

            if _ac or _vc:
                st.caption(f"Applied: {_ac}×  ·  Violations: {_vc}×")


# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — RESEARCH STANDARDS
# ══════════════════════════════════════════════════════════════════════════════
with tab_research:
    st.subheader("📐 Research Methodology")
    st.caption("How we design research, source information, and build the hypothesis pipeline.")
    _render_principle_cards(df_research, expanded_first=True)

    if not df_validation.empty:
        st.divider()
        st.subheader("✅ Validation Standards")
        st.caption("Rules for confirming an edge is real before risking capital.")
        _render_principle_cards(df_validation)

    st.divider()

    # Research Pipeline Standards Tracker
    st.subheader("📋 Research Pipeline Standards Tracker")
    st.caption("Check how well your current research workflow meets the standards.")

    standards_checklist = [
        ("Hypothesis pre-registered before any testing",                    "research_methodology"),
        ("Null hypothesis explicitly stated for each idea",                 "research_methodology"),
        ("Source quality scored in Research Inbox",                         "research_methodology"),
        ("Counter-evidence searched before adopting any strategy",          "research_methodology"),
        ("N ≥ 30 enforced before declaring any result",                     "validation_standard"),
        ("Walk-forward validation run before live deployment",               "validation_standard"),
        ("Out-of-sample period ≥ 20% of backtest period",                   "validation_standard"),
        ("Sensitivity analysis: ±20% on all parameters",                    "validation_standard"),
        ("Backtest vs live WR comparison documented",                       "validation_standard"),
        ("Rejected hypotheses documented with reason in QTrade OS",         "research_methodology"),
    ]

    scores = {}
    for label, mtype in standards_checklist:
        mc = MINDSET_COLORS.get(mtype, "#546e7a")
        c1, c2 = st.columns([5, 1])
        c1.markdown(
            f"<span style='color:{mc};font-size:0.75rem'>{MINDSET_TYPES.get(mtype,'')}</span>  \n"
            f"{label}",
            unsafe_allow_html=True,
        )
        score = c2.select_slider("", ["✗", "~", "✓"], key=f"std_{label[:20]}", label_visibility="collapsed")
        scores[label] = score

    total_score = sum(1 for v in scores.values() if v == "✓")
    partial     = sum(1 for v in scores.values() if v == "~")
    compliance  = (total_score + partial * 0.5) / len(standards_checklist) * 100
    comp_color  = C_WIN if compliance >= 80 else (C_PRIMARY if compliance >= 60 else C_LOSS)

    st.markdown(
        f"**Research Standards Compliance: "
        f"<span style='color:{comp_color}'>{compliance:.0f}%</span>**",
        unsafe_allow_html=True,
    )


# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — ENGINEERING WORKFLOW
# ══════════════════════════════════════════════════════════════════════════════
with tab_engineering:
    st.subheader("⚙️ Engineering Process Discipline")
    st.caption(
        "How we build, document, and operate EA systems. "
        "Professional engineering standards applied to trading system development."
    )
    _render_principle_cards(df_engineering, expanded_first=True)

    st.divider()

    # Engineering Workflow Tracker
    st.subheader("📋 Engineering Workflow Tracker")
    st.caption("Assess the current state of your engineering practices.")

    eng_checklist = [
        "Every EA has a blueprint note in the knowledge vault",
        "Every parameter change has a change log entry",
        "EA version number incremented on every meaningful change",
        "Before/after A-B comparison run for every logic change",
        "One variable changed at a time during debugging",
        "Known failure modes documented for every live EA",
        "CLAUDE.md updated after every major architectural decision",
        "HANDOFF document created at end of each development session",
        "No EA deployed without sensitivity analysis on key parameters",
        "All MQL5 code patterns from 05_Code_Patterns.md reviewed before writing from scratch",
    ]

    passed = []
    for item in eng_checklist:
        ew1, ew2 = st.columns([5, 1])
        ew1.markdown(f"- {item}")
        val = ew2.checkbox("", key=f"eng_{item[:20]}", label_visibility="collapsed")
        passed.append(val)

    passed_count = sum(passed)
    eng_score    = passed_count / len(eng_checklist) * 100
    eng_color    = C_WIN if eng_score >= 80 else (C_PRIMARY if eng_score >= 60 else C_LOSS)

    st.markdown(
        f"**Engineering Discipline Score: "
        f"<span style='color:{eng_color}'>{eng_score:.0f}%</span>** "
        f"({passed_count}/{len(eng_checklist)} practices active)",
        unsafe_allow_html=True,
    )


# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — AI WORKFLOW PRINCIPLES
# ══════════════════════════════════════════════════════════════════════════════
with tab_ai:
    st.subheader("🤖 AI Workflow Principles")
    st.caption(
        "How to work effectively with AI systems in quantitative research. "
        "Context management, prompt engineering, validation of AI outputs."
    )

    # Pull all engineering + ai_workflow principles
    df_ai = get_principles(category="AI_Workflow_Principles", status="active")
    df_ai_eng = get_principles(mindset_type="engineering_process", status="active")

    _render_principle_cards(df_ai, expanded_first=True)
    if not df_ai.empty and not df_ai_eng.empty:
        st.divider()
        st.subheader("Engineering Principles with AI Application")
    _render_principle_cards(df_ai_eng)

    st.divider()

    # AI Workflow Standards Tracker
    st.subheader("🤖 AI Workflow Standards")

    ai_checklist = [
        ("CLAUDE.md reviewed at start of every AI session",       "High"),
        ("Context provided: EA name, blueprint, previous session", "High"),
        ("Memory files written for key decisions and preferences", "High"),
        ("HANDOFF document created at session end",                "High"),
        ("AI-generated code reviewed before running in MT5",       "Critical"),
        ("AI suggestions tested on demo account first",            "Critical"),
        ("AI outputs cross-checked against knowledge vault",       "Medium"),
        ("Prompt includes: current EA status + known issues",      "Medium"),
        ("Consolidate-memory skill run after major work",          "Medium"),
        ("No autonomous trading decisions delegated to AI",        "Critical"),
    ]

    ai_passed = []
    for label, priority in ai_checklist:
        pcolor = {"Critical": C_LOSS, "High": "#ffd600", "Medium": C_PRIMARY}.get(priority, "#546e7a")
        ai1, ai2, ai3 = st.columns([4, 1, 1])
        ai1.markdown(label)
        ai2.markdown(
            f"<span style='color:{pcolor};font-size:0.8rem'>{priority}</span>",
            unsafe_allow_html=True,
        )
        val = ai3.checkbox("", key=f"ai_{label[:20]}", label_visibility="collapsed")
        ai_passed.append((val, priority))

    critical_passed = sum(1 for v, p in ai_passed if v and p == "Critical")
    critical_total  = sum(1 for _, p in ai_passed if p == "Critical")
    all_passed      = sum(1 for v, _ in ai_passed if v)
    ai_score        = all_passed / len(ai_checklist) * 100

    ai_color = C_WIN if (ai_score >= 80 and critical_passed == critical_total) else (
        C_PRIMARY if ai_score >= 60 else C_LOSS
    )
    st.markdown(
        f"**AI Workflow Score: <span style='color:{ai_color}'>{ai_score:.0f}%</span>**  "
        f"Critical items: {critical_passed}/{critical_total}",
        unsafe_allow_html=True,
    )
    if critical_passed < critical_total:
        st.error("⚠️ Not all critical AI workflow standards are active.")


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — QUALITY DASHBOARD
# ══════════════════════════════════════════════════════════════════════════════
with tab_quality:
    st.subheader("📊 Principle Quality Dashboard")
    st.caption(
        "Overview of all principles by quality and confidence scores. "
        "Low-quality principles need more documentation. "
        "Low-confidence principles need more real-world validation."
    )

    all_df = get_principles(status="active")

    if all_df.empty:
        st.info("No active principles yet.")
    else:
        # Quality distribution bar chart
        all_df["quality_bin"] = pd.cut(
            all_df["quality_score"].fillna(0),
            bins=[0, 40, 60, 80, 100],
            labels=["0-40 (Poor)", "40-60 (OK)", "60-80 (Good)", "80-100 (Excellent)"],
        )
        bin_counts = all_df["quality_bin"].value_counts().sort_index()

        fig_quality = go.Figure(go.Bar(
            x=bin_counts.index.astype(str),
            y=bin_counts.values,
            marker_color=[C_LOSS, C_PRIMARY, "#ffd600", C_WIN],
            text=bin_counts.values, textposition="auto",
        ))
        fig_quality.update_layout(
            height=220, title="Quality Score Distribution",
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            xaxis=dict(gridcolor="#1e2130"), yaxis=dict(gridcolor="#1e2130"),
            margin=dict(l=0, r=0, t=40, b=0),
        )
        st.plotly_chart(fig_quality, use_container_width=True)

        # Coverage gap analysis
        st.divider()
        st.subheader("Coverage Gap Analysis")
        st.caption("Which mindset types are under-represented in the principle library?")

        all_types = list(MINDSET_TYPES.keys())
        type_counts = all_df["mindset_type"].value_counts().reindex(all_types, fill_value=0)
        type_avg_q  = all_df.groupby("mindset_type")["quality_score"].mean().reindex(all_types, fill_value=0)

        fig_coverage = go.Figure()
        fig_coverage.add_trace(go.Bar(
            name="Count",
            x=[MINDSET_TYPES.get(t, t) for t in all_types],
            y=type_counts.values,
            marker_color=[MINDSET_COLORS.get(t, "#546e7a") for t in all_types],
            text=type_counts.values, textposition="auto",
            yaxis="y",
        ))
        fig_coverage.add_trace(go.Scatter(
            name="Avg Quality",
            x=[MINDSET_TYPES.get(t, t) for t in all_types],
            y=type_avg_q.values,
            mode="lines+markers",
            marker=dict(color="#ffd600", size=8),
            line=dict(color="#ffd600", dash="dash"),
            yaxis="y2",
        ))
        fig_coverage.update_layout(
            height=300, title="Principles per Mindset Type + Average Quality",
            xaxis=dict(gridcolor="#1e2130", tickangle=-20, tickfont=dict(size=10)),
            yaxis =dict(title="Count",      gridcolor="#1e2130", side="left"),
            yaxis2=dict(title="Avg Quality", range=[0,100], overlaying="y", side="right"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            legend=dict(orientation="h", y=1.1),
            margin=dict(l=0, r=60, t=60, b=60),
        )
        st.plotly_chart(fig_coverage, use_container_width=True)

        # Principles needing attention (low quality OR high violation rate)
        st.divider()
        st.subheader("Principles Needing Attention")

        needs_work = all_df[
            (all_df["quality_score"] < 70) |
            (all_df["violation_count"] > 0)
        ].sort_values("quality_score")

        if needs_work.empty:
            st.success("All principles are well-documented and violation-free.")
        else:
            for _, p in needs_work.iterrows():
                _qs = p.get("quality_score", 0)
                _vc = int(p.get("violation_count", 0))
                issues = []
                if _qs < 70:
                    issues.append(f"Q:{_qs:.0f} (needs documentation)")
                if _vc > 0:
                    issues.append(f"{_vc} violation(s) logged")

                _mc = MINDSET_COLORS.get(p.get("mindset_type",""), "#546e7a")
                st.markdown(
                    f"- **{p['title']}** "
                    f"<span style='color:{_mc};font-size:0.8rem'>[{MINDSET_TYPES.get(p.get('mindset_type',''),'')}]</span>  \n"
                    f"  &nbsp;&nbsp;→ {' · '.join(issues)}",
                    unsafe_allow_html=True,
                )

        # Write all to vault button
        st.divider()
        if st.button("📝 Write All Active Principles to Vault"):
            written = 0
            for _, p in all_df.iterrows():
                path = write_principle_note(p["principle_id"])
                if path:
                    written += 1
            st.success(f"Written {written} principle notes to Obsidian vault.")

st.divider()
st.caption(
    "Full principle library and danger flag scanning: **📚 Principle Library** (page 22)  ·  "
    "The mindset system is designed to grow — add principles as you encounter new failure cases."
)
