"""
Learning System Runner
─────────────────────
คำสั่ง:
  python run.py collect               → ดึงข้อมูลใหม่ + summarize → เข้า queue
  python run.py review                → เปิด Review UI ที่ http://localhost:5055
  python run.py write                 → เขียน approved items ลง Obsidian
  python run.py status                → แสดงสถานะ queue
  python run.py atoms                 → ดู atomic insights ที่สะสม
  python run.py learn_nb <id>         → query NotebookLM notebook → เข้า queue
  python run.py nb_list               → แสดง notebooks ทั้งหมดใน NotebookLM
  python run.py preview_nb <id>       → ดู overview ของ notebook ก่อน chat
  python run.py chat_nb <id>          → chat กับ Claude ในบทบาทผู้เชี่ยวชาญ
  python run.py trade_stats           → วิเคราะห์ trade log ทั้งหมด
  python run.py import_mt5 <file>     → import trade history จาก MT5
  python run.py all                   → collect + review (ทำทีเดียว)
"""
import sys
import os
from datetime import datetime
from pathlib import Path
sys.stdout.reconfigure(encoding="utf-8")
sys.path.insert(0, os.path.dirname(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))


def cmd_collect():
    print("=" * 50)
    print("📡 COLLECT — ดึงข้อมูลจากทุก sources")
    print("=" * 50)

    from sources.ai_news           import fetch as fetch_ai
    from sources.ai_models         import fetch as fetch_models
    from sources.arena_tracker     import fetch as fetch_arena
    from sources.macro_news        import fetch as fetch_macro
    from sources.market_data       import fetch as fetch_market
    from sources.trading_learn     import fetch as fetch_trading
    from sources.babypips          import fetch as fetch_babypips
    from sources.notebooklm_source import fetch as fetch_notebooklm
    from summarizer import summarize
    from queue_store import add_item, find_duplicate
    from filter import filter_items

    all_items = []
    all_items.extend(fetch_arena(days_back=7))        # arena.ai value analysis
    all_items.extend(fetch_market(days_back=7))       # Yahoo Finance volatility
    all_items.extend(fetch_ai(days_back=3))
    all_items.extend(fetch_models(days_back=7))
    all_items.extend(fetch_macro(days_back=3))
    all_items.extend(fetch_trading(days_back=7))
    all_items.extend(fetch_babypips(days_back=7))
    all_items.extend(fetch_notebooklm(days_back=7))   # NotebookLM personal knowledge

    print(f"\n📊 ดึงมาทั้งหมด {len(all_items)} รายการ — กำลัง pre-filter...")
    passed, rejected = filter_items(all_items)
    print(f"✅ ผ่าน filter: {len(passed)} | ❌ ตัดทิ้ง: {len(rejected)} (ไม่เสีย token)")
    print(f"🤖 กำลัง summarize {len(passed)} รายการ...")

    added = 0
    skipped_duplicates = 0
    seen_batch = set()
    for i, item in enumerate(passed, 1):
        score_tag = f"[score={item.get('_score',0)}]"
        print(f"  [{i}/{len(passed)}] {score_tag} {item['title'][:55]}...")
        dedupe_key = (
            item.get("url", "").strip().lower()
            or f"{item['source'].strip().lower()}::{item['title'].strip().lower()}"
        )
        if dedupe_key in seen_batch:
            skipped_duplicates += 1
            print("      -> skipped duplicate in current batch")
            continue
        seen_batch.add(dedupe_key)
        if find_duplicate(item["title"], item["source"], item.get("url", "")):
            skipped_duplicates += 1
            print("      -> skipped duplicate")
            continue
        item = summarize(item)
        add_item(
            title      = item["title"],
            source     = item["source"],
            category   = item["category"],
            content    = item["content"],
            summary    = item["summary"],
            draft_note = item["draft_note"],
            url        = item.get("url", ""),
        )
        added += 1

    print(f"\n✅ เพิ่ม {added} รายการเข้า queue แล้ว")
    if skipped_duplicates:
        print(f"ℹ️ ข้ามรายการซ้ำ {skipped_duplicates} รายการ")
    print("👉 รัน: python run.py review  เพื่อ review")


def cmd_review():
    print("🌐 เปิด Review UI ที่ http://localhost:5055")
    from review_app import app
    app.run(host="0.0.0.0", port=5055, debug=True)


