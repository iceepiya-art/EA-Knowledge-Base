from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DASHBOARD_HTML = ROOT / "00_Dashboard" / "EA_Knowledge_Brain_Dashboard.html"


def test_universal_upload_uses_real_progress_bar():
    html = DASHBOARD_HTML.read_text(encoding="utf-8")

    assert "upload-progress-fill" in html
    assert "upload-summary-progress" in html
    assert "XMLHttpRequest" in html
    assert "xhr.upload.onprogress" in html
    assert "aria-valuenow" in html


def test_universal_upload_shows_server_processing_after_100_percent():
    html = DASHBOARD_HTML.read_text(encoding="utf-8")

    assert "Processing on server" in html
    assert "_renderUploadServerProcessing" in html
    assert "setTimeout" in html
    assert "progress >= 100" in html
