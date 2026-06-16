import re

# Fix mt5_cli.py
mt5_file = r'G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\learning\mt5_cli.py'
with open(mt5_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace subprocess.run to add timeout
new_mt5 = content.replace(
    'result = subprocess.run(cmd, capture_output=True, text=True)',
    '''try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
    except subprocess.TimeoutExpired:
        print("[-] Compilation timed out! metaeditor64.exe might be stuck or waiting for UI interaction. Killing it...")
        os.system('taskkill /f /im metaeditor64.exe')
        return False'''
)

with open(mt5_file, 'w', encoding='utf-8') as f:
    f.write(new_mt5)


# Fix auto_backtest_resolver.py
resolver_file = r'G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\learning\auto_backtest_resolver.py'
with open(resolver_file, 'r', encoding='utf-8') as f:
    rcontent = f.read()

# Add a break/sys.exit on fatal API errors
new_resolver = rcontent.replace(
    'except Exception as e:\n            print(f"[-] Generation failed for Variant {variant_name}: {e}")\n            return False',
    '''except Exception as e:
            err_str = str(e).lower()
            print(f"[-] Generation failed for Variant {variant_name}: {e}")
            if "credit balance is too low" in err_str or "api key" in err_str or "429" in err_str:
                print("[!] CRITICAL: API Credit/Quota error detected. Halting entire script to prevent infinite billing loop.")
                sys.exit(1)
            return False'''
)

with open(resolver_file, 'w', encoding='utf-8') as f:
    f.write(new_resolver)