def cmd_write():
    print("=" * 50)
    print("💾 WRITE — บันทึก approved items ลง Obsidian")
    print("=" * 50)
    from writer import write_all_approved
    count = write_all_approved()
    print(f"\n✅ บันทึกแล้ว {count} รายการ")


def cmd_atoms():
    from atom_store import count_atoms, get_recent_atoms
    total = count_atoms()
    print("=" * 40)
    print(f"⚛️  ATOMS — {total} insights สะสม")
    print("=" * 40)
    recent = get_recent_atoms(10)
    for a in recent:
        conf_icon = {"high":"🟢","medium":"🟡","low":"🔴"}.get(a.get("confidence",""),"⚪")
        applies = ", ".join(a.get("applies_to",[]))
        print(f"  {conf_icon} [{a.get('topic','-')}] {a.get('insight','')[:60]}")
        if applies:
            print(f"       → {applies}")


def cmd_status():
    from queue_store import count_by_status, get_pending
    counts = count_by_status()
    print("=" * 40)
    print("📊 QUEUE STATUS")
    print("=" * 40)
    print(f"  ⏳ Pending  : {counts['pending']}")
    print(f"  ✅ Approved : {counts['approved']}")
    print(f"  ❌ Rejected : {counts['rejected']}")
    print(f"  💾 Written  : {counts['written']}")
    total = sum(counts.values())
    print(f"  📋 Total    : {total}")

    pending = get_pending()
    if pending:
        print(f"\n⏳ รอ Review ({len(pending)} รายการ):")
        for item in pending[:5]:
            icon = {"AI_Updates":"🤖","Macro_News":"📰","Trading_Learn":"📚"}.get(item["category"],"📄")
            print(f"  {icon} [{item['id']}] {item['title'][:55]}")
        if len(pending) > 5:
            print(f"  ... และอีก {len(pending)-5} รายการ")


def cmd_all():
    cmd_collect()
    print("\n")
    cmd_review()


def cmd_nb_list():
    """แสดง notebooks ทั้งหมดใน NotebookLM"""
    import asyncio
    from notebooklm import NotebookLMClient

    async def _list():
        client = await NotebookLMClient.from_storage()
        async with client:
            notebooks = await asyncio.wait_for(
                client.notebooks.list(),
                timeout=ask_timeout_seconds,
            )
            print("=" * 65)
            print("📓 NotebookLM Notebooks")
            print("=" * 65)
            for i, nb in enumerate(notebooks):
                print(f"  [{i:2d}] {nb.id[:8]}... {nb.title[:48]}")
            print(f"\n  รวม {len(notebooks)} notebooks")
            print("  ใช้ ID เต็มกับ: python run.py learn_nb <full-id>")

    asyncio.run(_list())


# คำถามมาตรฐานตาม category ของ notebook
_DEFAULT_QUESTIONS = [
    "Summarize the top 3 most actionable insights or strategies. Be specific with rules and numbers.",
    "What are the key entry/exit conditions or decision rules covered? List them clearly.",
    "What warnings, risks, or common mistakes are mentioned? What should be avoided?",
]

_AI_QUESTIONS = [
    "Summarize the main AI/ML techniques or tools discussed. What are the practical use cases?",
    "What workflows or architectures are recommended? Describe the key components.",
    "What are the key limitations or trade-offs mentioned?",
]


