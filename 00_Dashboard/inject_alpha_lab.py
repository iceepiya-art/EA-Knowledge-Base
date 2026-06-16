import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def run_injection():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    # 1. Inject the Sidebar Link
    nav_link = """
        <a href="#" onclick="switchPage('page-alpha-lab', this)" class="nav-item">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-award"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>
          Alpha Lab
        </a>
    """
    
    if "Alpha Lab" not in html:
        # Try to find the nav section
        if '<nav class="nav">' in html:
            html = html.replace('<nav class="nav">', f'<nav class="nav">\n{nav_link}')
        elif '<div class="nav">' in html:
            html = html.replace('<div class="nav">', f'<div class="nav">\n{nav_link}')
        else:
            # Let's search for the first <a href="#" onclick="switchPage
            match = re.search(r'(<a href="#" onclick="switchPage[^>]+>.*?</a>)', html, re.DOTALL)
            if match:
                html = html.replace(match.group(1), match.group(1) + nav_link)
    
    # 2. Inject the HTML Page
    page_html = """
    <div id="page-alpha-lab" class="page">
      <div class="top">
        <div style="display:flex; align-items:center; gap:16px;">
          <button class="hamburger" aria-label="Toggle Sidebar"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></svg></button>
          <h2>Alpha Quant Intelligence Lab</h2>
        </div>
      </div>
      
      <div style="margin-top:20px;">
        <!-- TOP TROPHY & SCORE -->
        <div style="text-align:center; padding: 40px 20px; background: linear-gradient(180deg, rgba(250, 204, 21, 0.1) 0%, transparent 100%); border-radius: 24px; border: 1px solid rgba(250,204,21,0.2); box-shadow: 0 10px 40px rgba(0,0,0,0.5);">
            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#facc15" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="filter: drop-shadow(0 0 15px rgba(250,204,21,0.6));"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>
            <div style="color: var(--yellow); font-size: 14px; font-weight: 700; letter-spacing: 2px; margin-top: 10px;">LEVEL: ELITE ⭐️⭐️⭐️⭐️⭐️</div>
            <div style="font-size: 64px; font-weight: 800; color: #fff; text-shadow: 0 0 20px rgba(255,255,255,0.2); line-height: 1;">85 <span style="font-size:32px; color:var(--text-muted);">/ 100</span></div>
            <div style="color: var(--text-muted); font-size: 14px; font-weight: 600; letter-spacing: 1px;">ALPHA SCORE</div>
        </div>

        <div style="display:grid; grid-template-columns: 320px 1fr 320px; gap: 24px; margin-top: 24px;">
            
            <!-- LEFT PANEL: PERFORMANCE -->
            <div class="panel" style="padding:24px;">
                <h3 style="margin-top:0; color:#fff; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px; font-size:14px;"><i data-lucide="bar-chart-2" style="width:16px; height:16px; vertical-align:middle; margin-right:8px;"></i> PERFORMANCE SUMMARY</h3>
                <div style="display:grid; gap:12px; margin-top:16px;">
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Initial Deposit</span>
                        <strong style="color:#fff;">$10,000.00</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Total Net Profit</span>
                        <strong style="color:var(--green); font-size:16px; text-shadow:0 0 10px var(--green-glow);">+$2,616.45</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Profit Factor</span>
                        <strong style="color:#fff;">1.85</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Absolute Drawdown</span>
                        <strong style="color:var(--red);">$124.50</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Maximal Drawdown</span>
                        <strong style="color:var(--red);">2.06%</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Total Trades</span>
                        <strong style="color:#fff;">145</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:8px;">
                        <span style="color:var(--text-muted); font-size:12px;">Win Rate</span>
                        <strong style="color:#fff;">82.57%</strong>
                    </div>
                </div>
            </div>

            <!-- CENTER PANEL: EQUITY CURVE -->
            <div class="panel" style="padding:24px; display:flex; flex-direction:column;">
                <h3 style="margin-top:0; color:#fff; font-size:14px;"><i data-lucide="trending-up" style="width:16px; height:16px; vertical-align:middle; margin-right:8px;"></i> EQUITY PROGRESSION</h3>
                <div style="flex:1; min-height: 300px; position:relative; margin-top:16px; background: rgba(0,0,0,0.2); border-radius: 12px; border:1px solid rgba(255,255,255,0.05);">
                    <canvas id="alphaEquityChart"></canvas>
                </div>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px; margin-top:16px;">
                    <div style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16,185,129,0.3); padding:16px; border-radius:12px; text-align:center;">
                        <div style="color:var(--green); font-size:11px; font-weight:700; letter-spacing:1px;">SHARPE RATIO</div>
                        <div style="font-size:24px; font-weight:800; color:#fff; margin-top:4px;">3.45</div>
                        <div style="color:var(--green); font-size:12px; margin-top:4px;">Excellent</div>
                    </div>
                    <div style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59,130,246,0.3); padding:16px; border-radius:12px; text-align:center;">
                        <div style="color:var(--blue); font-size:11px; font-weight:700; letter-spacing:1px;">RECOVERY FACTOR</div>
                        <div style="font-size:24px; font-weight:800; color:#fff; margin-top:4px;">5.12</div>
                        <div style="color:var(--blue); font-size:12px; margin-top:4px;">Outstanding</div>
                    </div>
                </div>
            </div>

            <!-- RIGHT PANEL: STRENGTHS & PROP FIRM -->
            <div style="display:flex; flex-direction:column; gap:24px;">
                <div class="panel" style="padding:24px;">
                    <h3 style="margin-top:0; color:#fff; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px; font-size:14px;"><i data-lucide="shield-check" style="width:16px; height:16px; vertical-align:middle; margin-right:8px;"></i> KEY STRENGTHS</h3>
                    <div style="display:grid; gap:12px; margin-top:16px;">
                        <div style="display:flex; align-items:center; gap:12px; background:rgba(0,0,0,0.2); padding:12px; border-radius:12px; border:1px solid rgba(34,197,94,0.2);">
                            <div style="width:32px; height:32px; border-radius:8px; background:rgba(34,197,94,0.1); display:grid; place-items:center; color:var(--green);"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
                            <div>
                                <div style="color:#fff; font-weight:600; font-size:12px;">LOW DRAWDOWN</div>
                                <div style="color:var(--text-muted); font-size:11px; margin-top:2px;">Only 2.06% Max DD</div>
                            </div>
                        </div>
                        <div style="display:flex; align-items:center; gap:12px; background:rgba(0,0,0,0.2); padding:12px; border-radius:12px; border:1px solid rgba(59,130,246,0.2);">
                            <div style="width:32px; height:32px; border-radius:8px; background:rgba(59,130,246,0.1); display:grid; place-items:center; color:var(--blue);"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v20"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
                            <div>
                                <div style="color:#fff; font-weight:600; font-size:12px;">HIGH EXPECTED PAYOFF</div>
                                <div style="color:var(--text-muted); font-size:11px; margin-top:2px;">$18.04 Per Trade</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel" style="padding:24px; border-color: rgba(16,185,129,0.3);">
                    <h3 style="margin-top:0; color:#fff; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px; font-size:14px;"><i data-lucide="check-square" style="width:16px; height:16px; vertical-align:middle; margin-right:8px; color:var(--green)"></i> PROP FIRM SUITABILITY</h3>
                    <div style="text-align:center; padding:16px 0;">
                        <div style="font-size:36px; font-weight:800; color:var(--green); text-shadow:0 0 15px var(--green-glow); line-height:1;">9.0 <span style="font-size:16px; color:var(--text-muted); font-weight:500;">/ 10</span></div>
                        <div style="color:var(--green); font-size:12px; font-weight:600; margin-top:4px;">HIGHLY RECOMMENDED</div>
                    </div>
                    <div style="display:grid; gap:8px;">
                        <div style="display:flex; justify-content:space-between; font-size:12px; color:#fff;"><span style="color:var(--text-muted)">FTMO Challenge</span><i data-lucide="check" style="color:var(--green); width:14px; height:14px;"></i></div>
                        <div style="display:flex; justify-content:space-between; font-size:12px; color:#fff;"><span style="color:var(--text-muted)">FundedNext</span><i data-lucide="check" style="color:var(--green); width:14px; height:14px;"></i></div>
                        <div style="display:flex; justify-content:space-between; font-size:12px; color:#fff;"><span style="color:var(--text-muted)">The 5ers</span><i data-lucide="check" style="color:var(--green); width:14px; height:14px;"></i></div>
                    </div>
                </div>
            </div>
        </div>
      </div>
    </div>
    """

    if 'id="page-alpha-lab"' not in html:
        # Inject right before the closing </main> or </body>
        if '</main>' in html:
            html = html.replace('</main>', f'{page_html}\n</main>')
        else:
            html = html.replace('</body>', f'{page_html}\n</body>')
    
    dashboard_path.write_text(html, encoding="utf-8")
    print("Injected HTML successfully.")

if __name__ == "__main__":
    run_injection()
