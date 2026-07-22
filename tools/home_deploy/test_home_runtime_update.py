import importlib.util
from pathlib import Path


MODULE_PATH = Path(__file__).with_name("home_runtime_update.py")
SPEC = importlib.util.spec_from_file_location("home_runtime_update", MODULE_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


def test_home_only_guard_rejects_google_drive(tmp_path):
    try:
        MODULE.ensure_home_runtime(Path(r"G:\My Drive\EA-Knowledge-Base"), {"EA_KB_EXECUTION_HOST": "home"})
    except ValueError as exc:
        assert "local drive" in str(exc)
    else:
        raise AssertionError("Google Drive runtime must be rejected")


def test_deploy_copies_artifact_and_keeps_backup(tmp_path):
    artifact = tmp_path / "MasterEA_v3.ex5"
    artifact.write_bytes(b"new-build")
    experts = tmp_path / "Experts"
    experts.mkdir()
    (experts / "MasterEA_v3.ex5").write_bytes(b"old-build")

    result = MODULE.backup_and_deploy(artifact, experts, dry_run=False)

    assert (experts / "MasterEA_v3.ex5").read_bytes() == b"new-build"
    assert Path(result["backup"]).read_bytes() == b"old-build"


def test_dry_run_never_copies_artifact(tmp_path):
    artifact = tmp_path / "MasterEA_v3.ex5"
    artifact.write_bytes(b"new-build")
    result = MODULE.backup_and_deploy(artifact, tmp_path / "Experts", dry_run=True)
    assert result["dry_run"] == "true"
    assert not (tmp_path / "Experts").exists()