def cmd_learn_nb(nb_id: str):
    """Query notebook → summarize → เข้า queue"""
    import asyncio
    from notebooklm import NotebookLMClient
    from summarizer import summarize
    from queue_store import add_item, find_duplicate
    ask_timeout_seconds = 150
    total_timeout_seconds = 600
    max_retries = 2

    print("=" * 55)
    print(f"🎓 LEARN_NB — query notebook {nb_id[:8]}...")
    print("=" * 55)

    async def _ask_with_timeout(client, notebook_id: str, prompt: str):
        for attempt in range(1, max_retries + 2):
            try:
                return await asyncio.wait_for(
                    client.chat.ask(notebook_id, prompt),
                    timeout=ask_timeout_seconds,
                )
            except Exception as exc:
                is_timeout = isinstance(exc, (asyncio.TimeoutError, TimeoutError)) or \
                             "timed out" in str(exc).lower() or "timeout" in str(exc).lower()
                if is_timeout and attempt <= max_retries:
                    print(f"      → timeout, retry {attempt}/{max_retries}...")
                    await asyncio.sleep(15)
                else:
                    raise

    async def _query():
        client = await NotebookLMClient.from_storage()
        async with client:
            # หาชื่อ notebook
            notebooks = await client.notebooks.list()
            nb_name = next((nb.title for nb in notebooks if nb.id == nb_id), nb_id[:8])
            print(f"  Notebook: {nb_name}")

            # ตรวจ content เพื่อเลือก questions
            print("  Detecting notebook category...")
            probe = await _ask_with_timeout(
                client,
                nb_id,
                "Is this content about AI/technology or trading/finance?",
            )
            answer_lower = probe.answer.lower()
            is_ai = any(w in answer_lower for w in ["ai", "claude", "llm", "agent", "technology", "software"])
            questions = _AI_QUESTIONS if is_ai else _DEFAULT_QUESTIONS
            category  = "AI_Updates" if is_ai else "Trading_Learn"
            print(f"  Category: {category}")

            results = []
            for i, q in enumerate(questions, 1):
                print(f"  Q{i}: {q[:60]}...")
                ans = await _ask_with_timeout(client, nb_id, q)
                if ans.answer and len(ans.answer) > 80:
                    skip_phrases = ["do not contain", "no information", "not mentioned", "cannot answer"]
                    if not any(p in ans.answer.lower() for p in skip_phrases):
                        results.append((q, ans.answer))
                        print(f"      → OK ({len(ans.answer)} chars)")
                    else:
                        print(f"      → skipped (no relevant content)")

            return nb_name, category, results

    try:
        nb_name, category, qa_pairs = asyncio.run(
            asyncio.wait_for(_query(), timeout=total_timeout_seconds)
        )
    except TimeoutError:
        print(f"âŒ Learn Notebook timed out after {total_timeout_seconds} seconds")
        raise RuntimeError(
            f"Learn Notebook timed out after {total_timeout_seconds} seconds"
        )

    if not qa_pairs:
        print("❌ ไม่พบ content ที่เกี่ยวข้อง")
        return

    # รวมทุก Q&A เป็น 1 item ต่อ notebook
    content_parts = [f"**Q: {q}**\n\n{a}" for q, a in qa_pairs]
    content = "\n\n---\n\n".join(content_parts)
    title = f"[NotebookLM Video] {nb_name}"

    item = {
        "title":    title,
        "source":   f"NotebookLM/{nb_name}",
        "category": category,
        "content":  content,
        "url":      f"https://notebooklm.google.com/notebook/{nb_id}",
        "_score":   30,
    }

    if find_duplicate(item["title"], item["source"], item.get("url", "")):
        print(f"\nℹ️ มีรายการนี้อยู่ใน queue แล้ว: {title[:55]}")
        return

    item = summarize(item)
    add_item(
        title      = item["title"],
        source     = item["source"],
        category   = item["category"],
        content    = item["content"],
        summary    = item["summary"],
        draft_note = item["draft_note"],
        url        = item.get("url", ""),
    )

    print(f"\n✅ เพิ่มเข้า queue แล้ว: {title[:55]}")
    print("👉 รัน: python run.py review  เพื่อ approve แล้ว write")


