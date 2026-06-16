"""
5_Annotate.py — Fast Trade Annotation Workflow

Keyboard shortcuts (active when not typing in a text field):
  ← / →          Previous / Next trade
  1-6            Apply quick-tag preset and advance
  s              Save current form
  k              Skip to next (no save)
  a              Auto-tag session + regime for current trade

Tabs:
  Quick Review   — single-trade annotation with quick presets
  Bulk Ops       — apply tags to many trades + batch auto-tag + export
  Progress       — annotation coverage charts
  History        — full audit trail
"""

import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import plotly.express as px
import plotly.graph_objects as go
import pandas as pd
from datetime import date, timedelta
from pathlib import Path

import annotator as ann

st.set_page_config(
    page_title="Annotate — QTrade OS",
    page_icon="🏷",
    layout="wide",
)

# ══════════════════════════════════════════════════════════════════════════════
# KEYBOARD SHORTCUTS  (JS injected into page iframe)
# ══════════════════════════════════════════════════════════════════════════════

_KBD_JS = """
<script>
(function() {
  function click(text) {
    var btns = parent.document.querySelectorAll('button');
    for (var i = 0; i < btns.length; i++) {
      if (btns[i].innerText.trim().startsWith(text)) {
        btns[i].click(); return true;
      }
    }
    return false;
  }
  parent.document.addEventListener('keydown', function(e) {
    var tag = e.target ? e.target.tagName : '';
    if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return;
    if (e.key === 'ArrowLeft'  || e.key === 'p') { click('◀'); }
    if (e.key === 'ArrowRight' || e.key === 'n') { click('▶'); }
    if (e.key === 'k' || e.key === 'K')          { click('Skip'); }
    if (e.key === 's' || e.key === 'S')          { click('💾 Save'); }
    if (e.key === 'a' || e.key === 'A')          { click('Auto-Tag All'); }
    if (e.key === '1') { click('1 '); }
    if (e.key === '2') { click('2 '); }
    if (e.key === '3') { click('3 '); }
    if (e.key === '4') { click('4 '); }
    if (e.key === '5') { click('5 '); }
    if (e.key === '6') { click('6 '); }
  });
})();
</script>
"""
st.components.v1.html(_KBD_JS, height=0)

# ══════════════════════════════════════════════════════════════════════════════
# SESSION STATE DEFAULTS
# ══════════════════════════════════════════════════════════════════════════════

def _ss(key, default):
    if key not in st.session_state:
        st.session_state[key] = default

_ss("ann_idx",       0)
_ss("ann_trade_ids", [])
_ss("ann_df_list",   pd.DataFrame())
_ss("ann_save_msg",  None)
_ss("ann_save_ok",   None)
_ss("ann_preset",    None)

# ══════════════════════════════════════════════════════════════════════════════
# HEADER
# ══════════════════════════════════════════════════════════════════════════════

ann.run_migration()

prog    = ann.get_progress()
done    = prog["annotated"]
total   = prog["total"]
pct_done= done / total if total else 0

st.title("🏷 Annotation Workflow")

hcol1, hcol2, hcol3 = st.columns([5, 1, 1])
hcol1.progress(pct_done, text=f"Annotated: {done:,} / {total:,}  ({pct_done:.1%})")
hcol2.metric("Done", f"{done:,}")
hcol3.metric("Left", f"{prog['remaining']:,}")

st.divider()

tab_review, tab_bulk, tab_progress, tab_hist = st.tabs(
    ["✏ Quick Review", "📦 Bulk Ops", "📊 Progress", "📋 History"]
)

# ══════════════════════════════════════════════════════════════════════════════
# SHARED: load / reload filtered trade list
# ══════════════════════════════════════════════════════════════════════════════

