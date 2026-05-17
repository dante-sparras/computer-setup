# computer-setup

Modern cross-platform dotfiles managed with [Chezmoi](https://chezmoi.io/).

## Quick Start (One-Liner)

**Linux / WSL / macOS** — Recommended:

```bash
curl -fsSL https://raw.githubusercontent.com/dante-sparras/computer-setup/main/setup.sh | bash
```

This single command will:
- Clone the repository (if needed)
- Install Chezmoi + modern CLI tools
- Apply all dotfiles
- Set up your environment

**Windows (PowerShell)**
```powershell
irm https://raw.githubusercontent.com/dante-sparras/computer-setup/main/setup.ps1 | iex
```

> **Note**: `setup.ps1` handles Windows UI apps, settings, and WSL Fedora bootstrap. All CLI tools run via the Linux/WSL `setup.sh`.

---

## What the scripts do

1. **Phase 1**: Install base tools and environment (OS-specific)
2. **Phase 2**: Apply dotfiles with Chezmoi
3. **Phase 3** (optional): Restore Hermes Agent from Proton Drive backup

---

## Manual / Advanced Usage

### Set up a new machine

```bash
chezmoi init --apply "dante-sparras/computer-setup"
```

### Update on an existing machine

```bash
chezmoi update -v
```

## Development

To make changes to the dotfiles, edit the files in `~/.local/share/chezmoi`.

After making changes:

```bash
chezmoi apply -v
```

To commit changes:

```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "Your commit message"
git push
```

Hermes Agent data is automatically backed up daily to Proton Drive using rclone.

See the script header in `setup.sh` for the full two-phase pattern and separation between Windows and Linux/WSL responsibilities.
## Hermes Agent Backups (Proton Drive)

Hermes Agent configuration and data are **not** stored in this repository.

Instead, they are backed up daily to Proton Drive using `rclone`. On a fresh machine, you can restore them by running the optional Phase 3 in `setup.sh` (it uses the `proton` rclone remote).

This approach keeps sensitive Hermes state (API keys, sessions, skills, etc.) out of version control.