def cmd_quality_nb(nb_id: str) -> str:
    """Create a NotebookLM ingestion quality report in the Obsidian vault."""
    import asyncio
    from notebooklm import NotebookLMClient

    ask_timeout_seconds = 240
    total_timeout_seconds = 1800
    max_retries = 3

    print("=" * 60)
    print(f"NOTEBOOKLM QUALITY CHECK - {nb_id[:8]}...")
    print("=" * 60)

    prompts = [
        (
            "Source Inventory",
            "List every source, document, video, file, web page, or folder that appears to be available in this notebook. "
            "For each source, include its apparent title, type, and whether the content looks readable. "
            "If exact source names are not visible, say that clearly instead of guessing.",
        ),
        (
            "Coverage Map",
            "Map the main topics covered by this notebook. Also list weakly covered, missing, or suspiciously shallow areas. "
            "Be direct about gaps, duplicates, and anything that looks incomplete.",
        ),
        (
            "Top Useful Insights",
            "Extract the 10 most concrete and useful insights from this notebook. Prefer rules, numbers, workflows, warnings, "
            "examples, strategy conditions, and implementation details over generic summaries.",
        ),
        (
            "EA And System Relevance",
            "Evaluate what is useful for our EA trading system, risk management, strategy research, AI agents, NotebookLM workflow, "
            "or dashboard/product design. Give practical action items and label each as high, medium, or low value.",
        ),
        (
            "Ingestion Quality Score",
            "Score the NotebookLM ingestion quality from 0 to 100. Judge whether the notebook likely imported enough useful content. "
            "Mention signs of missing sources, unreadable files, low-detail answers, duplicate material, or strong coverage. "
            "End with a clear verdict: READY_TO_LEARN, NEED_MORE_SOURCES, or REIMPORT_REQUIRED.",
        ),
    ]

    async def _ask(client, notebook_id: str, prompt: str):
        for attempt in range(1, max_retries + 2):
            try:
                return await asyncio.wait_for(
                    client.chat.ask(notebook_id, prompt),
                    timeout=ask_timeout_seconds,
                )
            except Exception as exc:
                is_timeout = isinstance(exc, (asyncio.TimeoutError, TimeoutError)) or \
                             "timed out" in str(exc).lower() or "timeout" in str(exc).lower()
                if is_timeout and attempt <= max_retries:
                    print(f"    -> timeout, retry {attempt}/{max_retries}...")
                    await asyncio.sleep(15)
                else:
                    raise

    async def _query():
        client = await NotebookLMClient.from_storage()
        async with client:
            notebooks = await client.notebooks.list()
            nb_name = next((nb.title for nb in notebooks if nb.id == nb_id), nb_id[:8])
            print(f"Notebook: {nb_name}")

            sections = []
            for index, (title, prompt) in enumerate(prompts, 1):
                print(f"[{index}/{len(prompts)}] {title}...")
                answer = await _ask(client, nb_id, prompt)
                text = (answer.answer or "").strip()
                sections.append((title, text))
                print(f"    -> {len(text)} chars")
            return nb_name, sections

    try:
        nb_name, sections = asyncio.run(
            asyncio.wait_for(_query(), timeout=total_timeout_seconds)
        )
    except TimeoutError:
        print(f"NotebookLM quality check timed out after {total_timeout_seconds} seconds")
        raise RuntimeError(
            f"NotebookLM quality check timed out after {total_timeout_seconds} seconds"
        )

    vault_root = Path(__file__).resolve().parents[2]
    report_dir = vault_root / "10_Research" / "NotebookLM_Quality"
    report_dir.mkdir(parents=True, exist_ok=True)

    safe_name = "".join(ch if ch.isalnum() or ch in (" ", "-", "_") else "_" for ch in nb_name).strip()
    safe_name = "_".join(safe_name.split())[:80] or nb_id[:8]
    timestamp = datetime.now().strftime("%Y-%m-%d_%H%M%S")
    report_path = report_dir / f"{timestamp}_NotebookLM_Quality_{safe_name}.md"

    lines = [
        "# NotebookLM Quality Report",
        "",
        f"- Created: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        f"- Notebook: {nb_name}",
        f"- Notebook ID: `{nb_id}`",
        f"- URL: https://notebooklm.google.com/notebook/{nb_id}",
        "",
        "## How To Use This",
        "",
        "Use this report before pressing Learn Notebook. If the verdict says READY_TO_LEARN, the notebook is probably good enough to import into Learning Review. If it says NEED_MORE_SOURCES or REIMPORT_REQUIRED, add or fix sources in NotebookLM first.",
        "",
    ]
    for title, text in sections:
        lines.extend([f"## {title}", "", text or "_No answer returned._", ""])

    report_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"\nQuality report written: {report_path}")
    return str(report_path)


def cmd_learn_yt_channel(channel_url: str):
    """Learn recent relevant videos from a YouTube channel into the review queue."""
    from youtube_channel_learning import learn_channel

    print("=" * 60)
    print(f"YOUTUBE CHANNEL LEARN - {channel_url[:48]}")
    print("=" * 60)

    result = learn_channel(channel_url)
    print(f"\nChannel: {result['channel_name']}")
    print(f"Scanned: {result['scanned']}")
    print(f"Added to queue: {result['added']}")
    print(f"Processed with transcript: {result['processed']}")
    if result["skipped_duplicates"]:
        print(f"Skipped duplicates: {result['skipped_duplicates']}")
    if result["skipped_irrelevant"]:
        print(f"Skipped low relevance: {result['skipped_irrelevant']}")
    if result["skipped_missing_transcript"]:
        print(f"Skipped no transcript: {result['skipped_missing_transcript']}")
    if result["errors"]:
        print("Errors:")
        for err in result["errors"][:5]:
            print(f"  - {err}")


