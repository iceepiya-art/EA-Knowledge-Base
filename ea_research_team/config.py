import os

MODEL = "claude-opus-4-7"

KB_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

# ทะเบียน EA Projects — เพิ่ม project ใหม่ที่นี่
EA_PROJECTS: dict[str, str] = {
    "SMC_Universal_v3":  r"C:\Users\ADMIN\Desktop\12.SMC_System\SMC_Universal_EA_v3_0_fix21\MQL5",
    # "MMF_v3":          r"C:\Users\ADMIN\Desktop\MMF_v3\MQL5",
    # "QField_EA":       r"C:\Users\ADMIN\Desktop\QField\MQL5",
    # "QuantumQueen":    r"C:\Users\ADMIN\Desktop\QuantumQueen\MQL5",
}

# ไฟล์ MQL5 ในตัว KB เอง (EA ที่ source อยู่ใน KB)
KB_SOURCE_FILES: dict[str, str] = {
    # เพิ่ม path ของไฟล์ .mq5 ที่อยู่ใน KB ได้ที่นี่
}

# Historical data
HISTDATA_PATH = os.path.join(KB_PATH, "raw", "HISTDATA_COM_MT_XAUUSD")

def get_project_path(name: str) -> str | None:
    return EA_PROJECTS.get(name)

def list_projects() -> str:
    lines = ["EA Projects ที่รู้จัก:"]
    for name, path in EA_PROJECTS.items():
        exists = "OK" if os.path.exists(path) else "NOT FOUND"
        lines.append(f"  {name:25s} [{exists}]  {path}")
    return "\n".join(lines)
