"""
NotebookLM Auto-Research → Obsidian
คลิก suggested questions อัตโนมัติ → บันทึกลงในโน้ต → save ลง Obsidian

Usage:
  python notebooklm_auto.py
  python notebooklm_auto.py https://notebooklm.google.com/notebook/...
"""
import asyncio
import subprocess
import sys
sys.stdout.reconfigure(encoding="utf-8")
import os
from datetime import datetime, timezone, timedelta

sys.path.insert(0, os.path.dirname(__file__))
from playwright.async_api import async_playwright, Page, TimeoutError as PWTimeout
from agents.scribe_agent import run_scribe_agent

# ====== CONFIG ======
DEFAULT_URL    = "https://notebooklm.google.com/notebook/c09d6934-2674-47a8-9933-a17f8b2e79c1"
CHROME_PROFILE = r"C:\Users\ADMIN\AppData\Local\Google\Chrome\User Data"
MAX_ROUNDS     = 6     # จำนวนรอบ (คลิกคำถาม)
ANSWER_TIMEOUT = 90    # วินาทีรอคำตอบ
# ====================

TH_TZ = timezone(timedelta(hours=7))

# ─────────────────────────────────────────────
#  Browser
# ─────────────────────────────────────────────

CHROME_EXE = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
DEBUG_PORT = 9222


def _start_chrome_debug():
    """ปิด Chrome แล้วเปิดใหม่ในโหมด Debug"""
    subprocess.run(["taskkill", "/F", "/IM", "chrome.exe"], capture_output=True)
    import time; time.sleep(2)
    subprocess.Popen([
        CHROME_EXE,
        f"--remote-debugging-port={DEBUG_PORT}",
        f"--user-data-dir={CHROME_PROFILE}",
        "--profile-directory=Default",
        "--no-first-run",
    ])
    time.sleep(3)


async def _open_browser(p):
    """เชื่อมต่อ Chrome debug port — เปิด Chrome debug เองถ้ายังไม่ได้เปิด"""
    # ลองเชื่อมต่อก่อน
    for attempt in range(2):
        try:
            browser = await p.chromium.connect_over_cdp(f"http://localhost:{DEBUG_PORT}")
            ctx = browser.contexts[0] if browser.contexts else await browser.new_context()
            print("  ✓ เชื่อมต่อ Chrome สำเร็จ")
            return ctx
        except Exception:
            if attempt == 0:
                print("  Chrome ไม่ได้เปิดในโหมด Debug — เปิดใหม่อัตโนมัติ...")
                _start_chrome_debug()

    print("  ❌ เชื่อมต่อ Chrome ไม่ได้ — ลองรันใหม่อีกครั้ง")
    sys.exit(1)


# ─────────────────────────────────────────────
#  Page helpers
# ─────────────────────────────────────────────

async def _wait_ready(page: Page):
    print(f"  URL: {page.url[:70]}")
    await asyncio.sleep(3)


async def _dismiss_dialogs(page: Page):
    """ปิด dialog ที่อาจค้างอยู่"""
    for _ in range(2):
        await page.keyboard.press("Escape")
        await asyncio.sleep(0.5)
    await asyncio.sleep(1)


async def _get_question_chips(page: Page) -> list:
    """ดึง chip คำถามที่คลิกได้ — คืน list ของ (text, element)"""
    chip_selectors = [
        "follow-up-questions-panel button",
        "[class*='follow-up'] button",
        "[class*='suggestion'] button",
        "[class*='prompt-chip']",
        "mat-chip-row",
        "[class*='suggested'] [role='button']",
        "[class*='chip']",
        # broad fallback: button ที่มีข้อความยาวพอ
        "button",
    ]
    for sel in chip_selectors:
        try:
            els = page.locator(sel)
            count = await els.count()
            if count == 0:
                continue
            chips = []
            for i in range(min(count, 20)):
                try:
                    text = (await els.nth(i).inner_text()).strip()
                    # chip คำถามมักยาว 10-120 ตัวอักษร
                    if 10 < len(text) < 150:
                        chips.append((text, els.nth(i)))
                except Exception:
                    continue
            if chips:
                print(f"    selector '{sel[:35]}' → {len(chips)} chips")
                # แสดง 3 ตัวแรก
                for t, _ in chips[:3]:
                    print(f"      · {t[:60]}")
                return chips[:4]
        except Exception:
            continue
    return []


