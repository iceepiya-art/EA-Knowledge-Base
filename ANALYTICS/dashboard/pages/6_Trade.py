"""
6_Trade.py — Trade Detail Page

Full single-trade view with editable annotation form, screenshot
management, annotation history, and prev/next navigation.

Entered via: st.session_state.detail_trade_id = "<trade_id>"
             st.switch_page("pages/6_Trade.py")
"""

import sys, os
_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
_CORE = os.path.join(_ROOT, "ANALYTICS", "core")
if _CORE not in sys.path:
    sys.path.insert(0, _CORE)

import streamlit as st
import pandas as pd
from pathlib import Path

import annotator as ann

st.set_page_config(
    page_title="Trade Detail — QTrade OS",
    page_icon="🔍",
    layout="wide",
)

# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _ss(key, default):
    if key not in st.session_state:
        st.session_state[key] = default

_ss("detail_trade_id", None)
_ss("detail_trade_ids", [])   # ordered list for prev/next (from Annotate page)
_ss("detail_msg",      None)
_ss("detail_ok",       None)

def _fmt_pnl(v) -> str:
    try:
        f = float(v)
        return f"+${f:,.2f}" if f >= 0 else f"-${abs(f):,.2f}"
    except Exception:
        return str(v) if v is not None else "—"

def _color_pnl(v) -> str:
    try:
        return "#26a69a" if float(v) >= 0 else "#ef5350"
    except Exception:
        return "#aaaaaa"

def _val(d: dict, key: str, fallback="—"):
    v = d.get(key)
    return fallback if (v is None or str(v).strip() == "") else v

def _int_or_none(v):
    try: return int(v)
    except Exception: return None

def _float_or_none(v):
    try: return float(v)
    except Exception: return None

# ══════════════════════════════════════════════════════════════════════════════
# LOAD TRADE
# ══════════════════════════════════════════════════════════════════════════════

trade_id = st.session_state.detail_trade_id

if not trade_id:
    st.warning("No trade selected. Go back to the Annotate page and click **Detail**.")
    if st.button("← Back to Annotate"):
        st.switch_page("pages/5_Annotate.py")
    st.stop()

trade = ann.get_trade(trade_id)
if not trade:
    st.error(f"Trade `{trade_id}` not found in database.")
    if st.button("← Back to Annotate"):
        st.switch_page("pages/5_Annotate.py")
    st.stop()

ann.run_migration()

# ══════════════════════════════════════════════════════════════════════════════
# PREV / NEXT NAVIGATION
# ══════════════════════════════════════════════════════════════════════════════

trade_ids = st.session_state.detail_trade_ids
cur_pos   = trade_ids.index(trade_id) if trade_id in trade_ids else -1
has_prev  = cur_pos > 0
has_next  = 0 <= cur_pos < len(trade_ids) - 1

def _go(idx):
    st.session_state.detail_trade_id = trade_ids[idx]
    st.session_state.detail_msg = None

# ── Header bar ─────────────────────────────────────────────────────────────
hc1, hc2, hc3 = st.columns([1, 6, 1])

with hc1:
    if st.button("← Annotate", use_container_width=True):
        st.switch_page("pages/5_Annotate.py")

with hc2:
    pnl_val = trade.get("pnl_usd", 0) or 0
    outcome = trade.get("outcome", "")
    symbol  = trade.get("symbol", "")
    direction = trade.get("direction", "")
    open_time_raw = trade.get("open_time", "")
    try:
        open_dt = pd.to_datetime(open_time_raw)
        open_fmt = open_dt.strftime("%Y-%m-%d  %H:%M")
    except Exception:
        open_fmt = str(open_time_raw)

    pnl_color = _color_pnl(pnl_val)
    st.markdown(
        f"### 🔍 {symbol} &nbsp; {direction} &nbsp; "
        f"<span style='color:{pnl_color};font-weight:700'>{_fmt_pnl(pnl_val)}</span>"
        f"&nbsp;&nbsp; <span style='font-size:0.85em;color:#aaa'>{open_fmt}</span>",
        unsafe_allow_html=True,
    )

