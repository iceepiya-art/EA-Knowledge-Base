import re

path = 'g:/My Drive/save log-blueprint-skill/EA-Knowledge-Base/00_Dashboard/EA_Knowledge_Brain_Dashboard.html'
with open(path, 'r', encoding='utf-8', errors='ignore') as f:
    html = f.read()

widget = """
          <section class="panel" id="ea-components-summary-panel">
            <div class="panel-head">
              <div class="panel-title">EA Components Inventory</div>
              <span id="ea-comp-readiness" class="badge b-muted">Checking</span>
            </div>
            <div class="panel-body">
              <div class="grid-2" style="margin-bottom: 12px;">
                <div class="stat-box">
                  <span class="stat-label">Total Extracted</span>
                  <strong class="stat-value" id="ea-comp-total">-</strong>
                </div>
                <div class="stat-box">
                  <span class="stat-label">Ready Types</span>
                  <strong class="stat-value" id="ea-comp-types">-</strong>
                </div>
              </div>
              <div style="font-size:12px; color:var(--muted);">
                <i data-lucide="info" style="width:12px; height:12px; margin-right:4px;"></i>
                See details in <b style="color:var(--text)">EA Components</b> tab.
              </div>
            </div>
          </section>
"""

# Find the Research Assistant panel and insert right after its </section>
# But wait, there might be multiple </section>. Let's inject after <section class="panel research-panel" id="research-assistant-panel"> ... </section>
match = re.search(r'(<section class="panel research-panel" id="research-assistant-panel">.*?</section>)', html, re.DOTALL)
if match:
    original = match.group(1)
    html = html.replace(original, original + widget)

# Now update the JS to render it
js_update = """
      const compReadiness = document.getElementById('ea-comp-readiness');
      const compTotal = document.getElementById('ea-comp-total');
      const compTypes = document.getElementById('ea-comp-types');
      if (compReadiness) { 
          const r = data.summary?.ea_readiness || 'low';
          compReadiness.textContent = r.toUpperCase(); 
          compReadiness.className = 'badge b-' + (r === 'high' ? 'green' : (r === 'medium' ? 'yellow' : 'red')); 
      }
      if (compTotal) compTotal.textContent = data.summary?.total_rules || '0';
      if (compTypes) compTypes.textContent = (data.summary?.components_complete || []).length + ' / 5';

      if (qualityEl) {
"""
html = html.replace("if (qualityEl) {", js_update, 1)

with open(path, 'w', encoding='utf-8') as f:
    f.write(html)

print("Widget injected successfully!")
