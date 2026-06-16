from __future__ import annotations

import argparse
import html
import json
import re
from pathlib import Path
from typing import Iterable

from bs4 import BeautifulSoup


SUMMARY_LABELS = (
    "Initial Deposit",
    "Total Net Profit",
    "Gross Profit",
    "Gross Loss",
    "Profit Factor",
    "Expected Payoff",
    "Recovery Factor",
    "Sharpe Ratio",
    "Absolute Drawdown",
    "Maximal Drawdown",
    "Relative Drawdown",
    "Total Trades",
    "Short Trades (won %)",
    "Long Trades (won %)",
    "Profit Trades (% of total)",
    "Loss Trades (% of total)",
    "Largest profit trade",
    "Largest loss trade",
    "Average profit trade",
    "Average loss trade",
)

KEY_METRICS = (
    "Total Net Profit",
    "Profit Factor",
    "Maximal Drawdown",
    "Relative Drawdown",
    "Recovery Factor",
    "Total Trades",
)


def _clean_text(value: str) -> str:
    return re.sub(r"\s+", " ", value.replace("\xa0", " ")).strip()


def _normalize_label(value: str) -> str:
    return _clean_text(value).rstrip(":")


def _parse_decimal(value: str) -> float:
    cleaned = _clean_text(value)
    cleaned = re.sub(r"[^\d,.\-]", "", cleaned)
    if "," in cleaned and "." in cleaned:
        cleaned = cleaned.replace(",", "")
    elif "," in cleaned:
        cleaned = cleaned.replace(",", ".")
    return float(cleaned)


def _matching_label(text: str) -> str | None:
    normalized = _normalize_label(text)
    for label in SUMMARY_LABELS:
        if normalized == label or normalized.startswith(f"{label}:"):
            return label
    return None


def _extract_inline_value(text: str, label: str) -> str | None:
    pattern = rf"^{re.escape(label)}\s*:\s*(.+)$"
    match = re.match(pattern, _clean_text(text))
    if not match:
        return None
    return match.group(1).strip()


def _extract_summary_stats(cells: Iterable) -> dict[str, str]:
    stats: dict[str, str] = {}
    cell_list = list(cells)

    for index, cell in enumerate(cell_list):
        text = _clean_text(cell.get_text(" ", strip=True))
        label = _matching_label(text)
        if not label:
            continue

        inline_value = _extract_inline_value(text, label)
        if inline_value:
            stats[label] = inline_value
            continue

        if index + 1 < len(cell_list):
            next_text = _clean_text(cell_list[index + 1].get_text(" ", strip=True))
            if next_text and not _matching_label(next_text):
                stats[label] = next_text

    return stats


def _table_headers(table) -> tuple[list[str], object | None]:
    for row in table.find_all("tr")[:8]:
        cells = row.find_all(["td", "th"])
        headers = [_normalize_label(cell.get_text(" ", strip=True)) for cell in cells]
        if "Time" in headers and "Balance" in headers:
            return headers, row
    return [], None


def parse_mt5_report(html_path: str | Path) -> tuple[dict[str, str], list[dict[str, float | str]]]:
    report_path = Path(html_path)
    soup = BeautifulSoup(report_path.read_text(encoding="utf-8", errors="replace"), "html.parser")

    stats = _extract_summary_stats(soup.find_all(["td", "th"]))
    equity_data: list[dict[str, float | str]] = []

    for table in soup.find_all("table"):
        headers, header_row = _table_headers(table)
        if not headers or header_row is None:
            continue

        time_index = headers.index("Time")
        balance_index = headers.index("Balance")
        required_index = max(time_index, balance_index)

        for row in header_row.find_all_next("tr"):
            if row.find_parent("table") is not table:
                break

            cells = row.find_all("td")
            if len(cells) <= required_index:
                continue

            time_value = _clean_text(cells[time_index].get_text(" ", strip=True))
            balance_value = _clean_text(cells[balance_index].get_text(" ", strip=True))
            if not time_value or not balance_value:
                continue

            try:
                balance = _parse_decimal(balance_value)
            except ValueError:
                continue

            equity_data.append({"x": time_value, "y": balance})
        break

    return stats, equity_data


