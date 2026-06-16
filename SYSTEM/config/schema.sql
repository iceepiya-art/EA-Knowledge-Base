-- QTrade OS v1.0 — Complete Journal Schema
-- Run once to initialize:
--   sqlite3 "DATA\processed\trades.sqlite" < "SYSTEM\config\schema.sql"
--
-- WAL mode: safe for concurrent reads while import script writes.
-- All tables use CREATE IF NOT EXISTS — safe to re-run on existing DB.

PRAGMA journal_mode = WAL;
PRAGMA foreign_keys = ON;
PRAGMA synchronous = NORMAL;

-- ============================================================
-- TABLE: trades
-- The single master journal table.
-- Every closed trade from every strategy lives here.
-- Split into field groups for clarity.
-- ============================================================
CREATE TABLE IF NOT EXISTS trades (

    -- ----------------------------------------------------------
    -- GROUP A: IDENTITY  (required — cannot be null)
    -- ----------------------------------------------------------
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    trade_id        TEXT    UNIQUE NOT NULL,   -- MT5 ticket, or UUID for manual trades
    source          TEXT    NOT NULL DEFAULT 'mt5',
                                               -- mt5 | manual | ea_backtest | paper
    created_at      DATETIME DEFAULT (datetime('now')),
    updated_at      DATETIME DEFAULT (datetime('now')),

    -- ----------------------------------------------------------
    -- GROUP B: INSTRUMENT  (required)
    -- ----------------------------------------------------------
    symbol          TEXT    NOT NULL,          -- XAUUSD | NQ | EURUSD
    timeframe       TEXT,                      -- M1 | M5 | M15 | M30 | H1 | H4 | D1
    session         TEXT    CHECK(session IN
                    ('Asian','London','NY','London_NY','Pre_NY','Other',NULL)),

    -- ----------------------------------------------------------
    -- GROUP C: CLASSIFICATION  (required for analytics grouping)
    -- ----------------------------------------------------------
    strategy        TEXT    NOT NULL DEFAULT 'Unknown',
                                               -- QField | HedgeGrid | EZB_1CB | SMC_Universal
    setup_type      TEXT,                      -- SMC_W | SMC_M | Breakout | Reversal
                                               -- Grid | BSL_Sweep | FVG | OB | CHoCH
    direction       TEXT    NOT NULL CHECK(direction IN ('BUY','SELL')),
    cycle           INTEGER,                   -- grid/recovery cycle number (HedgeGrid, etc.)

    -- ----------------------------------------------------------
    -- GROUP D: PRICE LEVELS  (required)
    -- ----------------------------------------------------------
    entry_price     REAL    NOT NULL,
    sl_price        REAL,
    tp_price        REAL,
    close_price     REAL    NOT NULL,
    rr_planned      REAL,                      -- (tp - entry) / (entry - sl)
    rr_actual       REAL,                      -- pnl_pips / sl_pips  [negative = loss]

    -- ----------------------------------------------------------
    -- GROUP E: SIZING & COST  (required)
    -- ----------------------------------------------------------
    lot_size        REAL    NOT NULL,
    spread_entry    REAL,                      -- spread in points at moment of entry
    commission      REAL    DEFAULT 0,
    swap            REAL    DEFAULT 0,

    -- ----------------------------------------------------------
    -- GROUP F: TIMING  (required)
    -- ----------------------------------------------------------
    open_time       DATETIME NOT NULL,
    close_time      DATETIME NOT NULL,
    duration_min    INTEGER  GENERATED ALWAYS AS
                    (CAST((julianday(close_time) - julianday(open_time)) * 1440 AS INTEGER))
                    STORED,

    -- ----------------------------------------------------------
    -- GROUP G: RESULT  (required)
    -- ----------------------------------------------------------
    pnl_pips        REAL,
    pnl_usd         REAL    NOT NULL,
    pnl_pct         REAL,                      -- pnl_usd / account_balance at open
    outcome         TEXT    NOT NULL CHECK(outcome IN ('WIN','LOSS','BREAKEVEN')),
    exit_reason     TEXT    CHECK(exit_reason IN
                    ('TP_Hit','SL_Hit','Manual_Close','Trail_Stop','EA_Close',
                     'Hedge_Close','News_Close',NULL)),

    -- ----------------------------------------------------------
    -- GROUP H: MARKET CONTEXT  (for regime-conditional analytics)
    -- ----------------------------------------------------------
    regime          TEXT    CHECK(regime IN
                    ('TRENDING','REVERTING','WEAK','CRASH','UNKNOWN',NULL)),
    sc100_value     REAL,                      -- SC100 value at entry bar
    beta1_value     REAL,                      -- beta1 OLS slope at entry bar
    atr_value       REAL,                      -- ATR(14) in points at entry
    atr_percentile  REAL,                      -- 0–100: where ATR sits in 20-day range
    htf_trend       TEXT    CHECK(htf_trend IN ('UP','DOWN','NEUTRAL',NULL)),
                                               -- higher timeframe bias (H4/D1)
    news_event      INTEGER DEFAULT 0 CHECK(news_event IN (0,1)),
                                               -- 1 = high-impact news within 30 min of entry
    rsi_at_entry    REAL,                      -- RSI value at entry (from your CSVs)
    sma50_at_entry  REAL,                      -- SMA50 value at entry

    -- ----------------------------------------------------------
    -- GROUP I: BEHAVIORAL  (for AI pattern detection)
    -- ----------------------------------------------------------
    emotional_state TEXT    CHECK(emotional_state IN
                    ('Calm','Confident','FOMO','Revenge','Bored','Anxious','Greedy',NULL)),
    plan_followed   INTEGER DEFAULT 1 CHECK(plan_followed IN (0,1)),
                                               -- 1 = followed plan, 0 = deviated
    entry_timing    TEXT    CHECK(entry_timing IN ('Early','OnTime','Late',NULL)),
    setup_quality   INTEGER CHECK(setup_quality BETWEEN 1 AND 5),
                                               -- 1=poor 3=average 5=textbook
    execution_score INTEGER CHECK(execution_score BETWEEN 1 AND 10),
                                               -- overall execution quality 1–10
    mistakes        TEXT,                      -- pipe-separated controlled vocab:
                                               -- late_entry|moved_sl|oversized|fomo_entry
                                               -- early_entry|removed_tp|wrong_session
                                               -- revenge_trade|chased_price|ignored_regime
                                               -- no_confirmation|poor_rr|undersized
    notes           TEXT,                      -- free text post-trade reflection

    -- ----------------------------------------------------------
    -- GROUP J: FILE LINKS
    -- ----------------------------------------------------------
    screenshot_path TEXT,                      -- relative path from EA-Knowledge-Base root
                                               -- JOURNAL\screenshots\2026\05\10\XAUUSD_...png
    journal_entry   TEXT,                      -- relative path to .md entry file

    -- ----------------------------------------------------------
    -- GROUP K: ACCOUNT SNAPSHOT AT OPEN
    -- ----------------------------------------------------------
    balance_at_open REAL,                      -- account balance when trade opened
    equity_at_open  REAL,
    daily_pnl_before REAL                      -- running daily PnL before this trade

);