async def _wait_answer(page: Page):
    """รอจน NotebookLM ตอบเสร็จ"""
    await asyncio.sleep(4)
    for _ in range(ANSWER_TIMEOUT // 2):
        await asyncio.sleep(2)
        loading = await page.locator(
            "mat-progress-spinner, [class*='loading'], [class*='spinner'], [class*='pending']"
        ).count()
        if loading == 0:
            break


async def _get_last_answer(page: Page) -> str:
    """ดึงคำตอบล่าสุดจาก chat"""
    for sel in [
        "message-content",
        "[class*='response'] [class*='content']",
        "[class*='model-response']",
        "[data-role='model'] [class*='content']",
        "conversation-turn:last-child",
    ]:
        try:
            els = page.locator(sel)
            if await els.count() > 0:
                text = (await els.last.inner_text()).strip()
                if len(text) > 30:
                    return text
        except Exception:
            continue

    # fallback
    try:
        area = page.locator("[class*='chat'], [class*='conversation'], [class*='messages']").first
        if await area.count() > 0:
            all_text = await area.inner_text()
            blocks = [b.strip() for b in all_text.split("\n\n") if len(b.strip()) > 30]
            if blocks:
                return blocks[-1]
    except Exception:
        pass
    return "(ดึงคำตอบไม่ได้)"


async def _click_save_to_note(page: Page) -> bool:
    """คลิกปุ่ม 'บันทึกลงในโน้ต' ของ response ล่าสุด"""
    selectors = [
        "button:has-text('บันทึกลงในโน้ต')",
        "[aria-label*='บันทึก']",
        "[aria-label*='Save to note']",
        "[aria-label*='save']",
        "[class*='save-note'] button",
        "[class*='pin'] button",
    ]
    for sel in selectors:
        try:
            btn = page.locator(sel).last
            if await btn.count() > 0:
                await btn.scroll_into_view_if_needed()
                await btn.click()
                await asyncio.sleep(1)
                print("    ✓ บันทึกลงในโน้ตแล้ว")
                return True
        except Exception:
            continue
    print("    ⚠ ไม่พบปุ่ม 'บันทึกลงในโน้ต'")
    return False


# ─────────────────────────────────────────────
#  Main pipeline
# ─────────────────────────────────────────────

async def research(notebook_url: str) -> list[dict]:
    clean_url = notebook_url.split("?")[0]
    results = []

    async with async_playwright() as p:
        ctx = await _open_browser(p)

        # หาหน้า NotebookLM ที่เปิดอยู่
        page = None
        for pg in ctx.pages:
            if "notebooklm.google.com" in pg.url:
                page = pg
                break
        if not page:
            page = ctx.pages[0] if ctx.pages else await ctx.new_page()

        await page.bring_to_front()
        await _wait_ready(page)
        await _dismiss_dialogs(page)

        all_btns = await page.locator("button").count()
        print(f"  พบ button ทั้งหมด: {all_btns} ตัว")

        for round_num in range(1, MAX_ROUNDS + 1):
            print(f"\n  --- รอบที่ {round_num} ---")

            # หา chip คำถาม
            chips = await _get_question_chips(page)
            if not chips:
                print("  ไม่พบ chip คำถาม — หยุด")
                break

            # คลิก chip แรกที่ยังไม่เคยถาม
            asked_qs = {r["q"] for r in results}
            target = None
            for text, el in chips:
                if text not in asked_qs:
                    target = (text, el)
                    break

            if not target:
                print("  chip ซ้ำทั้งหมด — หยุด")
                break

            q_text, chip_el = target
            short = q_text[:60] + "..." if len(q_text) > 60 else q_text
            print(f"  คำถาม: {short}")

            # คลิก chip
            await chip_el.scroll_into_view_if_needed()
            await chip_el.click()

            # รอคำตอบ
            await _wait_answer(page)

            # ดึงคำตอบ
            answer = await _get_last_answer(page)
            word_count = len(answer.split())
            print(f"  คำตอบ: {word_count} คำ")
            results.append({"q": q_text, "a": answer})

            # คลิกบันทึกลงในโน้ต
            await _click_save_to_note(page)
            await asyncio.sleep(2)

        await ctx.close()

    return results


def save_to_obsidian(results: list[dict], url: str) -> str:
    now  = datetime.now(TH_TZ).strftime("%Y-%m-%d %H:%M")
    date = datetime.now(TH_TZ).strftime("%Y-%m-%d")

    qa_block = "\n\n".join(
        f"**Q{i}: {r['q']}**\n\n{r['a']}"
        for i, r in enumerate(results, 1)
    )

    task = f"""สร้าง research note จาก NotebookLM แล้วบันทึกลง raw/ folder

ข้อมูล:
- Source URL: {url}
- วันที่: {now}
- จำนวน Q&A: {len(results)} ข้อ

Q&A ทั้งหมด:
{qa_block}

กรุณา write_raw_note ด้วย:
- ชื่อไฟล์: NotebookLM_{date}.md
- YAML frontmatter: tags [notebooklm, research, trading], created: {date}, source: {url}
- บรรทัดแรก: ดู [[../00_MOC]]
- จัด Q&A เป็นหมวดหมู่ให้เรียบร้อย
- ถ้ามีหลาย topic ให้แยก section"""

    return run_scribe_agent(task)


async def main():
    url = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_URL

    print("=" * 55)
    print("  NotebookLM Auto-Research → Obsidian")
    print("=" * 55)
    print(f"\n  Notebook: ...{url[-45:]}\n")

    results = await research(url)

    if not results:
        print("\n❌ ไม่ได้ Q&A — ลองรันใหม่")
        return

    print(f"\n  รวบรวม Q&A ได้ {len(results)} ข้อ")
    print("  Scribe กำลังบันทึกลง Obsidian...\n")
    output = save_to_obsidian(results, url)
    print(f"  {output}")
    print("\n✅ เสร็จ — เปิด Obsidian กด Ctrl+R")


if __name__ == "__main__":
    asyncio.run(main())
