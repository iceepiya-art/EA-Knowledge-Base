# Two-Computer Home Deployment

## Roles

- **Office computer:** development only. Its execution setting remains disabled.
- **Home computer:** the only MT5/EA/trading-cycle execution host for the account.
- **Google Drive:** backup and reports only; never the active runtime folder.

## One-time home setup

1. Create a private Git remote and push only reviewed source code from the office machine.
2. On the home computer, run `BOOTSTRAP_HOME_RUNTIME.ps1 -RepositoryUrl <private-repository-url>`.
3. Edit `C:\EA_KB_Runtime\EA-Knowledge-Base\home_runtime.env`; set the exact MT5 `MQL5\Experts` directory and keep `EA_KB_EXECUTION_HOST=home`.
4. Copy the home-specific `.env` separately and securely. Never commit or sync it.

For a very large first install, seed `C:\EA_KB_Runtime` with an external SSD, then use Git only for later deltas.

## Every update on the home computer

Run PowerShell from the local checkout:

```powershell
.\tools\home_deploy\UPDATE_HOME_RUNTIME.ps1
```

The update performs `git pull --ff-only`, focused tests, MQL compilation, EX5 backup, deployment, byte-for-byte verification, and writes `reports/home_deploy/deploy_*.json`. It does not start a second trading cycle. Reload MasterEA_v3 on the MT5 charts after a successful deployment.

Use `-DryRun` to see all planned actions without changing Git, tests, or MT5 files.