def _reload_list(strategy, symbol, outcome, session_f, unann_only, search, d_from, d_to):
    df = ann.get_trades(
        strategy         = None if strategy == "All" else strategy,
        symbol           = None if symbol   == "All" else symbol,
        outcome          = None if outcome  == "All" else outcome,
        session          = None if session_f== "All" else session_f,
        unannotated_only = unann_only,
        search           = search or None,
        date_from        = str(d_from),
        date_to          = str(d_to),
    )
    st.session_state.ann_trade_ids = df["trade_id"].tolist()
    st.session_state.ann_df_list   = df
    st.session_state.ann_idx       = 0

# ══════════════════════════════════════════════════════════════════════════════
# TAB 1 — QUICK REVIEW
# ══════════════════════════════════════════════════════════════════════════════

with tab_review:
    col_left, col_right = st.columns([1, 2], gap="large")

    # ── LEFT — Filter + Trade List ─────────────────────────────────────────
    with col_left:
        st.markdown("##### Filter")

        search  = st.text_input("Search", placeholder="ID / notes / strategy", key="r_search")
        c1, c2  = st.columns(2)
        today   = date.today()
        d_from  = c1.date_input("From", today - timedelta(days=365), key="r_from")
        d_to    = c2.date_input("To",   today, key="r_to")

        strats  = ["All"] + ann.distinct_values("strategy")
        syms    = ["All"] + ann.distinct_values("symbol")
        outcomes= ["All", "WIN", "LOSS", "BREAKEVEN"]
        sessions= ["All"] + ann.distinct_values("session")

        sel_strat = st.selectbox("Strategy", strats,  key="r_strat")
        sel_sym   = st.selectbox("Symbol",   syms,    key="r_sym")

        fc1, fc2  = st.columns(2)
        sel_out   = fc1.selectbox("Outcome",  outcomes, key="r_out")
        sel_sess  = fc2.selectbox("Session",  sessions, key="r_sess")

        unann_only= st.toggle("Unannotated only", value=True, key="r_unann")

        if st.button("🔍 Apply Filter", use_container_width=True):
            _reload_list(sel_strat, sel_sym, sel_out, sel_sess,
                         unann_only, search, d_from, d_to)

        # Auto-load on first render
        if not st.session_state.ann_trade_ids:
            _reload_list(sel_strat, sel_sym, sel_out, sel_sess,
                         unann_only, search, d_from, d_to)

        df_list   = st.session_state.ann_df_list
        trade_ids = st.session_state.ann_trade_ids
        n_trades  = len(trade_ids)
        st.caption(f"**{n_trades:,}** trades match")

        # Clickable trade table
        if not df_list.empty:
            disp = df_list[["open_time","symbol","direction","outcome","pnl_usd"]].copy()
            disp["open_time"] = pd.to_datetime(disp["open_time"], errors="coerce") \
                                  .dt.strftime("%m-%d %H:%M")
            disp["pnl_usd"]   = disp["pnl_usd"].apply(
                lambda v: f"+{v:.0f}" if v > 0 else f"{v:.0f}"
            )
            disp.columns = ["Time","Sym","Dir","Out","PnL"]

            event = st.dataframe(
                disp, use_container_width=True, hide_index=True, height=420,
                on_select="rerun", selection_mode="single-row",
            )
            rows = event.selection.get("rows", []) if hasattr(event, "selection") else []
            if rows:
                st.session_state.ann_idx = rows[0]

    # ── RIGHT — Annotation Form ────────────────────────────────────────────
    with col_right:

        if not trade_ids:
            st.info("No trades match — adjust filters and click **Apply Filter**.")
            st.stop()

        idx      = max(0, min(st.session_state.ann_idx, n_trades - 1))
        trade_id = trade_ids[idx]
        trade    = ann.get_trade(trade_id)

        if not trade:
            st.error(f"Trade not found: {trade_id}")
            st.stop()

        # ── Navigation bar ─────────────────────────────────────────────────
        nb1, nb2, nb3, nb4, nb5 = st.columns([1, 1, 3, 1, 1])
        if nb1.button("◀ Prev", disabled=(idx == 0), use_container_width=True):
            st.session_state.ann_idx = idx - 1
            st.session_state.ann_save_msg = None
            st.rerun()
        if nb2.button("Skip ▷", use_container_width=True):
            st.session_state.ann_idx = min(idx + 1, n_trades - 1)
            st.session_state.ann_save_msg = None
            st.rerun()
        nb3.markdown(
            f"<div style='text-align:center;padding:7px 0;font-size:0.9rem;color:#8892b0'>"
            f"Trade <b>{idx+1:,}</b> of <b>{n_trades:,}</b></div>",
            unsafe_allow_html=True,
        )
        if nb4.button("▶ Next", disabled=(idx >= n_trades-1), use_container_width=True):
            st.session_state.ann_idx = idx + 1
            st.session_state.ann_save_msg = None
            st.rerun()
        if nb5.button("Detail", use_container_width=True):
            st.session_state.detail_trade_id  = trade_id
            st.session_state.detail_trade_ids = trade_ids  # pass full list for prev/next
            st.switch_page("pages/6_Trade.py")

        # ── Trade card ─────────────────────────────────────────────────────
        open_dt   = pd.to_datetime(trade.get("open_time",""), errors="coerce")
        close_dt  = pd.to_datetime(trade.get("close_time",""), errors="coerce")
        pnl       = trade.get("pnl_usd", 0) or 0
        pnl_color = "#26a69a" if pnl >= 0 else "#ef5350"
        pnl_sign  = "▲" if pnl >= 0 else "▼"
        out_color = "#26a69a" if trade.get("outcome")=="WIN" else "#ef5350" if trade.get("outcome")=="LOSS" else "#8892b0"
        dir_icon  = "🟢" if trade.get("direction")=="BUY" else "🔴"
        sc100     = trade.get("sc100_value")
        sc100_txt = f"SC₁₀₀={sc100:.3f}" if sc100 is not None else ""
        dur_min   = trade.get("duration_min")
        dur_txt   = f"{dur_min}m" if dur_min else ""

        st.markdown(f"""
<div style="background:#1e2130;border:1px solid #2d3147;border-radius:8px;
     padding:12px 16px;margin-bottom:10px">
  <div style="display:flex;justify-content:space-between;align-items:center">
    <div>
      <code style="font-size:0.72rem;color:#8892b0">{trade_id}</code><br>
      <span style="font-size:1.15rem;font-weight:700">
        {trade.get('symbol','?')} &nbsp;{dir_icon} {trade.get('direction','?')}
        &nbsp;&nbsp;
        <span style="color:{pnl_color}">{pnl_sign} ${abs(pnl):,.2f}</span>
        &nbsp;
        <span style="color:{out_color};font-size:0.95rem">{trade.get('outcome','')}</span>
      </span>
    </div>
    <div style="text-align:right;font-size:0.8rem;color:#8892b0">
      {open_dt.strftime('%Y-%m-%d %H:%M') if not pd.isna(open_dt) else '—'}<br>
      {close_dt.strftime('%H:%M') if not pd.isna(close_dt) else ''}
      {f'  ({dur_txt})' if dur_txt else ''}
    </div>
  </div>
  <div style="font-size:0.78rem;color:#8892b0;margin-top:6px">
    Strategy: <b style="color:#cdd6f4">{trade.get('strategy','—')}</b> &nbsp;|&nbsp;
    Session: <b style="color:#cdd6f4">{trade.get('session','—')}</b> &nbsp;|&nbsp;
    Regime: <b style="color:#cdd6f4">{trade.get('regime','—')}</b> &nbsp;|&nbsp;
    RR: <b style="color:#cdd6f4">{f"{trade.get('rr_planned',''):.1f}R" if trade.get('rr_planned') else '—'}</b>
    {f'&nbsp;|&nbsp; {sc100_txt}' if sc100_txt else ''}
  </div>
</div>""", unsafe_allow_html=True)

        # ── Save result message ────────────────────────────────────────────
        if st.session_state.ann_save_msg:
            fn = st.success if st.session_state.ann_save_ok else st.error
            fn(st.session_state.ann_save_msg)

        # ── QUICK-TAG PRESETS ──────────────────────────────────────────────
        st.markdown(
            "<div style='font-size:0.8rem;color:#8892b0;margin-bottom:4px'>"
            "Quick Tags &nbsp;<span style='opacity:0.5'>(keys 1–6, auto-saves and advances)</span>"
            "</div>",
            unsafe_allow_html=True,
        )
        qt_keys = ann.QUICK_TAG_KEYS
        qt_row1 = st.columns(3)
        qt_row2 = st.columns(3)
        qt_cols = qt_row1 + qt_row2
        for i, (col, tag_name) in enumerate(zip(qt_cols, qt_keys)):
            btn_label = f"{i+1} {tag_name}"
            if col.button(btn_label, use_container_width=True, key=f"qt_{i}"):
                ok, msg = ann.save_annotation(trade_id, dict(ann.QUICK_TAGS[tag_name]),
                                              annotator="quick_tag")
                st.session_state.ann_save_ok  = ok
                st.session_state.ann_save_msg = f"Quick: {tag_name} — {msg}"
                st.session_state.ann_preset   = tag_name
                if ok and idx < n_trades - 1:
                    st.session_state.ann_idx = idx + 1
                st.rerun()

        # ── AUTO-TAG ──────────────────────────────────────────────────────
        ac1, ac2, ac3 = st.columns(3)
        if ac1.button("Auto-Tag All", use_container_width=True, help="Session + Regime"):
            ok_s, msg_s = ann.auto_tag_session(trade_id)
            ok_r, msg_r = ann.auto_tag_regime(trade_id)
            combined    = f"Session: {msg_s}  |  Regime: {msg_r}"
            st.session_state.ann_save_msg = combined
            st.session_state.ann_save_ok  = ok_s or ok_r
            st.rerun()
        if ac2.button("Auto Session", use_container_width=True):
            ok, msg = ann.auto_tag_session(trade_id)
            st.session_state.ann_save_msg = msg
            st.session_state.ann_save_ok  = ok
            st.rerun()
        if ac3.button("Auto Regime", use_container_width=True,
                      help="Derives from SC100 value if available"):
            ok, msg = ann.auto_tag_regime(trade_id)
            st.session_state.ann_save_msg = msg
            st.session_state.ann_save_ok  = ok
            st.rerun()

        st.markdown("---")

        # ── ANNOTATION FORM ────────────────────────────────────────────────
        def _cur(field, default=None):
            v = trade.get(field)
            return default if (v is None or v == "") else v

        def _cur_idx(opts, field):
            v = _cur(field)
            return opts.index(v) if v in opts else 0

        with st.form(key=f"ann_{trade_id}", clear_on_submit=False):
            st.markdown("##### Annotation Fields")

            r1c1, r1c2, r1c3 = st.columns(3)
            setup_type   = r1c1.selectbox("Setup Type", [""]+ann.SETUP_TYPES,
                                           index=_cur_idx([""]+ann.SETUP_TYPES, "setup_type"))
            regime_field = r1c2.selectbox("Regime",     [""]+ann.REGIMES,
                                           index=_cur_idx([""]+ann.REGIMES, "regime"))
            session_bias = r1c3.selectbox("Session Bias",[""]+ann.SESSION_BIASES,
                                           index=_cur_idx([""]+ann.SESSION_BIASES, "session_bias"))

            r2c1, r2c2, r2c3 = st.columns(3)
            emotional    = r2c1.selectbox("Emotional State",[""]+ann.EMOTIONAL_STATES,
                                           index=_cur_idx([""]+ann.EMOTIONAL_STATES, "emotional_state"))
            entry_timing = r2c2.selectbox("Entry Timing",  [""]+ann.ENTRY_TIMINGS,
                                           index=_cur_idx([""]+ann.ENTRY_TIMINGS, "entry_timing"))
            exit_reason  = r2c3.selectbox("Exit Reason",   [""]+ann.EXIT_REASONS,
                                           index=_cur_idx([""]+ann.EXIT_REASONS, "exit_reason"))

            stored_mistakes = _cur("mistakes","")
            default_mistakes= [m for m in stored_mistakes.split("|") if m] if stored_mistakes else []
            mistakes = st.multiselect("Mistakes", ann.MISTAKES,
                                      default=[m for m in default_mistakes if m in ann.MISTAKES])

            sc1, sc2, sc3 = st.columns(3)
            exec_score    = sc1.slider("Execution Quality", 1, 10,
                                       int(_cur("execution_score", 5)))
            setup_quality = sc2.slider("Setup Quality", 1, 5,
                                       int(_cur("setup_quality", 3)))
            confidence    = sc3.slider("Confidence Level", 1, 5,
                                       int(_cur("confidence_level", 3)))

            pc1, pc2 = st.columns(2)
            stored_plan = _cur("plan_followed")
            plan_default= 0 if stored_plan == 1 else 1
            plan_label  = pc1.radio("Plan Followed", ["Yes","No"],
                                    index=plan_default, horizontal=True)
            notes       = pc2.text_area("Notes", value=_cur("notes",""),
                                        height=70, placeholder="Post-trade reflection…")

            fs1, fs2, fs3 = st.columns([3, 1, 1])
            submitted = fs1.form_submit_button("💾 Save Annotation",
                                               type="primary", use_container_width=True)
            skip_btn  = fs2.form_submit_button("Skip",  use_container_width=True)
            clear_btn = fs3.form_submit_button("Clear", use_container_width=True)

            if submitted:
                fields = dict(
                    setup_type      = setup_type      or None,
                    regime          = regime_field    or None,
                    session_bias    = session_bias    or None,
                    emotional_state = emotional       or None,
                    entry_timing    = entry_timing    or None,
                    exit_reason     = exit_reason     or None,
                    mistakes        = mistakes,
                    execution_score = exec_score,
                    setup_quality   = setup_quality,
                    confidence_level= confidence,
                    plan_followed   = 1 if plan_label == "Yes" else 0,
                    notes           = notes or None,
                )
                ok, msg = ann.save_annotation(trade_id, fields)
                st.session_state.ann_save_ok  = ok
                st.session_state.ann_save_msg = msg
                if ok and idx < n_trades - 1:
                    st.session_state.ann_idx = idx + 1
                st.rerun()

            if skip_btn:
                st.session_state.ann_idx = min(idx + 1, n_trades - 1)
                st.session_state.ann_save_msg = None
                st.rerun()

            if clear_btn:
                clear_fields = {k: None for k in [
                    "setup_type","regime","session_bias","emotional_state",
                    "entry_timing","exit_reason","mistakes","execution_score",
                    "setup_quality","confidence_level","plan_followed","notes",
                ]}
                ok, msg = ann.save_annotation(trade_id, clear_fields)
                st.session_state.ann_save_ok  = ok
                st.session_state.ann_save_msg = "Fields cleared" if ok else msg
                st.rerun()

        # ── SCREENSHOT PANEL ───────────────────────────────────────────────
        with st.expander("📸 Screenshot", expanded=bool(trade.get("screenshot_path"))):
            existing_path = trade.get("screenshot_path")
            base = Path(_ROOT)

            if existing_path:
                full_path = base / existing_path
                if full_path.exists():
                    st.image(str(full_path), use_container_width=True)
                    st.caption(f"Linked: `{existing_path}`")
                    if st.button("Unlink screenshot", key="unlink_ss"):
                        ann.link_screenshot(trade_id, None)
                        st.rerun()
                else:
                    st.warning(f"File not found: `{existing_path}`")

            # Auto-discover nearby files
            date_str = str(trade.get("open_time",""))[:10]
            symbol   = trade.get("symbol","")
            nearby   = ann.find_screenshots_for_trade(symbol, date_str)

            if nearby:
                st.markdown(f"**{len(nearby)} file(s) found for {date_str}:**")
                ss_choice = st.selectbox("Select to link",
                                         ["— none —"] + [f.name for f in nearby],
                                         key="ss_pick")
                if ss_choice != "— none —" and st.button("Link this file", key="link_ss"):
                    chosen = next(f for f in nearby if f.name == ss_choice)
                    rel    = str(chosen.relative_to(base))
                    ann.link_screenshot(trade_id, rel)
                    st.success(f"Linked: {rel}")
                    st.rerun()
            else:
                st.caption("No screenshots found in JOURNAL/screenshots/ for this date.")

            manual = st.text_input("Or paste relative path (from EA-Knowledge-Base/)", key="ss_manual")
            if manual and st.button("Link path", key="link_manual"):
                ann.link_screenshot(trade_id, manual.strip())
                st.success(f"Linked: {manual}")
                st.rerun()

        # ── ANNOTATION HISTORY (inline) ────────────────────────────────────
        with st.expander("📋 History for this trade"):
            h = ann.get_history(trade_id=trade_id, limit=30)
            if h.empty:
                st.caption("No changes logged yet.")
            else:
                h["annotated_at"] = h["annotated_at"].dt.strftime("%Y-%m-%d %H:%M")
                st.dataframe(h, use_container_width=True, hide_index=True, height=200)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 2 — BULK OPS