with hc3:
    nc1, nc2 = st.columns(2)
    if nc1.button("◀", disabled=not has_prev, use_container_width=True, help="Previous trade"):
        _go(cur_pos - 1)
        st.rerun()
    if nc2.button("▶", disabled=not has_next, use_container_width=True, help="Next trade"):
        _go(cur_pos + 1)
        st.rerun()

if cur_pos >= 0:
    st.caption(f"Trade {cur_pos + 1} of {len(trade_ids)} in current filter")

# Save message banner
if st.session_state.detail_msg:
    if st.session_state.detail_ok:
        st.success(st.session_state.detail_msg)
    else:
        st.error(st.session_state.detail_msg)
    st.session_state.detail_msg = None

st.divider()

# ══════════════════════════════════════════════════════════════════════════════
# MAIN LAYOUT
# ══════════════════════════════════════════════════════════════════════════════

left_col, right_col = st.columns([1, 1], gap="large")

# ── LEFT: Trade Facts ───────────────────────────────────────────────────────
with left_col:

    st.markdown("#### Trade Facts")

    # Core identity
    with st.container(border=True):
        r1c1, r1c2, r1c3 = st.columns(3)
        r1c1.metric("Symbol",    _val(trade, "symbol"))
        r1c2.metric("Direction", _val(trade, "direction"))
        r1c3.metric("Strategy",  _val(trade, "strategy"))

        r2c1, r2c2, r2c3 = st.columns(3)
        r2c1.metric("Outcome",   _val(trade, "outcome"))
        r2c2.metric("Session",   _val(trade, "session"))
        r2c3.metric("Regime",    _val(trade, "regime"))

    # P&L block
    with st.container(border=True):
        pc1, pc2, pc3, pc4 = st.columns(4)
        pc1.metric("PnL (USD)",  _fmt_pnl(trade.get("pnl_usd")))
        pc2.metric("PnL (pips)", _val(trade, "pnl_pips"))
        pc3.metric("RR Actual",  _val(trade, "rr_actual"))
        pc4.metric("RR Planned", _val(trade, "rr_planned"))

    # Timing block
    with st.container(border=True):
        tc1, tc2, tc3 = st.columns(3)
        tc1.metric("Open",     open_fmt)
        close_raw = trade.get("close_time", "")
        try:
            close_fmt = pd.to_datetime(close_raw).strftime("%Y-%m-%d  %H:%M")
        except Exception:
            close_fmt = str(close_raw) if close_raw else "—"
        tc2.metric("Close",    close_fmt)
        tc3.metric("Duration", _val(trade, "duration_min", "—") and
                   f"{_val(trade, 'duration_min', '—')} min")

    # Price block
    with st.container(border=True):
        ec1, ec2, ec3, ec4 = st.columns(4)
        ec1.metric("Entry",    _val(trade, "entry_price"))
        ec2.metric("Close",    _val(trade, "close_price"))
        ec3.metric("SL",       _val(trade, "sl_price"))
        ec4.metric("TP",       _val(trade, "tp_price"))

    # Size & SC₁₀₀ block
    with st.container(border=True):
        sc1, sc2, sc3, sc4 = st.columns(4)
        sc1.metric("Lot Size",  _val(trade, "lot_size"))
        sc2.metric("SC₁₀₀",    _val(trade, "sc100_value"))
        sc3.metric("β₁",       _val(trade, "beta1_value"))
        sc4.metric("Trade ID",  trade_id)

    # Screenshot panel
    st.markdown("#### Screenshot")

    linked_path = trade.get("screenshot_path")
    ss_date = ""
    try:
        ss_date = pd.to_datetime(open_time_raw).strftime("%Y-%m-%d")
    except Exception:
        pass

    auto_shots = ann.find_screenshots_for_trade(symbol, ss_date)

    if linked_path:
        abs_linked = ann.BASE_DIR / linked_path
        if abs_linked.exists():
            st.image(str(abs_linked), use_container_width=True)
            st.caption(f"Linked: `{linked_path}`")
            if st.button("Unlink Screenshot", key="btn_unlink"):
                ok, msg = ann.save_annotation(trade_id, {"screenshot_path": None})
                st.session_state.detail_ok  = ok
                st.session_state.detail_msg = msg
                st.rerun()
        else:
            st.warning(f"Linked path not found: `{linked_path}`")
    else:
        st.caption("No screenshot linked.")

    if auto_shots:
        with st.expander(f"Auto-discovered screenshots ({len(auto_shots)} file(s))", expanded=not linked_path):
            for img_path in auto_shots:
                rel = str(img_path.relative_to(ann.BASE_DIR))
                col_img, col_btn = st.columns([4, 1])
                col_img.image(str(img_path), use_container_width=True)
                if col_btn.button("Link", key=f"link_{rel}"):
                    ok, msg = ann.link_screenshot(trade_id, rel)
                    st.session_state.detail_ok  = ok
                    st.session_state.detail_msg = msg
                    st.rerun()

    with st.expander("Link a screenshot manually"):
        manual_path = st.text_input(
            "Relative path from vault root",
            placeholder="JOURNAL/screenshots/2026/05/10/xauusd_001.png",
            key="manual_ss_path",
        )
        if st.button("Link", key="btn_link_manual") and manual_path.strip():
            ok, msg = ann.link_screenshot(trade_id, manual_path.strip())
            st.session_state.detail_ok  = ok
            st.session_state.detail_msg = msg
            st.rerun()


