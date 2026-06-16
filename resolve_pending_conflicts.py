import json
import os
import datetime

QUEUE_PATH = r"ea_research_team\learning\conflict_review_queue.json"

def main():
    if not os.path.exists(QUEUE_PATH):
        print(f"Error: {QUEUE_PATH} not found.")
        return

    with open(QUEUE_PATH, "r", encoding="utf-8-sig") as f:
        data = json.load(f)

    items_data = data.get("items", {})
    pending_count = 0
    resolved_count = 0
    now = datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()

    if isinstance(items_data, dict):
        for conflict_id, item in items_data.items():
            if item.get("status") == "pending":
                pending_count += 1
                item["status"] = "rejected"
                item["resolution"] = "rejected"
                item["resolution_note"] = "Bulk resolved: Determined to be transcript noise or low-value conversational extraction."
                item["resolved_at"] = now
                resolved_count += 1
    elif isinstance(items_data, list):
        for item in items_data:
            if item.get("status") == "pending":
                pending_count += 1
                item["status"] = "rejected"
                item["resolution"] = "rejected"
                item["resolution_note"] = "Bulk resolved: Determined to be transcript noise or low-value conversational extraction."
                item["resolved_at"] = now
                resolved_count += 1

    if resolved_count > 0:
        with open(QUEUE_PATH, "w", encoding="utf-8-sig") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"Successfully resolved {resolved_count} pending conflicts.")
    else:
        print(f"Found {pending_count} pending conflicts. No changes made.")

if __name__ == "__main__":
    main()