# ══════════════════════════════════════════════════════════════════════════════

with tab_bulk:
    st.markdown("#### Bulk Operations")

    bulk_df   = st.session_state.ann_df_list
    n_filtered= len(bulk_df)

    b_col1, b_col2 = st.columns(2, gap="large")

    # ── Bulk Auto-Tag ──────────────────────────────────────────────────────
    with b_col1:
        st.markdown("##### Batch Auto-Tag")
        st.caption(
            "Derives session from open_time and regime from SC₁₀₀ value. "
            "Only updates trades that are missing the field."
        )
        at_strategy = st.selectbox("Strategy (blank = all)",
                                   ["All"] + ann.distinct_values("strategy"),
                                   key="at_strat")
        at_fields   = st.multiselect("Fields to auto-tag",
                                     ["session","regime"], default=["regime"])
        if st.button("Run Batch Auto-Tag", type="primary"):
            with st.spinner("Processing…"):
                r = ann.batch_auto_tag(
                    fields   = at_fields or ["regime"],
                    strategy = None if at_strategy == "All" else at_strategy,
                )
            st.success(
                f"Session: {r.get('session',0)} tagged  |  "
                f"Regime: {r.get('regime',0)} tagged  |  "
                f"Errors: {r.get('errors',0)}"
            )
            st.cache_data.clear()

    # ── Export ─────────────────────────────────────────────────────────────
    with b_col2:
        st.markdown("##### Export Annotations")
        st.caption("Exports all trades with at least one annotation field filled.")
        if st.button("Export to CSV"):
            with st.spinner("Exporting…"):
                n_rows, out_path = ann.export_annotations()
            st.success(f"Exported {n_rows:,} trades → `{out_path}`")

    st.divider()

    # ── Bulk Form Tag ──────────────────────────────────────────────────────
    st.markdown("##### Bulk Tag — Apply to Filtered Trades")
    st.caption(
        f"{n_filtered:,} trades from current filter. "
        "Leave a field blank to skip it. Only non-empty values are applied."
    )

    if bulk_df.empty:
        st.info("Apply filters in Quick Review tab first.")
    else:
        b_mode = st.radio("Apply to:", ["All filtered trades","Selected trades only"],
                          horizontal=True)
        sel_ids = []
        if b_mode == "Selected trades only":
            display_map = dict(zip(
                bulk_df["trade_id"],
                bulk_df.get("display", bulk_df["trade_id"])
            ))
            chosen = st.multiselect("Select trades", bulk_df["trade_id"].tolist(),
                                    format_func=lambda t: display_map.get(t, t))
            sel_ids = chosen
        else:
            sel_ids = bulk_df["trade_id"].tolist()

        st.caption(f"Will apply to **{len(sel_ids):,}** trades")

        with st.form("bulk_tag_form"):
            bc1, bc2, bc3 = st.columns(3)
            b_setup    = bc1.selectbox("Setup Type",    [""]+ann.SETUP_TYPES)
            b_regime   = bc2.selectbox("Regime",        [""]+ann.REGIMES)
            b_session_b= bc3.selectbox("Session Bias",  [""]+ann.SESSION_BIASES)

            bc4, bc5, bc6 = st.columns(3)
            b_emotion  = bc4.selectbox("Emotional State",[""]+ann.EMOTIONAL_STATES)
            b_timing   = bc5.selectbox("Entry Timing",  [""]+ann.ENTRY_TIMINGS)
            b_exit     = bc6.selectbox("Exit Reason",   [""]+ann.EXIT_REASONS)

            b_mistakes = st.multiselect("Mistakes", ann.MISTAKES)

            bc7, bc8, bc9 = st.columns(3)
            b_exec_on  = bc7.checkbox("Set Execution Quality")
            b_exec     = bc7.slider("", 1, 10, 5, disabled=not b_exec_on, key="bk_exec")
            b_sq_on    = bc8.checkbox("Set Setup Quality")
            b_sq       = bc8.slider("", 1, 5, 3, disabled=not b_sq_on, key="bk_sq")
            b_conf_on  = bc9.checkbox("Set Confidence")
            b_conf     = bc9.slider("", 1, 5, 3, disabled=not b_conf_on, key="bk_conf")

            b_plan     = st.radio("Plan Followed", ["— skip —","Yes","No"],
                                  horizontal=True, index=0)

            apply_btn  = st.form_submit_button(
                f"📦 Apply to {len(sel_ids):,} trades",
                type="primary", use_container_width=True,
            )

            if apply_btn:
                if not sel_ids:
                    st.warning("No trades selected.")
                else:
                    bulk_fields = dict(
                        setup_type      = b_setup     or None,
                        regime          = b_regime    or None,
                        session_bias    = b_session_b or None,
                        emotional_state = b_emotion   or None,
                        entry_timing    = b_timing    or None,
                        exit_reason     = b_exit      or None,
                        mistakes        = b_mistakes  or None,
                        execution_score = b_exec if b_exec_on else None,
                        setup_quality   = b_sq   if b_sq_on   else None,
                        confidence_level= b_conf if b_conf_on else None,
                        plan_followed   = (1 if b_plan=="Yes" else 0) if b_plan != "— skip —" else None,
                    )
                    count, msg = ann.bulk_annotate(sel_ids, bulk_fields)
                    if count > 0:
                        st.success(f"✅ {msg}")
                        st.cache_data.clear()
                    else:
                        st.warning(msg)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 3 — PROGRESS
