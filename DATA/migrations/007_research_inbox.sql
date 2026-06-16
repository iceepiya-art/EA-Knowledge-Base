-- Migration 007 — Research Inbox
-- DB-backed inbox for NotebookLM links and all research sources.
-- Tracks lifecycle: inbox → processing → library | archived
-- Stores auto-generated content: hypothesis draft, action items, test checklist.

CREATE TABLE IF NOT EXISTS research_inbox (
    item_id          TEXT PRIMARY KEY,
    title            TEXT NOT NULL,
    source_type      TEXT DEFAULT 'notebooklm'
                     CHECK(source_type IN (
                         'notebooklm','youtube','article','pdf',
                         'book','podcast','manual','other')),
    source_url       TEXT,
    summary          TEXT,
    raw_notes        TEXT,
    category         TEXT DEFAULT 'uncategorized'
                     CHECK(category IN (
                         'strategy','regime','psychology','risk',
                         'execution','ai_engineering','system_design','uncategorized')),
    status           TEXT DEFAULT 'inbox'
                     CHECK(status IN ('inbox','processing','library','archived')),
    tags             TEXT,             -- comma-separated
    -- Auto-generated content
    hypothesis_draft TEXT,
    action_items     TEXT,             -- JSON array (stored as text)
    test_checklist   TEXT,             -- JSON array (stored as text)
    key_insights     TEXT,             -- JSON array (stored as text)
    -- Links
    note_path        TEXT,             -- path to .md file in vault
    hyp_id           TEXT,             -- FK to hypotheses if converted
    ea_link          TEXT,             -- linked EA strategy name
    -- Timestamps
    created_at       DATETIME DEFAULT (datetime('now')),
    processed_at     DATETIME,
    archived_at      DATETIME
);

CREATE INDEX IF NOT EXISTS idx_ri_status   ON research_inbox(status);
CREATE INDEX IF NOT EXISTS idx_ri_category ON research_inbox(category);
CREATE INDEX IF NOT EXISTS idx_ri_created  ON research_inbox(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ri_source   ON research_inbox(source_type);

-- Per-item action items (more structured than JSON in research_inbox)
CREATE TABLE IF NOT EXISTS research_actions (
    action_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id      TEXT NOT NULL REFERENCES research_inbox(item_id),
    action_text  TEXT NOT NULL,
    action_type  TEXT DEFAULT 'todo'
                 CHECK(action_type IN ('todo','test','hypothesis','note','reference')),
    priority     INTEGER DEFAULT 2 CHECK(priority BETWEEN 1 AND 3),
    completed    INTEGER DEFAULT 0 CHECK(completed IN (0,1)),
    created_at   DATETIME DEFAULT (datetime('now')),
    completed_at DATETIME
);

CREATE INDEX IF NOT EXISTS idx_ra_item      ON research_actions(item_id);
CREATE INDEX IF NOT EXISTS idx_ra_completed ON research_actions(completed);
CREATE INDEX IF NOT EXISTS idx_ra_type      ON research_actions(action_type);

UPDATE db_meta SET value='7' WHERE key='schema_version';
INSERT OR IGNORE INTO db_meta VALUES ('schema_version','7');