-- Indexes for every common query pattern
CREATE INDEX IF NOT EXISTS idx_t_symbol    ON trades(symbol);
CREATE INDEX IF NOT EXISTS idx_t_strategy  ON trades(strategy);
CREATE INDEX IF NOT EXISTS idx_t_regime    ON trades(regime);
CREATE INDEX IF NOT EXISTS idx_t_open_time ON trades(open_time);
CREATE INDEX IF NOT EXISTS idx_t_outcome   ON trades(outcome);
CREATE INDEX IF NOT EXISTS idx_t_session   ON trades(session);
CREATE INDEX IF NOT EXISTS idx_t_source    ON trades(source);
CREATE INDEX IF NOT EXISTS idx_t_direction ON trades(direction);
CREATE INDEX IF NOT EXISTS idx_t_emotional ON trades(emotional_state);
CREATE INDEX IF NOT EXISTS idx_t_mistakes  ON trades(mistakes);
CREATE INDEX IF NOT EXISTS idx_t_htf_trend ON trades(htf_trend);
CREATE INDEX IF NOT EXISTS idx_t_exit_rsn  ON trades(exit_reason);

-- Trigger: auto-update updated_at on any row change
CREATE TRIGGER IF NOT EXISTS trg_trades_updated
    AFTER UPDATE ON trades