# ══════════════════════════════════════════════════════════════════════════════

with tab_progress:
    st.markdown("#### Annotation Coverage")

    pr1, pr2 = st.columns(2, gap="large")

    # ── Donut: overall progress ────────────────────────────────────────────
    with pr1:
        st.markdown("##### Overall")
        fig_donut = go.Figure(go.Pie(
            labels=["Annotated","Remaining"],
            values=[done, prog["remaining"]],
            hole=0.6,
            marker_colors=["#26a69a","#2d3147"],
            textinfo="percent",
        ))
        fig_donut.update_layout(
            height=260, showlegend=True,
            paper_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=0,t=0,b=0),
            font={"color":"#cdd6f4"},
            annotations=[{"text":f"{pct_done:.0%}","x":0.5,"y":0.5,
                          "font_size":28,"showarrow":False,"font_color":"#cdd6f4"}],
        )
        st.plotly_chart(fig_donut, use_container_width=True)

    # ── Field coverage bar ─────────────────────────────────────────────────
    with pr2:
        st.markdown("##### Field Coverage")
        cov_df = ann.get_field_coverage()
        colors = ["#26a69a" if p >= 50 else "#ffd600" if p >= 10 else "#ef5350"
                  for p in cov_df["pct"]]
        fig_cov = go.Figure(go.Bar(
            x=cov_df["pct"], y=cov_df["field"],
            orientation="h",
            marker_color=colors,
            text=cov_df["pct"].apply(lambda v: f"{v:.0f}%"),
            textposition="outside",
        ))
        fig_cov.update_layout(
            height=320, xaxis=dict(range=[0,115], title="%", color="#8892b0"),
            yaxis=dict(color="#8892b0"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=60,t=0,b=0), showlegend=False,
        )
        st.plotly_chart(fig_cov, use_container_width=True)

    st.divider()

    # ── Progress by group ──────────────────────────────────────────────────
    group_by = st.radio("Group by:", ["strategy","symbol","session","outcome"],
                        horizontal=True, index=0)
    prog_df  = ann.get_progress_by(group_by)

    if not prog_df.empty:
        fig_grp = go.Figure()
        fig_grp.add_trace(go.Bar(
            name="Annotated", x=prog_df["group_name"], y=prog_df["annotated"],
            marker_color="#26a69a",
        ))
        fig_grp.add_trace(go.Bar(
            name="Unannotated",
            x=prog_df["group_name"],
            y=prog_df["total"] - prog_df["annotated"],
            marker_color="#2d3147",
        ))
        fig_grp.update_layout(
            barmode="stack", height=300,
            xaxis=dict(color="#8892b0"), yaxis=dict(title="Trades", color="#8892b0"),
            paper_bgcolor="rgba(0,0,0,0)", plot_bgcolor="rgba(0,0,0,0)",
            margin=dict(l=0,r=0,t=0,b=0),
            legend=dict(font=dict(color="#cdd6f4")),
        )
        st.plotly_chart(fig_grp, use_container_width=True)

        # Table with detail
        prog_disp = prog_df.rename(columns={
            "group_name": group_by.title(),
            "total":"Total","annotated":"Annotated",
            "has_setup":"Has Setup","has_regime":"Has Regime",
            "has_mistakes":"Has Mistakes","has_exec_score":"Has ExecScore",
            "pct_annotated":"% Done",
        })
        st.dataframe(prog_disp, use_container_width=True, hide_index=True)


