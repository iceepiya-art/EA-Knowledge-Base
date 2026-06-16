-- Migration 004 — EA Registry + Portfolio Analytics
-- Safe to re-run: all CREATE IF NOT EXISTS.

-- ============================================================
-- TABLE: ea_registry
-- Master metadata for every EA / strategy.
-- Auto-seeded from distinct strategy values in trades table.
-- ============================================================
CREATE TABLE IF NOT EXISTS ea_registry (
    ea_name          TEXT PRIMARY KEY,          -- must match trades.strategy exactly
    display_name     TEXT,
    ea_type          TEXT DEFAULT 'Unknown'
                     CHECK(ea_type IN ('Trend','MeanRev','Grid','Scalp','SMC','Hybrid','Unknown')),
    risk_level       TEXT DEFAULT 'Medium'
                     CHECK(risk_level IN ('Low','Medium','High')),
    status           TEXT DEFAULT 'Active'
                     CHECK(status IN ('Active','Inactive','Testing')),
    preferred_symbol TEXT,
    preferred_session TEXT,
    inception_date   DATE,
    description      TEXT,
    notes            TEXT,
    created_at       DATETIME DEFAULT (datetime('now')),
    updated_at       DATETIME DEFAULT (datetime('now'))
);

-- ============================================================
-- TABLE: ea_daily_equity
-- One row per (ea_name, date): cumulative P&L snapshot.
-- Written by ea_engine.refresh_daily_equity() — optional cache.
-- ============================================================
CREATE TABLE IF NOT EXISTS ea_daily_equity (
    ea_name     TEXT NOT NULL,
    eq_date     DATE NOT NULL,
    daily_pnl   REAL DEFAULT 0,
    cum_pnl     REAL DEFAULT 0,
    trade_count INTEGER DEFAULT 0,
    PRIMARY KEY (ea_name, eq_date)
);

CREATE INDEX IF NOT EXISTS idx_ede_date ON ea_daily_equity(eq_date);

-- ============================================================
-- Seed ea_registry from existing strategy values
-- (only inserts rows that don't already exist)
-- ============================================================
INSERT OR IGNORE INTO ea_registry (ea_name, display_name)
SELECT DISTINCT strategy, strategy FROM trades WHERE strategy IS NOT NULL;

-- Known EA type mappings (update if ea already inserted above)
UPDATE ea_registry SET ea_type='SMC',    risk_level='Medium' WHERE ea_name='SMC_Universal_EA';
UPDATE ea_registry SET ea_type='Trend',  risk_level='Low'    WHERE ea_name='QField_EA';
UPDATE ea_registry SET ea_type='Scalp',  risk_level='Medium' WHERE ea_name='QuantumQueen';
UPDATE ea_registry SET ea_type='Grid',   risk_level='High'   WHERE ea_name='HedgeGrid_V23';
UPDATE ea_registry SET ea_type='MeanRev',risk_level='Medium' WHERE ea_name='MMF_MakeMoneyFarmed';
UPDATE ea_registry SET ea_type='Hybrid', risk_level='Medium' WHERE ea_name='NQ-GC_Scalper';
UPDATE ea_registry SET ea_type='Hybrid', risk_level='Low'    WHERE ea_name='Dashboard_MSA';

UPDATE db_meta SET value='4' WHERE key='schema_version';
INSERT OR IGNORE INTO db_meta VALUES ('schema_version','4');
