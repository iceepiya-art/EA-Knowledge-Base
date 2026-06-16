import os

path = 'g:/My Drive/save log-blueprint-skill/EA-Knowledge-Base/ea_research_team/learning/server.py'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

target = """def get_trades():
        try:
            base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
            trades_path = os.path.join(base_dir, 'trades_log.csv')
            if not os.path.exists(trades_path):"""

replacement = """def get_trades():
        try:
            base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
            trades_path = os.path.join(base_dir, 'trades_log.csv')
            vps_trades_path = os.path.join(base_dir, 'vps_data', 'trades_log.csv')
            
            # Prefer VPS synced trades if available and newer, otherwise use local
            final_path = trades_path
            if os.path.exists(vps_trades_path):
                if not os.path.exists(trades_path) or os.path.getmtime(vps_trades_path) > os.path.getmtime(trades_path):
                    final_path = vps_trades_path

            if not os.path.exists(final_path):"""

content = content.replace(target, replacement)

target2 = """            with open(trades_path, 'r', encoding='utf-8') as f:"""
replacement2 = """            with open(final_path, 'r', encoding='utf-8') as f:"""

content = content.replace(target2, replacement2)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated server.py successfully!")