# ══════════════════════════════════════════════════════════════════════════════
# TAB 4 — HISTORY
# ══════════════════════════════════════════════════════════════════════════════

with tab_hist:
    st.markdown("#### Annotation Audit Trail")

    hf1, hf2, hf3 = st.columns(3)
    h_tid   = hf1.text_input("Trade ID filter", placeholder="Leave blank for all")
    h_field = hf2.selectbox("Field", ["All"] + sorted(ann.ANNOTATION_FIELDS))
    h_lim   = hf3.number_input("Max rows", 50, 1000, 200, step=50)

    df_h = ann.get_history(
        trade_id = h_tid.strip() or None,
        field    = None if h_field == "All" else h_field,
        limit    = int(h_lim),
    )

    if df_h.empty:
        st.info("No annotation history yet.")
    else:
        st.caption(f"Showing {len(df_h):,} records")
        df_h["annotated_at"] = df_h["annotated_at"].dt.strftime("%Y-%m-%d %H:%M:%S")
        df_h.columns = ["When","Trade ID","Field","Old","New","By"]

        _ANNOTATOR_COLOR = {"quick_tag":"#5c6bc0","bulk":"#ffd600","human":"#26a69a"}

        st.dataframe(
            df_h.style.map(
                lambda v: f"color:{_ANNOTATOR_COLOR.get(v,'#cdd6f4')}",
                subset=["By"]
            ),
            use_container_width=True, hide_index=True, height=450,
        )

        # Summary chips
        sc1, sc2, sc3 = st.columns(3)
        sc1.metric("Changes Logged", f"{len(df_h):,}")
        if "Field" in df_h.columns and len(df_h) > 0:
            sc2.metric("Most Changed", df_h["Field"].value_counts().idxmax())
        if "By" in df_h.columns:
            bycnt = df_h["By"].value_counts()
            sc3.metric("Quick / Bulk / Manual",
                       f"{bycnt.get('quick_tag',0)} / {bycnt.get('bulk',0)} / {bycnt.get('human',0)}")
