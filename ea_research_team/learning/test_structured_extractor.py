"""Tests for structured_extractor.py — keyword and LLM-powered extraction.

ORCA: tests written before implementation.
"""
from __future__ import annotations

import json

from channel_manifest import ChannelManifestStore
from structured_extractor import (
    StructuredExtractionStore,
    _llm_extract,
    _sanitize_rule,
    extract_raw_notes,
    extract_structured_knowledge,
)


# ---------------------------------------------------------------------------
# Mock LLM client helpers
# ---------------------------------------------------------------------------

_LLM_GOOD_JSON = {
    "concepts": ["FVG", "Order Block", "BOS"],
    "ea_rule_candidates": {
        "entry": ["Enter on FVG retest after CHoCH confirmation"],
        "exit": ["Take profit at structure high"],
        "stop_loss": ["Stop loss below the order block wick"],
        "filter": ["Avoid during high-impact news"],
        "regime": ["Only trade in trending market structure"],
    },
}


class _MockContent:
    def __init__(self, text: str):
        self.text = text


class _MockResponse:
    def __init__(self, text: str):
        self.content = [_MockContent(text)]


class _MockMessages:
    def __init__(self, text: str):
        self._text = text

    def create(self, **kwargs):
        return _MockResponse(self._text)


class _MockClient:
    """Minimal Anthropic client stub for testing."""

    def __init__(self, response_text: str = ""):
        self.messages = _MockMessages(response_text)


def _good_client() -> _MockClient:
    return _MockClient(json.dumps(_LLM_GOOD_JSON))


def _error_client() -> _MockClient:
    class _ErrorMessages:
        def create(self, **kw):
            raise RuntimeError("API unavailable")

    c = _MockClient()
    c.messages = _ErrorMessages()
    return c


def _bad_json_client() -> _MockClient:
    return _MockClient("This is not valid JSON at all")


def _markdown_client() -> _MockClient:
    return _MockClient(f"```json\n{json.dumps(_LLM_GOOD_JSON)}\n```")


# ---------------------------------------------------------------------------
# Original 3 tests (keyword extraction baseline)
# ---------------------------------------------------------------------------

def test_extract_structured_knowledge_detects_concepts_and_rule_candidates(monkeypatch):
    monkeypatch.delenv("GEMINI_API_KEY", raising=False)
    result = extract_structured_knowledge(
        title="Pattern W Liquidity Setup",
        transcript=(
            "Wait for liquidity sweep below equal lows. "
            "Then confirm CHoCH on M5 before entry. "
            "Use FVG and Order Block as the retest zone. "
            "Stop loss goes below the sweep wick."
        ),
        source={"video_id": "v001", "url": "https://youtu.be/v001"},
    )
    assert result["video_id"] == "v001"
    assert "Pattern W" in result["concepts"]
    assert "Liquidity Sweep" in result["concepts"]
    assert "CHoCH" in result["concepts"]
    assert "FVG" in result["concepts"]
    assert "Order Block" in result["concepts"]
    assert result["ea_rule_candidates"]["entry"]
    assert result["ea_rule_candidates"]["stop_loss"]
    assert result["quality"]["rule_completeness"] >= 60
    assert result["quality"]["ea_readiness"] >= 50


def test_structured_extraction_store_upserts_by_video_id(tmp_path):
    store = StructuredExtractionStore(tmp_path / "structured_extractions.json")
    first = {
        "video_id": "v001",
        "title": "First title",
        "concepts": ["FVG"],
        "quality": {"ea_readiness": 40},
    }
    second = {
        "video_id": "v001",
        "title": "Updated title",
        "concepts": ["FVG", "CHoCH"],
        "quality": {"ea_readiness": 70},
    }
    assert store.upsert(first)["created"] is True
    assert store.upsert(second)["created"] is False
    data = store.load()
    assert len(data["items"]) == 1
    assert data["items"]["v001"]["title"] == "Updated title"
    assert data["items"]["v001"]["concepts"] == ["FVG", "CHoCH"]


