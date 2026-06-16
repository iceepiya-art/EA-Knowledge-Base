from pathlib import Path

js_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\test_1.js")

def fix():
    js = js_path.read_text(encoding="utf-8")
    
    old_code = """  function renderMergeList(data) {
    // Recreated to prevent ReferenceError
  }"""

    new_code = """  function renderMergeList(data) {
    let e = data.extract||{}, m = data.merge||{}, d = data.dedup||{}, w = data.write||{}, c = data.detect||{}, ar = data.auto_resolve||{}, comp = data.ea_components||{}, bp = data.blueprint||{};
    setStepStatus('step-extract',    `${e.written??0} written`, 'var(--green)');
    setStepStatus('step-merge',      `${m.new??0} new`, 'var(--green)');
    setStepStatus('step-dedup',      `${d.removed??0} removed`, 'var(--green)');
    setStepStatus('step-write',      `${w.updated??0} updated`, 'var(--green)');
    setStepStatus('step-detect',     `${c.new??0} new`, 'var(--green)');
    setStepStatus('step-resolve',    `${ar.auto_resolved??0} resolved, ${ar.still_pending??0} pending`, ar.still_pending > 0 ? 'var(--yellow)' : 'var(--green)');
    setStepStatus('step-components', `${comp.total_rules??0} rules`, 'var(--green)');
    setStepStatus('step-blueprint',  bp.ea_readiness ?? 'done', 'var(--green)');
  }"""

    if old_code in js:
        js = js.replace(old_code, new_code)
        js_path.write_text(js, encoding="utf-8")
        print("Fixed renderMergeList!")
    else:
        print("old_code not found")

if __name__ == "__main__":
    fix()
