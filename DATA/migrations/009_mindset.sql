-- Migration 009 — Mindset & Principles Learning System
-- Tables: mindset_principles, mindset_sessions

CREATE TABLE IF NOT EXISTS mindset_principles (
    principle_id           TEXT PRIMARY KEY,
    title                  TEXT NOT NULL,
    mindset_type           TEXT NOT NULL
        CHECK(mindset_type IN (
            'trading_principle','risk_philosophy','quantitative_mindset',
            'research_methodology','validation_standard','engineering_process',
            'decision_framework','behavioral_lesson'
        )),
    category               TEXT NOT NULL
        CHECK(category IN (
            'Mental_Models','Trading_Principles','Research_Standards',
            'Risk_Frameworks','Engineering_Principles','AI_Workflow_Principles'
        )),
    concept                TEXT,
    why_it_matters         TEXT,
    failure_cases          TEXT,   -- JSON array
    practical_applications TEXT,   -- JSON array
    related_strategies     TEXT,   -- JSON array
    related_risk_rules     TEXT,   -- JSON array
    related_sessions       TEXT,   -- JSON array
    implementation_checklist TEXT, -- JSON array
    danger_flags           TEXT,   -- JSON array of flag keys
    quality_score          REAL    DEFAULT 0  CHECK(quality_score BETWEEN 0 AND 100),
    confidence_score       REAL    DEFAULT 0  CHECK(confidence_score BETWEEN 0 AND 100),
    source_ref             TEXT    DEFAULT '',
    source_type            TEXT    DEFAULT 'manual'
        CHECK(source_type IN ('manual','arena','research','seed')),
    note_path              TEXT,
    tags                   TEXT,
    status                 TEXT    DEFAULT 'active'
        CHECK(status IN ('active','draft','archived')),
    applied_count          INTEGER DEFAULT 0,
    violation_count        INTEGER DEFAULT 0,
    review_count           INTEGER DEFAULT 0,
    created_at             DATETIME DEFAULT (datetime('now')),
    last_reviewed          DATETIME
);

CREATE INDEX IF NOT EXISTS idx_msp_type     ON mindset_principles(mindset_type);
CREATE INDEX IF NOT EXISTS idx_msp_category ON mindset_principles(category);
CREATE INDEX IF NOT EXISTS idx_msp_status   ON mindset_principles(status);

CREATE TABLE IF NOT EXISTS mindset_sessions (
    session_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    principle_id   TEXT REFERENCES mindset_principles(principle_id),
    session_type   TEXT DEFAULT 'review'
        CHECK(session_type IN ('review','apply','violation','note')),
    notes          TEXT,
    trade_context  TEXT,
    created_at     DATETIME DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_ms_principle ON mindset_sessions(principle_id);
