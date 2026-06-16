-- Migration 002 — Add confidence_level and session_bias to trades
-- Run via: py -3.14 ANALYTICS/setup_db.py --migrate
-- Safe to re-run (Python migration runner handles duplicate column errors)

ALTER TABLE trades ADD COLUMN confidence_level INTEGER;
-- 1=very low, 2=low, 3=medium, 4=high, 5=very high

ALTER TABLE trades ADD COLUMN session_bias TEXT;
-- Bullish | Bearish | Neutral
-- What was your directional bias for this session before trading?
