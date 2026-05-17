# Two-Phase Setup Script Pattern

This pattern was established during the computer-setup repo work (May 2026).

## Recommended Script Structure

### setup.sh (Bash)
- Shebang + strict mode (`set -euo pipefail`)
- Color-coded logging functions (`log`, `success`, `warn`, `error`, `phase`)
- `detect_os()` — returns linux | wsl | macos
- Phase 1 functions:
  - `install_chezmoi()`
  - `install_cli_tools()` — eza, bat, ripgrep, fd, zsh, zoxide, fzf, starship
  - `setup_wsl_specific()` (if applicable)
  - `setup_shell()` (chsh to zsh)
- Phase 2:
  - `apply_dotfiles()` — runs `chezmoi init --apply dante-sparras/computer-setup --force`
- Clear `main()` that calls phases sequentially with banners

### setup.ps1 (PowerShell)
- Similar phase separation using `Write-Phase`, `Write-Info`, etc.
- `Install-Chezmoi()` using the official get.ps1
- `Install-CLI-Tools()` using Winget
- `Setup-WindowsSpecific()` (git credential helper)
- `Apply-Dotfiles()` with `chezmoi init --apply ... --force`

## Key Rules
- Always run Chezmoi **after** the base environment is ready.
- Make scripts as idempotent as possible.
- Provide clear "Next steps" output at the end.
- Use `--force` on `chezmoi init` for first-time setups.