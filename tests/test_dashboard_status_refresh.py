from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DASHBOARD_JS = ROOT / "00_Dashboard" / "test_1.js"


def _function_body(source: str, name: str) -> str:
    marker = f"async function {name}()"
    start = source.index(marker)
    brace_start = source.index("{", start)
    depth = 0
    for idx in range(brace_start, len(source)):
        if source[idx] == "{":
            depth += 1
        elif source[idx] == "}":
            depth -= 1
            if depth == 0:
                return source[brace_start + 1 : idx]
    raise AssertionError(f"Could not parse function body for {name}")


def test_system_status_checks_start_before_slow_youtube_sources_load():
    source = DASHBOARD_JS.read_text(encoding="utf-8")
    body = _function_body(source, "refreshAll")

    youtube_status_pos = body.index("checkYouTubeStatus()")
    telegram_status_pos = body.index("checkTelegramStatus()")
    sources_pos = body.index("loadYouTubeSources()")

    assert youtube_status_pos < sources_pos
    assert telegram_status_pos < sources_pos
