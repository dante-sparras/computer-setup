# computer-setup

Modern cross-platform dotfiles managed with [Chezmoi](https://chezmoi.io/).

## Quick Start (Recommended)

Run the universal setup script for your platform:

**Linux / WSL / macOS**
```bash
git clone https://github.com/dante-sparras/computer-setup.git ~/Projects/computer-setup
cd ~/Projects/computer-setup
./setup.sh
```

**Windows (PowerShell)**
```powershell
git clone https://github.com/dante-sparras/computer-setup.git $env:USERPROFILE\Projects\computer-setup
cd $env:USERPROFILE\Projects\computer-setup
.\setup.ps1
```

The scripts will:
1. Install Chezmoi and modern CLI tools based on your OS
2. Apply all dotfiles automatically

## Manual Setup

### Prerequisites
- [Chezmoi](https://chezmoi.io/)

### Set up a new machine
```bash
chezmoi init --apply "dante-sparras/computer-setup"
```

### Update on an existing machine
```bash
chezmoi update -v
```

## Development

To make changes to the dotfiles, edit the files in `~/.local/share/chezmoi` (or `%USERPROFILE%\.local\share\chezmoi` on Windows).

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

## Hermes Agent Backups (Proton Drive)

Hermes Agent data (config, memory, skills, sessions, etc.) is automatically backed up daily to Proton Drive using rclone.

### Backup Location
- **Proton Drive folder**: `Hermes Backups/`
- Each backup is timestamped (e.g. `20260516_143312/`)

### Restore on a New Machine

1. Install rclone and configure Proton Drive remote:
   ```bash
   curl -s https://rclone.org/install.sh | sudo bash
   rclone config          # Create remote named exactly "proton" using protondrive backend
   ```

2. Download the latest backup:
   ```bash
   mkdir -p ~/Backups/hermes
   rclone copy "proton:Hermes Backups" ~/Backups/hermes --max-age 7d
   ```

3. Restore the most recent backup:
   ```bash
   LATEST=$(ls -1 ~/Backups/hermes | tail -1)
   cp -a ~/Backups/hermes/$LATEST/* ~/.hermes/
   ```

4. Restart Hermes (or the gateway).

The daily cron job will automatically resume after the first successful backup run.