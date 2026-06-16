-- Migration 006 — Hypothesis Workflow v2
-- Expands the research lifecycle from 4 → 5 states.
-- Adds evidence tracking, audit trail, confidence/edge scoring.
-- Safe to re-run: CREATE IF NOT EXISTS + ALTER TABLE tries.
--
-- New lifecycle: idea → testing → observing → validated | rejected
--   idea       — concept captured, not yet tracking trades
--   testing    — actively collecting trade evidence
--   observing  — N ≥ min_trades, under human review
--   validated  — confirmed edge, promoted to validated_edges
--   rejected   — evidence insufficient or contradictory

-- ============================================================
-- Step 1: Recreate hypotheses with expanded status + new cols
-- (SQLite doesn't support ALTER COLUMN, so we rebuild the table)
-- ============================================================

CREATE TABLE IF NOT EXISTS hypotheses_v2 (
    hyp_id            TEXT PRIMARY KEY,
    title             TEXT NOT NULL,
    rationale         TEXT,                      -- WHY you think this edge exists
    description       TEXT,                      -- full description / setup rules
    status            TEXT NOT NULL DEFAULT 'idea'
                      CHECK(status IN ('idea','testing','observing','validated','rejected')),
    priority          INTEGER DEFAULT 2          -- 1=high 2=medium 3=low
                      CHECK(priority BETWEEN 1 AND 3),

    -- Filter dimensions (NULL = match any)
    ea_name           TEXT,
    symbol            TEXT,
    session           TEXT,
    regime            TEXT,
    direction         TEXT CHECK(direction IN ('BUY','SELL',NULL)),
    custom_filter     TEXT,                      -- extra free-text filter description

    -- Validation targets
    min_trades        INTEGER DEFAULT 30,
    target_wr         REAL,
    target_pf         REAL,
    target_exp        REAL,                      -- expected expectancy per trade ($)

    -- Live stats (refreshed by dashboard)
    actual_n          INTEGER DEFAULT 0,
    actual_wr         REAL,
    actual_pf         REAL,
    actual_exp        REAL,
    actual_net        REAL,
    stats_at          DATETIME,

    -- Computed scores (refreshed by dashboard)
    confidence_score  REAL DEFAULT 0,            -- 0-100
    edge_score        REAL DEFAULT 0,            -- 0-100 (only meaningful when validated)

    -- Lifecycle timestamps
    created_at        DATETIME DEFAULT (datetime('now')),
    updated_at        DATETIME DEFAULT (datetime('now')),
    testing_since     DATETIME,
    observing_since   DATETIME,
    validated_at      DATETIME,
    rejected_at       DATETIME,

    -- Links
    source_note       TEXT,                      -- path to 10_Test_Ideas/*.md
    hypothesis_note   TEXT,                      -- path to 11_Hypotheses/*.md
    notes             TEXT                       -- general notes / raw ideas
);

-- Copy existing hypotheses, remapping 'untested' → 'idea'
INSERT OR IGNORE INTO hypotheses_v2 (
    hyp_id, title, description, status, ea_name, symbol, session,
    regime, direction, min_trades, target_wr, target_pf,
    actual_n, actual_wr, actual_pf, actual_exp, actual_net, stats_at,
    created_at, updated_at, validated_at, source_note, notes
)
SELECT
    hyp_id, title, description,
    CASE status
        WHEN 'untested' THEN 'idea'
        ELSE status
    END,
    ea_name, symbol, session, regime, direction,
    min_trades, target_wr, target_pf,
    actual_n, actual_wr, actual_pf, actual_exp, actual_net, stats_at,
    created_at, updated_at, validated_at, source_note, notes
FROM hypotheses
WHERE hyp_id NOT IN (SELECT hyp_id FROM hypotheses_v2);

-- Replace old table
DROP TABLE IF EXISTS hypotheses;
ALTER TABLE hypotheses_v2 RENAME TO hypotheses;

-- ============================================================
-- Step 2: Expand validated_edges with edge_score + drift cols
-- ============================================================

ALTER TABLE validated_edges ADD COLUMN edge_score REAL DEFAULT 0;
ALTER TABLE validated_edges ADD COLUMN wr_drift   REAL;      -- current_wr - validated_wr
ALTER TABLE validated_edges ADD COLUMN pf_drift   REAL;
ALTER TABLE validated_edges ADD COLUMN alert_level TEXT DEFAULT 'ok'
    CHECK(alert_level IN ('ok','watch','warn','degrade'));

-- ============================================================
-- Step 3: hypothesis_evidence — explicit evidence records
-- ============================================================

CREATE TABLE IF NOT EXISTS hypothesis_evidence (
    ev_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    hyp_id       TEXT NOT NULL REFERENCES hypotheses(hyp_id),
    recorded_at  DATETIME DEFAULT (datetime('now')),
    ev_type      TEXT NOT NULL DEFAULT 'trade_stats'
                 CHECK(ev_type IN ('trade_stats','manual','backtest','external','counter')),
    title        TEXT,                           -- short label for this evidence item
    description  TEXT,                           -- what this evidence shows
    -- Stats snapshot (all optional — fill what's known)
    trades_n     INTEGER,
    win_rate     REAL,
    profit_factor REAL,
    expectancy   REAL,
    net_pnl      REAL,
    date_from    DATE,
    date_to      DATE,
    -- Support / contradict
    supports     INTEGER DEFAULT 1              -- 1 = supports hypothesis, 0 = contradicts
                 CHECK(supports IN (0,1)),
    strength     INTEGER DEFAULT 3             -- 1=weak 3=moderate 5=strong
                 CHECK(strength BETWEEN 1 AND 5),
    source_ref   TEXT                          -- URL, note path, or citation
);

CREATE INDEX IF NOT EXISTS idx_ev_hyp ON hypothesis_evidence(hyp_id);

-- ============================================================
-- Step 4: hypothesis_audit — every field change logged
-- ============================================================

CREATE TABLE IF NOT EXISTS hypothesis_audit (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    hyp_id       TEXT NOT NULL,
    changed_at   DATETIME DEFAULT (datetime('now')),
    field_name   TEXT NOT NULL,
    old_value    TEXT,
    new_value    TEXT,
    changed_by   TEXT DEFAULT 'human'  -- human | system | dashboard
);

CREATE INDEX IF NOT EXISTS idx_audit_hyp  ON hypothesis_audit(hyp_id);
CREATE INDEX IF NOT EXISTS idx_audit_time ON hypothesis_audit(changed_at);

-- ============================================================
-- Recreate indexes on new hypotheses table
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_hyp_status   ON hypotheses(status);
CREATE INDEX IF NOT EXISTS idx_hyp_ea       ON hypotheses(ea_name);
CREATE INDEX IF NOT EXISTS idx_hyp_priority ON hypotheses(priority);
CREATE INDEX IF NOT EXISTS idx_edge_active  ON validated_edges(is_active);
CREATE INDEX IF NOT EXISTS idx_edge_score   ON validated_edges(edge_score);

UPDATE db_meta SET value='6' WHERE key='schema_version';
INSERT OR IGNORE INTO db_meta VALUES ('schema_version','6');
