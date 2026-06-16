-- Migration 008 — Research inbox 6-state lifecycle + Learning Arena bridge columns
-- Old states: inbox / processing / library / archived
-- New states: inbox / reviewing / testing / validated / rejected / archived
-- New source_type: learning_arena
-- New columns: arena_id, arena_category, atoms_json

-- Step 1: Create new table with expanded constraints
CREATE TABLE IF NOT EXISTS research_inbox_v2 (
    item_id         TEXT PRIMARY KEY,
    title           TEXT NOT NULL,
    source_type     TEXT DEFAULT 'notebooklm'
        CHECK(source_type IN ('notebooklm','youtube','article','pdf',
                              'book','podcast','manual','other','learning_arena')),
    source_url      TEXT,
    summary         TEXT,
    raw_notes       TEXT,
    category        TEXT DEFAULT 'uncategorized'
        CHECK(category IN ('strategy','regime','psychology','risk',
                           'execution','ai_engineering','system_design','uncategorized')),
    status          TEXT DEFAULT 'inbox'
        CHECK(status IN ('inbox','reviewing','testing','validated','rejected','archived')),
    tags            TEXT,
    hypothesis_draft TEXT,
    action_items    TEXT,
    test_checklist  TEXT,
    key_insights    TEXT,
    note_path       TEXT,
    hyp_id          TEXT,
    ea_link         TEXT,
    -- Learning Arena bridge columns
    arena_id        TEXT,       -- item id from queue.json
    arena_category  TEXT,       -- original Learning Arena category (AI_Updates / Trading_Learn / Macro_News)
    atoms_json      TEXT,       -- JSON array of atomic insights from atomizer
    created_at      DATETIME DEFAULT (datetime('now')),
    processed_at    DATETIME,
    archived_at     DATETIME
);

-- Step 2: Copy existing data, mapping old statuses to new
INSERT OR IGNORE INTO research_inbox_v2 (
    item_id, title, source_type, source_url, summary, raw_notes, category, status,
    tags, hypothesis_draft, action_items, test_checklist, key_insights,
    note_path, hyp_id, ea_link,
    arena_id, arena_category, atoms_json,
    created_at, processed_at, archived_at
)
SELECT
    item_id, title, source_type, source_url, summary, raw_notes, category,
    CASE status
        WHEN 'inbox'      THEN 'inbox'
        WHEN 'processing' THEN 'reviewing'
        WHEN 'library'    THEN 'inbox'
        WHEN 'archived'   THEN 'archived'
        ELSE 'inbox'
    END,
    tags, hypothesis_draft, action_items, test_checklist, key_insights,
    note_path, hyp_id, ea_link,
    NULL, NULL, NULL,
    created_at, processed_at, archived_at
FROM research_inbox;

-- Step 3: Replace table
DROP TABLE IF EXISTS research_inbox;
ALTER TABLE research_inbox_v2 RENAME TO research_inbox;

-- Step 4: Index on arena_id for quick bridge lookups
CREATE INDEX IF NOT EXISTS idx_research_inbox_arena_id ON research_inbox(arena_id);
CREATE INDEX IF NOT EXISTS idx_research_inbox_hyp_id   ON research_inbox(hyp_id);
CREATE INDEX IF NOT EXISTS idx_research_inbox_status   ON research_inbox(status);

-- research_actions table stays unchanged — no migration needed
