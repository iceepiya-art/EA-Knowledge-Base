-- Migration 003 — Risk Engine tables
-- Auto-applied at dashboard startup via risk_engine._run_migrations()

-- Every risk limit breach, warning, or state change is logged here
CREATE TABLE IF NOT EXISTS risk_events (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    logged_at    DATETIME DEFAULT (datetime('now')),
    level        TEXT NOT NULL CHECK(level IN ('INFO','CAUTION','WARNING','CRITICAL')),
    category     TEXT NOT NULL,   -- DAILY_DD | WEEKLY_DD | CONSEC_LOSS | SESSION_DD
                                  -- VOLATILITY | HALT | RESUME | CONFIG_CHANGE
    message      TEXT NOT NULL,
    metric_value REAL,            -- actual metric at time of event
    threshold    REAL             -- limit that was breached
);
CREATE INDEX IF NOT EXISTS idx_re_logged_at ON risk_events(logged_at DESC);
CREATE INDEX IF NOT EXISTS idx_re_level     ON risk_events(level);

-- Manual or automatic trading halts
CREATE TABLE IF NOT EXISTS trading_halts (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    started_at DATETIME DEFAULT (datetime('now')),
    ended_at   DATETIME,
    reason     TEXT NOT NULL,
    halt_type  TEXT DEFAULT 'auto' CHECK(halt_type IN ('auto','manual')),
    is_active  INTEGER DEFAULT 1  CHECK(is_active  IN (0, 1))
);
CREATE INDEX IF NOT EXISTS idx_th_active ON trading_halts(is_active);
