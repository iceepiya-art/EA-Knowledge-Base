from pathlib import Path

js_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\test_1.js")

def fix_test1():
    js = js_path.read_text(encoding="utf-8", errors="ignore")
    
    old_code = """  function renderMergeList(data) {
            ar = data.auto_resolve||{}, comp = data.ea_components||{}, bp = data.blueprint||{};
      setStepStatus('step-extract',    `${e.written??0} written`, 'var(--green)');
      setStepStatus('step-merge',      `${m.new??0} new`, 'var(--green)');
      setStepStatus('step-dedup',      `${d.removed??0} removed`, 'var(--green)');
      setStepStatus('step-write',      `${w.updated??0} updated`, 'var(--green)');
      setStepStatus('step-detect',     `${c.new??0} new`, 'var(--green)');
      setStepStatus('step-resolve',    `${ar.auto_resolved??0} resolved, ${ar.still_pending??0} pending`, ar.still_pending > 0 ? 'var(--yellow)' : 'var(--green)');
      setStepStatus('step-components', `${comp.total_rules??0} rules`, 'var(--green)');
      setStepStatus('step-blueprint',  bp.ea_readiness ?? 'done', 'var(--green)');
      setStepStatus('step-pipeline',   'Done 8/8', 'var(--green)');
      resultEl.innerHTML = _pipelineResultHtml(0, 0, data);
      toast('success', 'Pipeline complete — 8/8 steps done!');
      await loadStatus();
      await loadConflicts();
    } catch (e) {
      setStepStatus('step-pipeline', 'Error', 'var(--red)');
      resultEl.innerHTML = `<span style="color:var(--red)">Error: ${e.message}</span>`;
      toast('error', `Pipeline error: ${e.message}`);
    } finally {
      setLoading('btn-pipeline', false);
      setLoading('btn-refresh', false);
    }
  }"""

    new_code = """  async function runFullPipeline() {
    setLoading('btn-pipeline', true);
    setLoading('btn-refresh', true);
    const resultEl = document.getElementById('pipeline-result');
    if (resultEl) resultEl.innerHTML = 'Running full pipeline...';
    
    try {
      const data = await apiFetch('POST', '/api/learning/pipeline/run');
      let e = data.extract||{}, m = data.merge||{}, d = data.dedup||{}, w = data.write||{}, c = data.detect||{}, ar = data.auto_resolve||{}, comp = data.ea_components||{}, bp = data.blueprint||{};
      setStepStatus('step-extract',    `${e.written??0} written`, 'var(--green)');
      setStepStatus('step-merge',      `${m.new??0} new`, 'var(--green)');
      setStepStatus('step-dedup',      `${d.removed??0} removed`, 'var(--green)');
      setStepStatus('step-write',      `${w.updated??0} updated`, 'var(--green)');
      setStepStatus('step-detect',     `${c.new??0} new`, 'var(--green)');
      setStepStatus('step-resolve',    `${ar.auto_resolved??0} resolved, ${ar.still_pending??0} pending`, ar.still_pending > 0 ? 'var(--yellow)' : 'var(--green)');
      setStepStatus('step-components', `${comp.total_rules??0} rules`, 'var(--green)');
      setStepStatus('step-blueprint',  bp.ea_readiness ?? 'done', 'var(--green)');
      setStepStatus('step-pipeline',   'Done 8/8', 'var(--green)');
      if (resultEl) resultEl.innerHTML = _pipelineResultHtml(0, 0, data);
      toast('success', 'Pipeline complete — 8/8 steps done!');
      await loadStatus();
      await loadConflicts();
    } catch (err) {
      setStepStatus('step-pipeline', 'Error', 'var(--red)');
      if (resultEl) resultEl.innerHTML = `<span style="color:var(--red)">Error: ${err.message}</span>`;
      toast('error', `Pipeline error: ${err.message}`);
    } finally {
      setLoading('btn-pipeline', false);
      setLoading('btn-refresh', false);
    }
  }"""

    if old_code in js:
        js = js.replace(old_code, new_code)
        js_path.write_text(js, encoding="utf-8")
        print("Fixed syntax error in test_1.js!")
    else:
        print("Could not find old corrupted block in test_1.js")

if __name__ == "__main__":
    fix_test1()
