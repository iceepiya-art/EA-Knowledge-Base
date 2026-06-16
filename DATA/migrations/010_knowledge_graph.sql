-- 010_knowledge_graph.sql
-- Knowledge Relationship & Reasoning Layer
-- Tables: knowledge_nodes, knowledge_relationships, evidence_links, reasoning_paths

-- ── knowledge_nodes ───────────────────────────────────────────────────────────
-- Every concept, strategy, principle, hypothesis, edge, regime, session, etc.
-- is a node. Nodes sync from existing tables (mindset_principles, hypotheses,
-- validated_edges, research_inbox) or are seeded manually.

CREATE TABLE IF NOT EXISTS knowledge_nodes (
    node_id     TEXT PRIMARY KEY,
    node_type   TEXT NOT NULL CHECK(node_type IN (
                    'strategy','regime','session','behavior',
                    'risk_rule','concept','principle',
                    'hypothesis','edge','research')),
    title       TEXT NOT NULL,
    description TEXT,
    source_id   TEXT,           -- FK to originating table (principle_id, hyp_id, etc.)
    source_table TEXT,          -- 'mindset_principles' | 'hypotheses' | 'validated_edges' | 'research_inbox'
    tags        TEXT,           -- comma-separated
    confidence  REAL DEFAULT 0, -- 0-100 propagated confidence
    status      TEXT DEFAULT 'active' CHECK(status IN ('active','archived','deprecated')),
    obsidian_path TEXT,
    created_at  DATETIME DEFAULT (datetime('now')),
    updated_at  DATETIME DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_kn_type   ON knowledge_nodes(node_type);
CREATE INDEX IF NOT EXISTS idx_kn_source ON knowledge_nodes(source_id, source_table);

-- ── knowledge_relationships ───────────────────────────────────────────────────
-- Directed, typed relationships between nodes.
-- from_node → rel_type → to_node
-- strength 0-100: how strong/confident the link is

CREATE TABLE IF NOT EXISTS knowledge_relationships (
    rel_id          TEXT PRIMARY KEY,
    from_node_id    TEXT NOT NULL REFERENCES knowledge_nodes(node_id) ON DELETE CASCADE,
    to_node_id      TEXT NOT NULL REFERENCES knowledge_nodes(node_id) ON DELETE CASCADE,
    rel_type        TEXT NOT NULL CHECK(rel_type IN (
                        'supports','contradicts','related_to',
                        'works_best_in','fails_in','derived_from',
                        'validated_by','linked_to_strategy',
                        'linked_to_session','linked_to_regime',
                        'linked_to_risk_model','required_by','enables')),
    strength        REAL DEFAULT 50 CHECK(strength >= 0 AND strength <= 100),
    rationale       TEXT,
    evidence_count  INTEGER DEFAULT 0,
    is_bidirectional INTEGER DEFAULT 0,  -- 1 = treat as symmetric
    created_by      TEXT DEFAULT 'seed', -- 'seed' | 'user' | 'auto'
    created_at      DATETIME DEFAULT (datetime('now')),
    UNIQUE(from_node_id, to_node_id, rel_type)
);

CREATE INDEX IF NOT EXISTS idx_kr_from ON knowledge_relationships(from_node_id);
CREATE INDEX IF NOT EXISTS idx_kr_to   ON knowledge_relationships(to_node_id);
CREATE INDEX IF NOT EXISTS idx_kr_type ON knowledge_relationships(rel_type);

-- ── evidence_links ────────────────────────────────────────────────────────────
-- Concrete evidence items that support or undermine a relationship.
-- Evidence types: trade_batch, backtest, research_paper, principle_review,
--                 hypothesis_result, manual_observation

CREATE TABLE IF NOT EXISTS evidence_links (
    evidence_id     TEXT PRIMARY KEY,
    rel_id          TEXT REFERENCES knowledge_relationships(rel_id) ON DELETE CASCADE,
    node_id         TEXT REFERENCES knowledge_nodes(node_id) ON DELETE CASCADE,
    evidence_type   TEXT NOT NULL CHECK(evidence_type IN (
                        'trade_batch','backtest','research_paper',
                        'principle_review','hypothesis_result',
                        'manual_observation','arena_item')),
    title           TEXT NOT NULL,
    description     TEXT,
    sample_n        INTEGER DEFAULT 0,  -- number of trades / samples
    result_metric   TEXT,               -- e.g. 'win_rate: 0.71'
    supports        INTEGER DEFAULT 1,  -- 1 = supports relationship, 0 = undermines
    confidence      REAL DEFAULT 50,
    source_ref      TEXT,               -- URL, note path, or ID
    created_at      DATETIME DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_el_rel  ON evidence_links(rel_id);
CREATE INDEX IF NOT EXISTS idx_el_node ON evidence_links(node_id);

-- ── reasoning_paths ───────────────────────────────────────────────────────────
-- Stored query results / inference chains for the intelligence engine.
-- Each path is a sequence of node_ids joined by relationship types.
-- Used to answer questions like: "Why should I use QField in TRENDING regime?"

CREATE TABLE IF NOT EXISTS reasoning_paths (
    path_id         TEXT PRIMARY KEY,
    query_type      TEXT NOT NULL,          -- 'supports_strategy','regime_breaks','best_session',etc.
    query_params    TEXT,                   -- JSON: {"strategy":"QField_EA"}
    path_nodes      TEXT NOT NULL,          -- JSON array of node_ids in order
    path_rels       TEXT,                   -- JSON array of rel_types in order
    conclusion      TEXT,                   -- Human-readable conclusion
    confidence      REAL DEFAULT 0,
    generated_at    DATETIME DEFAULT (datetime('now')),
    expires_at      DATETIME                -- NULL = permanent
);

CREATE INDEX IF NOT EXISTS idx_rp_type ON reasoning_paths(query_type);
