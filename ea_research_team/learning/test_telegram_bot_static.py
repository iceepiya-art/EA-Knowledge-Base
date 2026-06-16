from __future__ import annotations

import ast
from pathlib import Path


def _function_source(name: str) -> str:
    source = Path(__file__).with_name("telegram_bot.py").read_text(encoding="utf-8")
    tree = ast.parse(source)
    for node in tree.body:
        if isinstance(node, ast.FunctionDef) and node.name == name:
            return ast.get_source_segment(source, node) or ""
    raise AssertionError(f"{name} not found")


def test_photo_handler_processes_remote_inbox_with_auto_pipeline():
    source = _function_source("handle_photo")

    assert "remote-inbox/process" in source
    assert "auto_pipeline" in source
    assert "inbox_root" in source
    assert "poll_pipeline_status" in source