def cmd_preview_nb(nb_id: str):
    """ดู overview ของ notebook ว่ามีอะไรบ้าง ก่อนตัดสินใจ chat"""
    import asyncio
    from notebooklm import NotebookLMClient

    async def _preview():
        client = await NotebookLMClient.from_storage()
        async with client:
            notebooks = await client.notebooks.list()
            nb_name = next((nb.title for nb in notebooks if nb.id == nb_id), nb_id[:8])

            print("=" * 60)
            print(f"📋 PREVIEW: {nb_name}")
            print("=" * 60)

            # ถาม overview กว้างๆ
            q1 = await client.chat.ask(nb_id,
                "List all the main topics and sections covered in this content. "
                "Format as a numbered list with 1-line description each.")
            print("\n📌 หัวข้อที่พูดถึง:")
            print(q1.answer)

            q2 = await client.chat.ask(nb_id,
                "Who is the target audience and what level of knowledge is assumed? "
                "What will someone learn after finishing this content?")
            print("\n🎯 เหมาะกับใคร / เรียนรู้อะไร:")
            print(q2.answer)

            q3 = await client.chat.ask(nb_id,
                "What are the 3 most valuable or unique insights that are NOT commonly known? "
                "These should be the key reasons to study this content.")
            print("\n💎 ทำไมถึงควรเรียน (unique insights):")
            print(q3.answer)

            print("\n" + "=" * 60)
            print(f"💡 ถ้าอยากคุยละเอียด รัน:")
            print(f"   python run.py chat_nb {nb_id}")
            print("=" * 60)

    asyncio.run(_preview())


def cmd_chat_nb(nb_id: str):
    """Chat กับ Claude ที่สวมบทบาทผู้เชี่ยวชาญจาก notebook"""
    import asyncio
    import anthropic
    from notebooklm import NotebookLMClient

    # ── Step 1: ดึง overview จาก NotebookLM ──────────────────
    async def _get_context():
        client = await NotebookLMClient.from_storage()
        async with client:
            notebooks = await client.notebooks.list()
            nb_name = next((nb.title for nb in notebooks if nb.id == nb_id), nb_id[:8])

            print(f"⚙️  กำลังโหลดเนื้อหาจาก: {nb_name}...")

            overview = await client.chat.ask(nb_id,
                "Give a comprehensive summary of ALL content: main concepts, key techniques, "
                "important rules/numbers, examples, and actionable advice. Be thorough.")

            expertise = await client.chat.ask(nb_id,
                "What specific expertise, knowledge, and unique perspective does the author/speaker have? "
                "What makes their approach distinctive?")

            return nb_name, overview.answer, expertise.answer

    nb_name, overview, expertise = asyncio.run(_get_context())

    # ── Step 2: สร้าง system prompt ───────────────────────────
    system_prompt = f"""คุณคือผู้เชี่ยวชาญที่มีความรู้ลึกซึ้งจากเนื้อหาต่อไปนี้:

**แหล่งความรู้:** {nb_name}

**เนื้อหาที่คุณรู้ทั้งหมด:**
{overview}

**ความเชี่ยวชาญพิเศษของคุณ:**
{expertise}

**วิธีตอบ:**
- ตอบในฐานะผู้เชี่ยวชาญที่รู้เนื้อหานี้อย่างลึกซึ้ง
- ให้ข้อมูลละเอียด เฉพาะเจาะจง พร้อม rules และตัวเลขจริง
- ถ้ามีคำถามที่เนื้อหาไม่ครอบคลุม บอกตรงๆ แล้วให้ความเห็นจาก general knowledge
- ตอบเป็นภาษาไทยเสมอ
- ใช้ bullet points และ structure ที่ชัดเจน"""

    # ── Step 3: Interactive chat loop ────────────────────────
    print("\n" + "=" * 60)
    print(f"🎭 CHAT MODE: {nb_name}")
    print("=" * 60)
    print("พิมพ์คำถามได้เลย | พิมพ์ 'quit' หรือ 'exit' เพื่อออก")
    print("-" * 60)

    claude_client = anthropic.Anthropic()
    history = []

    while True:
        try:
            user_input = input("\nคุณ: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\n👋 ออกจาก chat mode")
            break

        if user_input.lower() in ("quit", "exit", "q", "ออก"):
            print("👋 ออกจาก chat mode")
            break
        if not user_input:
            continue

        history.append({"role": "user", "content": user_input})

        print("\nผู้เชี่ยวชาญ: ", end="", flush=True)
        response_text = ""

        with claude_client.messages.stream(
            model="claude-haiku-4-5-20251001",
            max_tokens=1500,
            system=system_prompt,
            messages=history,
        ) as stream:
            for text in stream.text_stream:
                print(text, end="", flush=True)
                response_text += text

        print()
        history.append({"role": "assistant", "content": response_text})

        # เก็บ history ไม่เกิน 10 turns เพื่อประหยัด token
        if len(history) > 20:
            history = history[-20:]


