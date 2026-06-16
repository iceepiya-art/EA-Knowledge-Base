from __future__ import annotations

from pathlib import Path

import visualize_backtest


def test_parse_mt5_report_extracts_inline_summary_pairs_and_balance_curve(tmp_path):
    report = tmp_path / "Report.htm"
    report.write_text(
        """
        <html><body>
          <table>
            <tr>
              <td>Initial Deposit:</td><td>10 000.00</td>
              <td>Profit Factor:</td><td>1.42</td>
              <td>Maximal Drawdown:</td><td>3 039.48 (22.33%)</td>
            </tr>
            <tr>
              <td>Total Net Profit:</td><td>1 760.21</td>
              <td>Total Trades:</td><td>358</td>
            </tr>
          </table>
          <table>
            <tr>
              <th>Time</th><th>Deal</th><th>Type</th><th>Profit</th><th>Balance</th>
            </tr>
            <tr>
              <td>2026.01.01 10:00:00</td><td>1</td><td>balance</td><td></td><td>10 000.00</td>
            </tr>
            <tr>
              <td>2026.01.02 11:00:00</td><td>2</td><td>sell</td><td>250.50</td><td>10 250.50</td>
            </tr>
            <tr>
              <td>2026.01.03 12:00:00</td><td>3</td><td>buy</td><td>-50.25</td><td>10 200.25</td>
            </tr>
          </table>
        </body></html>
        """,
        encoding="utf-8",
    )

    stats, equity_data = visualize_backtest.parse_mt5_report(report)

    assert stats["Initial Deposit"] == "10 000.00"
    assert stats["Profit Factor"] == "1.42"
    assert stats["Maximal Drawdown"] == "3 039.48 (22.33%)"
    assert stats["Total Trades"] == "358"
    assert equity_data == [
        {"x": "2026.01.01 10:00:00", "y": 10000.0},
        {"x": "2026.01.02 11:00:00", "y": 10250.5},
        {"x": "2026.01.03 12:00:00", "y": 10200.25},
    ]


def test_generate_dashboard_escapes_report_text_and_embeds_chart_data(tmp_path):
    output = tmp_path / "dashboard.html"

    visualize_backtest.generate_dashboard(
        {"Profit Factor": "1.42", "EA Name": "<script>alert(1)</script>"},
        [{"x": "2026.01.01 10:00:00", "y": 10000.0}],
        output,
    )

    html = output.read_text(encoding="utf-8")
    assert "https://cdn.jsdelivr.net/npm/chart.js" in html
    assert "Profit Factor" in html
    assert "&lt;script&gt;alert(1)&lt;/script&gt;" in html
    assert "<script>alert(1)</script>" not in html
    assert '"y": 10000.0' in html


def test_parse_mt5_report_extracts_summary_when_label_and_value_share_cell(tmp_path):
    report = tmp_path / "Report.htm"
    report.write_text(
        """
        <html><body>
          <table>
            <tr>
              <td>Profit Factor: 1.416978</td>
              <td>Maximal Drawdown: 3 039.48 (22.33%)</td>
              <td>Total Trades: 358</td>
            </tr>
          </table>
        </body></html>
        """,
        encoding="utf-8",
    )

    stats, equity_data = visualize_backtest.parse_mt5_report(report)

    assert stats["Profit Factor"] == "1.416978"
    assert stats["Maximal Drawdown"] == "3 039.48 (22.33%)"
    assert stats["Total Trades"] == "358"
    assert equity_data == []