def _stat_card(label: str, value: str, featured: bool = False) -> str:
    safe_label = html.escape(label)
    safe_value = html.escape(value)
    card_class = "metric-card featured" if featured else "metric-card"
    return f"""
        <article class="{card_class}">
            <span>{safe_label}</span>
            <strong>{safe_value}</strong>
        </article>
    """


def _json_for_script(value: object) -> str:
    return json.dumps(value, ensure_ascii=False).replace("</", "<\\/")


def generate_dashboard(
    stats: dict[str, str],
    equity_data: list[dict[str, float | str]],
    output_path: str | Path,
) -> None:
    ordered_metrics = [metric for metric in KEY_METRICS if metric in stats]
    remaining_metrics = [metric for metric in stats if metric not in ordered_metrics]
    cards_html = "".join(_stat_card(metric, stats[metric], featured=True) for metric in ordered_metrics)
    cards_html += "".join(_stat_card(metric, stats[metric]) for metric in remaining_metrics)

    chart_data_json = _json_for_script(equity_data)
    trade_count = html.escape(stats.get("Total Trades", "n/a"))
    point_count = html.escape(str(len(equity_data)))

    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MT5 Backtest Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {{
            color-scheme: dark;
            --bg: #101820;
            --panel: #18232e;
            --panel-soft: #20313d;
            --text: #eef5f2;
            --muted: #9fb0aa;
            --accent: #2dd4bf;
            --accent-2: #f8c14a;
            --danger: #f87171;
        }}
        * {{ box-sizing: border-box; }}
        body {{
            margin: 0;
            min-height: 100vh;
            font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: var(--text);
        }}
        main {{
            width: min(1180px, calc(100vw - 32px));
            margin: 0 auto;
            padding: 32px 0;
        }}
        header {{
            display: flex;
            align-items: end;
            justify-content: space-between;
            gap: 24px;
            margin-bottom: 24px;
        }}
        h1 {{
            margin: 0;
            font-size: clamp(28px, 4vw, 48px);
            line-height: 1;
            letter-spacing: 0;
        }}
        .subtitle {{
            margin: 10px 0 0;
            color: var(--muted);
        }}
        .status-strip {{
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
            color: var(--muted);
            font-size: 13px;
        }}
        .status-strip span {{
            border: 1px solid #2b424b;
            background: #14212a;
            padding: 8px 10px;
            border-radius: 6px;
        }}
        .metrics {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
            gap: 12px;
            margin-bottom: 18px;
        }}
        .metric-card {{
            min-height: 94px;
            padding: 16px;
            border: 1px solid #263944;
            border-radius: 8px;
            background: var(--panel);
        }}
        .metric-card.featured {{
            border-color: #2b5f5b;
            background: linear-gradient(180deg, #1a3638 0%, var(--panel) 100%);
        }}
        .metric-card span {{
            display: block;
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            overflow-wrap: anywhere;
        }}
        .metric-card strong {{
            display: block;
            margin-top: 10px;
            font-size: 22px;
            line-height: 1.1;
            overflow-wrap: anywhere;
        }}
        .chart-panel {{
            height: min(620px, 62vh);
            min-height: 360px;
            padding: 18px;
            border: 1px solid #263944;
            border-radius: 8px;
            background: var(--panel-soft);
        }}
        .chart-title {{
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 12px;
        }}
        .chart-title h2 {{
            margin: 0;
            font-size: 18px;
            letter-spacing: 0;
        }}
        .chart-title span {{
            color: var(--muted);
            font-size: 13px;
        }}
        .canvas-wrap {{
            height: calc(100% - 34px);
        }}
        footer {{
            margin-top: 18px;
            color: var(--muted);
            font-size: 12px;
            text-align: center;
        }}
        @media (max-width: 720px) {{
            header {{
                display: block;
            }}
            .status-strip {{
                justify-content: flex-start;
                margin-top: 16px;
            }}
            main {{
                width: min(100vw - 20px, 1180px);
                padding-top: 20px;
            }}
        }}
    </style>
</head>
<body>
    <main>
        <header>
            <div>
                <h1>MT5 Backtest Dashboard</h1>
                <p class="subtitle">Equity curve, balance progression, and strategy health metrics from Report.htm</p>
            </div>
            <div class="status-strip" aria-label="Report summary">
                <span>{trade_count} trades</span>
                <span>{point_count} curve points</span>
            </div>
        </header>

        <section class="metrics" aria-label="Backtest statistics">
            {cards_html}
        </section>

        <section class="chart-panel" aria-label="Equity curve chart">
            <div class="chart-title">
                <h2>Balance Curve</h2>
                <span>Hover for exact balance by time</span>
            </div>
            <div class="canvas-wrap">
                <canvas id="equityChart"></canvas>
            </div>
        </section>

        <footer>Generated by EA Knowledge Brain</footer>
    </main>

    <script>
        const rawData = {chart_data_json};
        const ctx = document.getElementById('equityChart');
        new Chart(ctx, {{
            type: 'line',
            data: {{
                labels: rawData.map(point => point.x),
                datasets: [{{
                    label: 'Balance',
                    data: rawData.map(point => point.y),
                    borderColor: '#2dd4bf',
                    backgroundColor: 'rgba(45, 212, 191, 0.16)',
                    borderWidth: 2,
                    pointRadius: 0,
                    pointHoverRadius: 5,
                    pointBackgroundColor: '#f8c14a',
                    fill: true,
                    tension: 0.22
                }}]
            }},
            options: {{
                responsive: true,
                maintainAspectRatio: false,
                interaction: {{ intersect: false, mode: 'index' }},
                plugins: {{
                    legend: {{ display: false }},
                    tooltip: {{
                        backgroundColor: '#101820',
                        borderColor: '#2b424b',
                        borderWidth: 1,
                        callbacks: {{
                            label(context) {{
                                return 'Balance: ' + context.parsed.y.toLocaleString(undefined, {{
                                    minimumFractionDigits: 2,
                                    maximumFractionDigits: 2
                                }});
                            }}
                        }}
                    }}
                }},
                scales: {{
                    x: {{
                        grid: {{ color: 'rgba(238, 245, 242, 0.08)' }},
                        ticks: {{ color: '#9fb0aa', maxTicksLimit: 9 }}
                    }},
                    y: {{
                        grid: {{ color: 'rgba(238, 245, 242, 0.08)' }},
                        ticks: {{
                            color: '#9fb0aa',
                            callback(value) {{ return value.toLocaleString(); }}
                        }}
                    }}
                }}
            }}
        }});
    </script>
</body>
</html>
"""

    destination = Path(output_path)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(html_content, encoding="utf-8")
    print(f"Dashboard successfully generated at: {destination.resolve()}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Parse an MT5 Report.htm file and generate a Chart.js dashboard."
    )
    parser.add_argument("--input", required=True, help="Path to the MT5 Report.htm file.")
    parser.add_argument(
        "--output",
        default="dashboard.html",
        help="Path for the generated HTML dashboard.",
    )
    args = parser.parse_args(argv)

    input_path = Path(args.input)
    if not input_path.exists():
        parser.error(f"input file does not exist: {input_path}")

    stats, equity_data = parse_mt5_report(input_path)
    if not stats and not equity_data:
        print("Warning: no MT5 summary stats or balance curve data were extracted.")

    generate_dashboard(stats, equity_data, args.output)
    print(f"Extracted {len(stats)} summary metrics and {len(equity_data)} balance points.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