def test_extract_raw_notes_writes_structured_index_and_updates_manifest(tmp_path, monkeypatch):
    monkeypatch.delenv("GEMINI_API_KEY", raising=False)
    raw_dir = tmp_path / "raw" / "youtube"
    raw_dir.mkdir(parents=True)
    note = raw_dir / "2026-01-01_v001.md"
    note.write_text(
        "\n".join([
            "---",
            "video_id: v001",
            "source: https://youtu.be/v001",
            "channel: Test Channel",
            "---",
            "",
            "# Pattern W Setup",
            "",
            "## Fact / Transcript Evidence",
            "",
            "Liquidity sweep, CHoCH confirmation, FVG retest, stop loss below sweep wick.",
            "",
            "## Interpretation",
            "",
            "_Pending structured extraction._",
        ]),
        encoding="utf-8",
    )
    manifest = ChannelManifestStore(tmp_path / "channel_manifest.json")
    manifest.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@RealTradingChannel",
        videos=[{"video_id": "v001", "title": "Pattern W Setup",
                  "url": "https://youtu.be/v001", "published": "2026-01-01"}],
    )
    manifest.update_video_status("v001", "raw_evidence_written", note_paths=[str(note)])
    store = StructuredExtractionStore(tmp_path / "structured_extractions.json")

    result = extract_raw_notes(raw_dir=raw_dir, store=store, manifest_store=manifest)

    data = store.load()
    video = manifest.load()["videos"]["v001"]
    assert result["processed"] == 1
    assert result["written"] == 1
    assert "v001" in data["items"]
    concepts_text = " ".join(data["items"]["v001"]["concepts"]).casefold()
    assert "liquidity" in concepts_text and "sweep" in concepts_text
    assert video["status"] == "structured_extracted"


# ---------------------------------------------------------------------------
# _sanitize_rule tests
# ---------------------------------------------------------------------------

def test_sanitize_rule_returns_none_for_long_strings():
    assert _sanitize_rule("x" * 301) is None


def test_sanitize_rule_returns_stripped_string_within_limit():
    result = _sanitize_rule("  Enter on FVG retest  ")
    assert result == "Enter on FVG retest"


def test_sanitize_rule_returns_none_for_empty_string():
    assert _sanitize_rule("") is None
    assert _sanitize_rule("   ") is None


def test_sanitize_rule_accepts_exactly_300_chars():
    s = "x" * 300
    assert _sanitize_rule(s) == s


# ---------------------------------------------------------------------------
# _llm_extract tests
# ---------------------------------------------------------------------------

def test_llm_extract_returns_dict_on_success():
    result = _llm_extract(title="FVG Setup", transcript="Buy on FVG retest.", llm_client=_good_client())
    assert isinstance(result, dict)


def test_llm_extract_returns_concepts_list():
    result = _llm_extract(title="FVG Setup", transcript="Buy on FVG retest.", llm_client=_good_client())
    assert "concepts" in result
    assert "FVG" in result["concepts"]


def test_llm_extract_returns_rule_candidates():
    result = _llm_extract(title="FVG Setup", transcript="Buy on FVG retest.", llm_client=_good_client())
    assert "ea_rule_candidates" in result
    rc = result["ea_rule_candidates"]
    assert "entry" in rc
    assert "stop_loss" in rc


def test_llm_extract_returns_none_on_api_error():
    result = _llm_extract(title="x", transcript="x", llm_client=_error_client())
    assert result is None


def test_llm_extract_returns_none_on_invalid_json():
    result = _llm_extract(title="x", transcript="x", llm_client=_bad_json_client())
    assert result is None


def test_llm_extract_parses_json_from_markdown_codeblock():
    result = _llm_extract(title="FVG Setup", transcript="Buy on FVG.", llm_client=_markdown_client())
    assert result is not None
    assert "FVG" in result["concepts"]


# ---------------------------------------------------------------------------
# extract_structured_knowledge with llm_client param
# ---------------------------------------------------------------------------

def test_extract_uses_llm_when_client_injected():
    result = extract_structured_knowledge(
        title="Order Block Entry",
        transcript="Price returns to OB, enter long.",
        source={"video_id": "v002", "url": "https://youtu.be/v002"},
        llm_client=_good_client(),
    )
    assert "FVG" in result["concepts"] or "Order Block" in result["concepts"]
    assert result["extraction_method"] == "llm"


def test_extract_uses_keyword_when_no_client(monkeypatch):
    monkeypatch.delenv("GEMINI_API_KEY", raising=False)
    result = extract_structured_knowledge(
        title="FVG retest",
        transcript="Enter on FVG retest, stop loss below wick.",
        source={"video_id": "v003", "url": "https://youtu.be/v003"},
    )
    assert result["extraction_method"] == "keyword"