BEGIN
    UPDATE trades SET updated_at = datetime('now') WHERE id = NEW.id;
END;

-- ============================================================
-- TABLE: equity_snapshots
-- One row per calendar day — end-of-day account state.
-- Source: MT5 balance history or calculated from trades.
-- ============================================================
CREATE TABLE IF NOT EXISTS equity_snapshots (
    snapshot_date   DATE    PRIMARY KEY,
    balance         REAL    NOT NULL,
    equity          REAL,
    open_dd_pct     REAL,                      -- (equity - balance) / balance
    daily_pnl       REAL,
    daily_pnl_pct   REAL,                      -- daily_pnl / balance_start_of_day
    week_pnl        REAL,                      -- rolling 7-day PnL
    month_pnl       REAL,                      -- month-to-date PnL
    trade_count     INTEGER DEFAULT 0,
    win_count       INTEGER DEFAULT 0,
    loss_count      INTEGER DEFAULT 0,
    be_count        INTEGER DEFAULT 0,
    daily_wr        REAL    GENERATED ALWAYS AS (
                        CASE WHEN trade_count > 0
                        THEN CAST(win_count AS REAL) / trade_count
                        ELSE NULL END) STORED
);

-- ============================================================
-- TABLE: regime_log
-- SC100 + beta1 per bar — used to tag trades at import time.
-- ============================================================
CREATE TABLE IF NOT EXISTS regime_log (
    bar_time        DATETIME NOT NULL,
    symbol          TEXT     NOT NULL,
    sc100           REAL,
    beta1           REAL,
    regime          TEXT,
    atr             REAL,
    PRIMARY KEY (bar_time, symbol)
);

CREATE INDEX IF NOT EXISTS idx_rl_symbol   ON regime_log(symbol);
CREATE INDEX IF NOT EXISTS idx_rl_bar_time ON regime_log(bar_time);

-- ============================================================
-- TABLE: annotations
-- Separate annotation history — non-destructive edits.
-- Every time you annotate a trade, old values are preserved.
-- ============================================================
CREATE TABLE IF NOT EXISTS annotations (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    trade_id        TEXT    NOT NULL REFERENCES trades(trade_id),
    annotated_at    DATETIME DEFAULT (datetime('now')),
    field_name      TEXT    NOT NULL,          -- which field was changed
    old_value       TEXT,
    new_value       TEXT,
    annotator       TEXT    DEFAULT 'human'    -- human | ai_suggested
);

-- ============================================================
-- TABLE: weekly_stats
-- Pre-computed weekly aggregate — written by weekly_report.py.
-- Avoids recomputing on every dashboard load.
-- ============================================================
CREATE TABLE IF NOT EXISTS weekly_stats (
    week_key        TEXT    PRIMARY KEY,       -- '2026-W19'
    year            INTEGER,
    week_num        INTEGER,
    date_start      DATE,
    date_end        DATE,
    total_trades    INTEGER DEFAULT 0,
    win_count       INTEGER DEFAULT 0,
    loss_count      INTEGER DEFAULT 0,
    win_rate        REAL,
    profit_factor   REAL,
    expectancy_usd  REAL,
    net_pnl         REAL,
    max_dd_pct      REAL,
    avg_rr_actual   REAL,
    avg_duration_min REAL,
    top_mistake     TEXT,
    top_session     TEXT,
    top_strategy    TEXT,
    computed_at     DATETIME DEFAULT (datetime('now'))
);

-- ============================================================
-- TABLE: db_meta
-- ============================================================
CREATE TABLE IF NOT EXISTS db_meta (
    key             TEXT    PRIMARY KEY,
    value           TEXT
);

INSERT OR IGNORE INTO db_meta VALUES ('schema_version', '2');
INSERT OR IGNORE INTO db_meta VALUES ('created_at', datetime('now'));
INSERT OR IGNORE INTO db_meta VALUES ('description', 'QTrade OS Journal Database');