def cmd_trade_stats():
    """วิเคราะห์ trade log ทั้งหมด"""
    trade_log_path = os.path.join(os.path.dirname(__file__), "..", "trade_log")
    sys.path.insert(0, trade_log_path)
    from analyzer import full_report
    print(full_report())


def cmd_import_mt5(filepath: str):
    """Import trade history จาก MT5 HTML/CSV"""
    trade_log_path = os.path.join(os.path.dirname(__file__), "..", "trade_log")
    sys.path.insert(0, trade_log_path)
    from import_mt5 import import_file
    print("=" * 50)
    print(f"📥 IMPORT MT5 — {os.path.basename(filepath)}")
    print("=" * 50)
    import_file(filepath)


def cmd_enrich_trades():
    """Backfill SC100 / beta1 / regime for existing trades."""
    trade_log_path = os.path.join(os.path.dirname(__file__), "..", "trade_log")
    sys.path.insert(0, trade_log_path)
    from trade_store import enrich_missing_contexts
    print("=" * 50)
    print("ENRICH TRADES - backfill SC100 / beta1 / regime")
    print("=" * 50)
    updated = enrich_missing_contexts()
    print(f"\nUpdated {updated} trades")


COMMANDS = {
    "collect":     cmd_collect,
    "review":      cmd_review,
    "write":       cmd_write,
    "status":      cmd_status,
    "atoms":       cmd_atoms,
    "all":         cmd_all,
    "nb_list":     cmd_nb_list,
    "trade_stats": cmd_trade_stats,
    "enrich_trades": cmd_enrich_trades,
    "learn_nb":    None,
    "quality_nb":  None,
    "learn_yt_channel": None,
    "preview_nb":  None,
    "chat_nb":     None,
    "import_mt5":  None,
}

if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "status"

    if cmd in ("learn_nb", "quality_nb", "preview_nb", "chat_nb", "learn_yt_channel"):
        if len(sys.argv) < 3:
            print(f"Usage: python run.py {cmd} <notebook-id>")
            print("       python run.py nb_list   ← ดู IDs ทั้งหมด")
            sys.exit(1)
        if cmd == "learn_nb":
            cmd_learn_nb(sys.argv[2])
        elif cmd == "quality_nb":
            cmd_quality_nb(sys.argv[2])
        elif cmd == "preview_nb":
            cmd_preview_nb(sys.argv[2])
        elif cmd == "chat_nb":
            cmd_chat_nb(sys.argv[2])
        elif cmd == "learn_yt_channel":
            cmd_learn_yt_channel(sys.argv[2])
    elif cmd == "import_mt5":
        if len(sys.argv) < 3:
            print("Usage: python run.py import_mt5 <file.html|file.csv>")
            print("วิธี export จาก MT5: History tab → Right Click → Save as Report")
            sys.exit(1)
        cmd_import_mt5(sys.argv[2])
    elif cmd in COMMANDS and COMMANDS[cmd] is not None:
        COMMANDS[cmd]()
    else:
        print(f"คำสั่งไม่ถูกต้อง: {cmd}")
        print(f"คำสั่งที่ใช้ได้: {', '.join(COMMANDS)}")
        sys.exit(1)
