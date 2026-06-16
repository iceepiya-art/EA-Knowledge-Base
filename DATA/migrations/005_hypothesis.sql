-- Migration 005 — Hypothesis Tracker + Validated Edges
-- Safe to re-run: all CREATE IF NOT EXISTS.

-- ============================================================
-- TABLE: hypotheses
-- Testable ideas that link to trades DB for live evidence.
-- Status lifecycle: untested → testing → validated | rejected
-- ============================================================
CREATE TABLE IF NOT EXISTS hypotheses (
    hyp_id       TEXT PRIMARY KEY,                  -- HYP-001, HYP-002 …
    title        TEXT NOT NULL,
    description  TEXT,
    status       TEXT NOT NULL DEFAULT 'untested'
                 CHECK(status IN ('untested','testing','validated','rejected')),

    -- Filter dimensions (all optional — NULL = any)
    ea_name      TEXT,
    symbol       TEXT,
    session      TEXT,
    regime       TEXT,
    direction    TEXT CHECK(direction IN ('BUY','SELL',NULL)),

    -- Validation targets
    min_trades   INTEGER DEFAULT 30,
    target_wr    REAL,                              -- expected win rate (0-1)
    target_pf    REAL,                              -- expected profit factor

    -- Live stats (recomputed on each dashboard load)
    actual_n     INTEGER DEFAULT 0,
    actual_wr    REAL,
    actual_pf    REAL,
    actual_exp   REAL,
    actual_net   REAL,
    stats_at     DATETIME,

    -- Lifecycle
    source_note  TEXT,                              -- path to 10_Test_Ideas/*.md
    created_at   DATETIME DEFAULT (datetime('now')),
    updated_at   DATETIME DEFAULT (datetime('now')),
    validated_at DATETIME,
    notes        TEXT
);

-- ============================================================
-- TABLE: validated_edges
-- Graduated hypotheses with ongoing performance tracking.
-- ============================================================
CREATE TABLE IF NOT EXISTS validated_edges (
    edge_id      TEXT PRIMARY KEY,                  -- EDGE-001, EDGE-002 …
    hyp_id       TEXT REFERENCES hypotheses(hyp_id),
    title        TEXT NOT NULL,
    description  TEXT,

    -- Edge conditions (the filter that produced the edge)
    ea_name      TEXT,
    symbol       TEXT,
    session      TEXT,
    regime       TEXT,
    direction    TEXT,
    condition    TEXT,                              -- free text: "SC100<0.25 AND session=London"

    -- Evidence at validation
    sample_n     INTEGER,
    validated_wr REAL,
    validated_pf REAL,
    validated_exp REAL,

    -- Live ongoing stats (recomputed)
    current_n    INTEGER,
    current_wr   REAL,
    current_pf   REAL,
    current_exp  REAL,
    stats_at     DATETIME,

    -- Metadata
    confidence   INTEGER DEFAULT 3 CHECK(confidence BETWEEN 1 AND 5),
    is_active    INTEGER DEFAULT 1 CHECK(is_active IN (0,1)),
    validated_at DATE,
    last_checked DATE,
    note_path    TEXT,                              -- path to 12_Validated_Edges/*.md
    notes        TEXT,
    created_at   DATETIME DEFAULT (datetime('now'))
);

-- ============================================================
-- TABLE: weekly_reviews
-- One row per ISO week: generated markdown path + summary KPIs.
-- ============================================================
CREATE TABLE IF NOT EXISTS weekly_reviews (
    week_key     TEXT PRIMARY KEY,                  -- '2026-W19'
    date_start   DATE NOT NULL,
    date_end     DATE NOT NULL,
    note_path    TEXT,                              -- relative path to .md file
    total_trades INTEGER DEFAULT 0,
    win_rate     REAL,
    net_pnl      REAL,
    profit_factor REAL,
    expectancy   REAL,
    best_ea      TEXT,
    best_session TEXT,
    generated_at DATETIME DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_hyp_status  ON hypotheses(status);
CREATE INDEX IF NOT EXISTS idx_hyp_ea      ON hypotheses(ea_name);
CREATE INDEX IF NOT EXISTS idx_edge_active ON validated_edges(is_active);

UPDATE db_meta SET value='5' WHERE key='schema_version';
INSERT OR IGNORE INTO db_meta VALUES ('schema_version','5');
