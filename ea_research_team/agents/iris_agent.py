"""
Iris — Chart Vision Reader
รับ screenshot กราฟ → วิเคราะห์ Pattern, FVG, BOS, W/M, regime
"""
import os
import base64
import anthropic
from config import MODEL, KB_PATH
from tools.file_tools import read_file

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Iris ผู้เชี่ยวชาญอ่านกราฟ Price Action สำหรับ XAUUSD และ Forex

วิเคราะห์จากกราฟ:
- **W & M Pattern**: W2/W3 (Bull setup), M2/M3 (Bear setup) — NinjaThai system
- **BSL/SSL**: Buy/Sell Side Liquidity sweep — สังเกต spike ผ่าน high/low เดิม
- **FVG**: Fair Value Gap — 3-candle pattern, ช่องว่างที่ candle 1 กับ 3 ไม่ overlap
- **BOS/CHoCH**: Break of Structure / Change of Character
- **EMA Slope**: ชัน = Trend | แบน = Sideway | ม้วน = เปลี่ยนทิศ
- **S&D Zone**: Supply (แดง) / Demand (เขียว) — ดูจาก candle ที่ explosive
- **Regime**: ดูจาก candle pattern density — swing เยอะ = Reverting | swing น้อย = Trending

ตอบ:
1. Pattern ที่เห็น + ชื่อ (เช่น W3 Pattern)
2. Zone สำคัญ (FVG, OB, S&D) พร้อมระดับราคาโดยประมาณ
3. Setup ที่เหมาะ (Buy/Sell/Wait)
4. SL และ Target zone
5. EA ที่เหมาะกับ setup นี้"""


def _read_image(path: str) -> tuple[str, str]:
    ext = os.path.splitext(path)[1].lower()
    media_map = {".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".webp": "image/webp"}
    media_type = media_map.get(ext, "image/png")
    with open(path, "rb") as f:
        data = base64.standard_b64encode(f.read()).decode("utf-8")
    return data, media_type


def _read_ninja_guide(pattern: str) -> str:
    keywords = {"w": "W", "m": "M", "bsl": "BSL", "ssl": "SSL", "fvg": "FVG", "bos": "BOS", "choch": "CHoCH"}
    ninja_dir = os.path.join(KB_PATH, "EAs", "Ninja")
    if not os.path.exists(ninja_dir):
        return f"ไม่พบ Ninja folder"
    for fname in os.listdir(ninja_dir):
        for kw in keywords:
            if kw in pattern.lower() and keywords[kw] in fname:
                return read_file(os.path.join(ninja_dir, fname))
    return f"ไม่พบ guide สำหรับ pattern: {pattern}"


def run_iris_agent(task: str, image_path: str = None) -> str:
    if not image_path or not os.path.exists(image_path):
        return f"Iris ต้องการ image_path ที่ถูกต้อง (ได้รับ: {image_path})"

    img_data, media_type = _read_image(image_path)

    # Initial message with image
    messages = [
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {"type": "base64", "media_type": media_type, "data": img_data},
                },
                {"type": "text", "text": task},
            ],
        }
    ]

    tools = [
        {
            "name": "read_ninja_guide",
            "description": "อ่าน NinjaThai guide สำหรับ pattern ที่เห็นในกราฟ",
            "input_schema": {
                "type": "object",
                "properties": {
                    "pattern": {"type": "string", "description": "ชื่อ pattern เช่น 'W', 'M', 'BSL', 'FVG', 'BOS', 'CHoCH'"}
                },
                "required": ["pattern"],
            },
        }
    ]

    while True:
        response = client.messages.create(
            model=MODEL,
            max_tokens=4096,
            thinking={"type": "adaptive"},
            system=SYSTEM,
            tools=tools,
            messages=messages,
        )

        if response.stop_reason == "end_turn":
            for block in response.content:
                if hasattr(block, "text"):
                    return block.text
            return ""

        if response.stop_reason == "tool_use":
            messages.append({"role": "assistant", "content": response.content})
            tool_results = []
            for block in response.content:
                if block.type == "tool_use":
                    print(f"  [Iris] reading guide: {block.input.get('pattern', '')}")
                    result = _read_ninja_guide(block.input.get("pattern", ""))
                    tool_results.append({"type": "tool_result", "tool_use_id": block.id, "content": result})
            messages.append({"role": "user", "content": tool_results})
