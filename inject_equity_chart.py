import re
from pathlib import Path

dashboard_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\00_Dashboard\EA_Knowledge_Brain_Dashboard.html")

def inject_chart():
    html = dashboard_path.read_text(encoding="utf-8", errors="ignore")
    
    # We want to insert the script right before the closing </div> of the page-alpha-lab
    # Or just at the end of the <body>. Let's just append it to the body.
    
    chart_script = """
    <script>
    // Alpha Lab Equity Chart Rendering
    document.addEventListener("DOMContentLoaded", function() {
        const ctx = document.getElementById('alphaEquityChart');
        if (ctx) {
            const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, 'rgba(56, 189, 248, 0.4)'); // Light blue at top
            gradient.addColorStop(1, 'rgba(56, 189, 248, 0.0)'); // Transparent at bottom
            
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'Equity ($)',
                        data: [10000, 10200, 10150, 10500, 10800, 10750, 11200, 11600, 11500, 12000, 13100, 14250],
                        borderColor: '#38bdf8', // Blue line
                        backgroundColor: gradient,
                        borderWidth: 3,
                        pointBackgroundColor: '#fff',
                        pointBorderColor: '#38bdf8',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                        fill: true,
                        tension: 0.4 // Smooth curves
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(15, 23, 42, 0.9)',
                            titleColor: '#f8fafc',
                            bodyColor: '#e2e8f0',
                            borderColor: 'rgba(255,255,255,0.1)',
                            borderWidth: 1,
                            padding: 10,
                            displayColors: false,
                            callbacks: {
                                label: function(context) {
                                    return 'Equity: $' + context.parsed.y.toLocaleString();
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: { color: 'rgba(255,255,255,0.05)', drawBorder: false },
                            ticks: { color: 'rgba(255,255,255,0.5)', font: { size: 11 } }
                        },
                        y: {
                            grid: { color: 'rgba(255,255,255,0.05)', drawBorder: false },
                            ticks: { 
                                color: 'rgba(255,255,255,0.5)', 
                                font: { size: 11 },
                                callback: function(value) { return '$' + value; }
                            }
                        }
                    },
                    interaction: {
                        intersect: false,
                        mode: 'index',
                    },
                }
            });
        }
    });
    </script>
    """
    
    if "Alpha Lab Equity Chart Rendering" not in html:
        html = html.replace('</body>', f'{chart_script}\n</body>')
        dashboard_path.write_text(html, encoding="utf-8")
        print("Chart script injected successfully!")
    else:
        print("Chart script already exists.")

if __name__ == "__main__":
    inject_chart()
