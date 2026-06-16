import os


def list_dir(path: str) -> str:
    if not os.path.exists(path):
        return f"ไม่พบ path: {path}"
    entries = []
    for name in sorted(os.listdir(path)):
        full = os.path.join(path, name)
        entries.append(f"[DIR] {name}/" if os.path.isdir(full) else name)
    return "\n".join(entries) if entries else "(ว่างเปล่า)"


def read_file(path: str, max_chars: int = 20000) -> str:
    if not os.path.exists(path):
        return f"ไม่พบไฟล์: {path}"
    try:
        with open(path, encoding="utf-8") as f:
            content = f.read()
        if len(content) > max_chars:
            return content[:max_chars] + f"\n\n[...ตัดเนื้อหา — ไฟล์ยาว {len(content)} ตัวอักษร]"
        return content
    except Exception as e:
        return f"Error: {e}"


def find_files(root: str, extension: str) -> str:
    results = []
    for dirpath, _, filenames in os.walk(root):
        for f in filenames:
            if f.endswith(extension):
                rel = os.path.relpath(os.path.join(dirpath, f), root)
                results.append(rel)
    return "\n".join(sorted(results)) if results else "ไม่พบไฟล์"


def agent_loop(client, model: str, system: str, tools: list, task: str,
               tool_executor, label: str = "agent") -> str:
    messages = [{"role": "user", "content": task}]

    while True:
        response = client.messages.create(
            model=model,
            max_tokens=8192,
            thinking={"type": "adaptive"},
            system=system,
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
                    print(f"  [{label}] 🔧 {block.name}({list(block.input.values())[0] if block.input else ''})")
                    result = tool_executor(block.name, block.input)
                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": block.id,
                        "content": result,
                    })
            messages.append({"role": "user", "content": tool_results})
