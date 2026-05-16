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