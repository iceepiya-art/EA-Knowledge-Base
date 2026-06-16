from pathlib import Path

from trade_records import TradeRecordReader


def test_missing_trade_record_file_reports_not_connected(tmp_path):
    reader = TradeRecordReader(tmp_path / "missing_trades.csv")

    assert reader.summarize(ea_id="EA_GOLD_SCALPER_01") == {
        "source": "not_connected",
        "total_trades": 0,
        "wins": 0,
        "losses": 0,
        "win_rate": None,
        "net_pnl": None,
    }


def test_summarizes_per_ea_win_rate_and_net_pnl_from_csv(tmp_path):
    path = tmp_path / "trades.csv"
    path.write_text(
        "\n".join(
            [
                "time,ea_id,symbol,pnl,equity",
                "2026-06-01 10:00,EA_GOLD_SCALPER_01,XAUUSD,25.50,100025.50",
                "2026-06-01 11:00,EA_GOLD_SCALPER_01,XAUUSD,-10.00,100015.50",
                "2026-06-01 12:00,EA_BREAKOUT_02,EURUSD,40.00,100055.50",
                "2026-06-01 13:00,EA_GOLD_SCALPER_01,XAUUSD,0,100015.50",
            ]
        ),
        encoding="utf-8",
    )

    summary = TradeRecordReader(path).summarize(ea_id="EA_GOLD_SCALPER_01")

    assert summary == {
        "source": "csv",
        "total_trades": 3,
        "wins": 1,
        "losses": 1,
        "win_rate": 33.33,
        "net_pnl": 15.5,
    }


def test_supports_mt5_profit_alias_and_magic_number_filter(tmp_path):
    path = tmp_path / "mt5_deals.csv"
    path.write_text(
        "\n".join(
            [
                "Time,Magic,Symbol,Profit,Volume",
                "2026-06-01 10:00,26060801,XAUUSD,100.00,0.01",
                "2026-06-01 11:00,26060802,XAUUSD,-25.00,0.01",
                "2026-06-01 12:00,26060801,XAUUSD,-50.00,0.01",
            ]
        ),
        encoding="utf-8",
    )

    summary = TradeRecordReader(path).summarize(magic_number=26060801)

    assert summary["total_trades"] == 2
    assert summary["wins"] == 1
    assert summary["losses"] == 1
    assert summary["win_rate"] == 50.0
    assert summary["net_pnl"] == 50.0


def test_csv_without_ea_columns_can_still_summarize_global_backtest(tmp_path):
    path = tmp_path / "backtest.csv"
    path.write_text(
        "\n".join(
            [
                "time,pnl,equity",
                "2026-01-06 14:33:40,1156.0,101156.0",
                "2026-01-09 12:00:40,-100.0,101056.0",
            ]
        ),
        encoding="utf-8",
    )

    summary = TradeRecordReader(path).summarize(ea_id="EA_GOLD_SCALPER_01")

    assert summary["source"] == "csv"
    assert summary["total_trades"] == 2
    assert summary["wins"] == 1
    assert summary["losses"] == 1
    assert summary["win_rate"] == 50.0
    assert summary["net_pnl"] == 1056.0