def test_extract_falls_back_to_keyword_on_llm_error():
    result = extract_structured_knowledge(
        title="FVG retest",
        transcript="Enter on FVG retest, stop loss below wick.",
        source={"video_id": "v004", "url": "https://youtu.be/v004"},
        llm_client=_error_client(),
    )
    assert result["extraction_method"] == "keyword"
    assert result["concepts"]


def test_extract_result_has_extraction_method_field():
    result = extract_structured_knowledge(
        title="Test",
        transcript="FVG entry",
        source={"video_id": "v005", "url": ""},
    )
    assert "extraction_method" in result


def test_llm_rules_longer_than_300_chars_are_filtered():
    long_rule = "x" * 400
    bad_client = _MockClient(json.dumps({
        "concepts": ["FVG"],
        "ea_rule_candidates": {
            "entry": [long_rule, "Short valid entry rule"],
            "exit": [], "stop_loss": [], "filter": [], "regime": [],
        },
    }))
    result = extract_structured_knowledge(
        title="FVG",
        transcript="FVG entry signal",
        source={"video_id": "v006", "url": ""},
        llm_client=bad_client,
    )
    entries = result["ea_rule_candidates"]["entry"]
    assert all(len(e) <= 300 for e in entries)
    assert "Short valid entry rule" in entries


def test_extract_raw_notes_accepts_llm_client(tmp_path):
    raw_dir = tmp_path / "raw"
    raw_dir.mkdir()
    note = raw_dir / "2026-01-01_v007.md"
    note.write_text(
        "\n".join([
            "---", "video_id: v007", "source: https://youtu.be/v007", "---",
            "", "# FVG Video", "", "## Fact / Transcript Evidence", "",
            "Enter on FVG retest after CHoCH. Stop loss below OB.", "",
        ]),
        encoding="utf-8",
    )
    store = StructuredExtractionStore(tmp_path / "structured_extractions.json")
    result = extract_raw_notes(raw_dir=raw_dir, store=store, llm_client=_good_client())
    assert result["written"] == 1
    data = store.load()
    assert data["items"]["v007"]["extraction_method"] == "llm"


def test_extract_raw_notes_skips_already_llm_extracted(tmp_path):
    """Re-running with llm_client skips notes already extracted via LLM."""
    raw_dir = tmp_path / "raw"
    raw_dir.mkdir()
    note = raw_dir / "2026-01-01_v008.md"
    note.write_text(
        "\n".join([
            "---", "video_id: v008", "source: https://youtu.be/v008", "---",
            "", "# Video", "", "## Fact / Transcript Evidence", "",
            "Enter on FVG retest.", "",
        ]),
        encoding="utf-8",
    )
    store = StructuredExtractionStore(tmp_path / "structured_extractions.json")
    # first run: write llm result
    result1 = extract_raw_notes(raw_dir=raw_dir, store=store, llm_client=_good_client())
    assert result1["written"] == 1

    call_count = [0]
    class CountingClient:
        class messages:
            @staticmethod
            def create(**kwargs):
                call_count[0] += 1
                return _good_client().messages.create(**kwargs)

    # second run: should skip (already llm-extracted), no API call made
    result2 = extract_raw_notes(raw_dir=raw_dir, store=store, llm_client=CountingClient())
    assert result2["written"] == 0
    assert result2["skipped"] == 1
    assert call_count[0] == 0


def test_extract_raw_notes_does_not_skip_keyword_extracted_when_llm_provided(tmp_path, monkeypatch):
    """Notes extracted via keyword should be re-extracted when llm_client is given."""
    monkeypatch.delenv("GEMINI_API_KEY", raising=False)
    raw_dir = tmp_path / "raw"
    raw_dir.mkdir()
    note = raw_dir / "2026-01-01_v009.md"
    note.write_text(
        "\n".join([
            "---", "video_id: v009", "source: https://youtu.be/v009", "---",
            "", "# Video", "", "## Fact / Transcript Evidence", "",
            "Enter on FVG retest.", "",
        ]),
        encoding="utf-8",
    )
    store = StructuredExtractionStore(tmp_path / "structured_extractions.json")
    # first run: keyword (no llm_client)
    result1 = extract_raw_notes(raw_dir=raw_dir, store=store, llm_client=None)
    assert result1["written"] == 1
    assert store.load()["items"]["v009"]["extraction_method"] == "keyword"

    # second run: with llm_client — should re-extract since it's only keyword
    result2 = extract_raw_notes(raw_dir=raw_dir, store=store, llm_client=_good_client())
    assert result2["written"] == 1
    assert store.load()["items"]["v009"]["extraction_method"] == "llm"