# ── RIGHT: Annotation Form ─────────────────────────────────────────────────
with right_col:

    st.markdown("#### Annotation")

    # Quick-tag presets
    st.caption("Quick presets — saves immediately")
    preset_cols = st.columns(3)
    for i, (label, fields) in enumerate(ann.QUICK_TAGS.items()):
        col = preset_cols[i % 3]
        if col.button(f"{i+1} {label}", use_container_width=True, key=f"qt_{i}"):
            ok, msg = ann.save_annotation(trade_id, dict(fields))
            st.session_state.detail_ok  = ok
            st.session_state.detail_msg = f"Quick tag '{label}': {msg}"
            st.rerun()

    st.divider()

    # Full annotation form
    with st.form("detail_annotation_form", border=False):

        # Setup
        cur_setup = trade.get("setup_type") or ""
        setup_idx = ann.SETUP_TYPES.index(cur_setup) if cur_setup in ann.SETUP_TYPES else 0
        f_setup = st.selectbox("Setup Type", ann.SETUP_TYPES, index=setup_idx)

        fc1, fc2 = st.columns(2)

        # Regime
        cur_regime = trade.get("regime") or ""
        reg_idx = ann.REGIMES.index(cur_regime) if cur_regime in ann.REGIMES else 0
        f_regime = fc1.selectbox("Regime", ann.REGIMES, index=reg_idx)

        # Session bias
        cur_sb = trade.get("session_bias") or ""
        sb_idx = ann.SESSION_BIASES.index(cur_sb) if cur_sb in ann.SESSION_BIASES else 0
        f_session_bias = fc2.selectbox("Session Bias", ann.SESSION_BIASES, index=sb_idx)

        # Emotional state
        cur_emo = trade.get("emotional_state") or ""
        emo_idx = ann.EMOTIONAL_STATES.index(cur_emo) if cur_emo in ann.EMOTIONAL_STATES else 0
        f_emo = st.selectbox("Emotional State", ann.EMOTIONAL_STATES, index=emo_idx)

        sc1, sc2, sc3 = st.columns(3)
        f_exec    = sc1.slider("Execution Score",   1, 10, int(trade.get("execution_score") or 5))
        f_setup_q = sc2.slider("Setup Quality",     1, 5,  int(trade.get("setup_quality")  or 3))
        f_conf    = sc3.slider("Confidence Level",  1, 5,  int(trade.get("confidence_level") or 3))

        fc3, fc4 = st.columns(2)

        # Entry timing
        cur_et = trade.get("entry_timing") or ""
        et_idx = ann.ENTRY_TIMINGS.index(cur_et) if cur_et in ann.ENTRY_TIMINGS else 0
        f_entry_timing = fc3.selectbox("Entry Timing", ann.ENTRY_TIMINGS, index=et_idx)

        # Exit reason
        cur_ex = trade.get("exit_reason") or ""
        ex_idx = ann.EXIT_REASONS.index(cur_ex) if cur_ex in ann.EXIT_REASONS else 0
        f_exit_reason = fc4.selectbox("Exit Reason", ann.EXIT_REASONS, index=ex_idx)

        # Plan followed
        f_plan = st.toggle("Plan Followed", value=bool(trade.get("plan_followed", 1)))

        # Mistakes multiselect
        cur_mistakes_raw = trade.get("mistakes") or ""
        cur_mistakes = [m for m in cur_mistakes_raw.split("|") if m] if cur_mistakes_raw else []
        f_mistakes = st.multiselect("Mistakes", ann.MISTAKES, default=cur_mistakes)

        # Notes
        f_notes = st.text_area("Notes", value=trade.get("notes") or "", height=120,
                               placeholder="Setup context, market conditions, lessons learned…")

        save_btn = st.form_submit_button("💾 Save Annotation", use_container_width=True,
                                         type="primary")

    if save_btn:
        fields = {
            "setup_type":      f_setup,
            "regime":          f_regime,
            "session_bias":    f_session_bias,
            "emotional_state": f_emo,
            "execution_score": f_exec,
            "setup_quality":   f_setup_q,
            "confidence_level":f_conf,
            "entry_timing":    f_entry_timing,
            "exit_reason":     f_exit_reason,
            "plan_followed":   int(f_plan),
            "mistakes":        f_mistakes,
            "notes":           f_notes.strip() or None,
        }
        ok, msg = ann.save_annotation(trade_id, fields)
        st.session_state.detail_ok  = ok
        st.session_state.detail_msg = msg
        st.rerun()

    # Auto-tag buttons
    st.divider()
    at1, at2 = st.columns(2)
    if at1.button("Auto-Tag Session", use_container_width=True):
        ok, msg = ann.auto_tag_session(trade_id)
        st.session_state.detail_ok  = ok
        st.session_state.detail_msg = msg
        st.rerun()
    if at2.button("Auto-Tag Regime", use_container_width=True):
        ok, msg = ann.auto_tag_regime(trade_id)
        st.session_state.detail_ok  = ok
        st.session_state.detail_msg = msg
        st.rerun()

    # ── Annotation History ─────────────────────────────────────────────────
    st.divider()
    st.markdown("#### Annotation History")

    hist = ann.get_history(trade_id=trade_id, limit=50)
    if hist.empty:
        st.caption("No changes recorded yet.")
    else:
        hist_disp = hist[["annotated_at", "field_name", "old_value", "new_value", "annotator"]].copy()
        hist_disp["annotated_at"] = hist_disp["annotated_at"].dt.strftime("%Y-%m-%d %H:%M")
        hist_disp.columns = ["When", "Field", "Old", "New", "By"]
        st.dataframe(hist_disp, use_container_width=True, hide_index=True, height=240)

# ══════════════════════════════════════════════════════════════════════════════
# FULL TRADE DATA EXPANDER
# ══════════════════════════════════════════════════════════════════════════════

with st.expander("All DB fields (raw)", expanded=False):
    rows = [{"Field": k, "Value": str(v) if v is not None else ""} for k, v in trade.items()]
    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True, height=400)
