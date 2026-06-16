# Next Task - EA Knowledge Brain

## Task: Continue Jobot Source/Document Learning Before VDO

User clarified: VDO should be processed last. Continue learning from:

```text
G:\My Drive\jobot
```

Priority order:

1. MQL source code (`.mq4`, `.mq5`, `.mqh`)
2. Text/PDF/document evidence
3. Archives only when they contain useful source/doc material
4. VDO last, using `.agent_handoff/JOBOT_VIDEO_LEDGER.json`

Manual VDO already has a ledger, but do not select more videos until source/document learning is exhausted or the user explicitly asks.

## Current Source Batch Loop

Run controlled source-code batches only:

```powershell
py -3.13 ea_research_team\learning\mql5_code_intake.py --root "G:\My Drive\jobot" --limit 10 --workers 1
py -3.13 ea_research_team\learning\merge_code_insights.py
py -3.13 ea_research_team\learning\generate_mql5_report.py
```

Then sync DB sequentially only:

```powershell
py -3.13 ea_research_team\learning\db_bridge.py sync-concepts --dry-run
py -3.13 ea_research_team\learning\db_bridge.py sync-concepts --apply
py -3.13 ea_research_team\learning\db_bridge.py sync-evidence --dry-run
py -3.13 ea_research_team\learning\db_bridge.py sync-evidence --apply
py -3.13 ea_research_team\learning\db_bridge.py sync-relationships --dry-run
py -3.13 ea_research_team\learning\db_bridge.py sync-relationships --apply
```

Skip an apply when its dry-run reports `planned_create=0` and `planned_update=0`.

Important: do not run DB bridge commands in parallel on the Google Drive SQLite DB.

## Known Totals Before Next Source Batch

- `G:\My Drive\jobot` total files: about 2941
- MQL source files found: 1178
- MQL manifest processed hashes: 200
- MQL insights: 1487
- Manual jobot VDO completed: 1, but VDO is now last priority
- DB after latest jobot VDO loop: `knowledge_nodes=2029`, `evidence_links=5923`, `knowledge_relationships=2844`

## Acceptance Criteria

- [ ] One controlled MQL/source batch completes from `G:\My Drive\jobot`.
- [ ] Merge/report steps complete.
- [ ] DB bridge sync is sequential and final dry-runs are clean.
- [ ] SQLite integrity check returns `ok`.
- [ ] Focused tests pass or failures are reported with evidence.
- [ ] Handoff files are updated with exact counts.

## Files to change

- `data/raw/mql5_code_manifest.json`
- `data/raw/mql5_code_insights.json`
- `ea_research_team/learning/knowledge_index.json`
- `ea_research_team/learning/knowledge_merge_log.json`
- `artifacts/mql5_learning_report.md`
- `concepts/*.md`
- `.agent_handoff/ACTIVE_PLAN.json`
- `.agent_handoff/CURRENT_STATE.md`
- `.agent_handoff/HANDOFF_LOG.md`
- `.agent_handoff/NEXT_TASK.md`
- `.agent_handoff/TEST_STATUS.md`
