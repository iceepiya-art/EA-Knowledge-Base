import importlib.util
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts" / "backup_system.py"


def load_module():
    spec = importlib.util.spec_from_file_location("backup_system", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_excludes_runtime_cache_and_backup_outputs():
    backup = load_module()
    patterns = ["__pycache__/**", ".pytest_cache/**", "EA-System-Backups/**"]

    assert backup.should_exclude(Path("__pycache__/x.pyc"), patterns)
    assert backup.should_exclude(Path(".pytest_cache/v/cache/nodeids"), patterns)
    assert backup.should_exclude(Path("EA-System-Backups/daily/file.zip"), patterns)
    assert not backup.should_exclude(Path("EAs/Ouroboros_Inventory_EA/Ouroboros_Inventory_EA.mq5"), patterns)


def test_collect_destinations_keeps_existing_optional_paths(tmp_path):
    backup = load_module()
    required = tmp_path / "required"
    optional = tmp_path / "optional"
    optional.mkdir()
    missing = tmp_path / "missing"
    config = {
        "destinations": [str(required)],
        "optional_destinations": [str(optional), str(missing)],
    }

    destinations = backup.collect_destinations(config)

    assert required in destinations
    assert optional in destinations
    assert missing not in destinations
