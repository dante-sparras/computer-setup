---
name: dotfiles
description: Manage and bootstrap Chezmoi-based dotfiles repositories with cross-platform setup scripts for Linux/WSL, macOS, and Windows.
---

# Dotfiles Management

This skill governs working with Chezmoi-managed dotfiles repositories, including cloning/renaming repos, and creating/maintaining robust cross-platform bootstrap scripts (`setup.sh` and `setup.ps1`).

## Core Principles
- Always separate **Phase 1: OS-specific environment setup** (tool installation, shell configuration, WSL tweaks) from **Phase 2: Chezmoi dotfile application**.
- Use `gh` CLI for all GitHub operations (listing, cloning, renaming).
- Bootstrap scripts must be idempotent and non-interactive where possible.
- Detect OS early (linux, wsl, macos, windows) and branch logic accordingly.

## Workflow
1. Use `gh repo list`, `gh repo clone`, `gh repo rename` for repository operations.
2. After cloning/renaming, create or update `setup.sh` and `setup.ps1` in the repo root.
3. Scripts should:
   - Install Chezmoi first if missing.
   - Install common modern CLI tools (eza, bat, ripgrep, fd, zsh, zoxide, fzf, starship).
   - Run `chezmoi init --apply <owner/repo>` as the final step.
4. Commit and push changes using `git`.

## References
- `references/setup-script-pattern.md` — Detailed structure and best practices for the two-phase setup scripts (established in computer-setup repo work).

## Hermes Agent Integration

When the user wants to version-control their Hermes Agent setup (config + skills) inside a Chezmoi dotfiles repo:

1. Use `chezmoi add ~/.hermes/config.yaml` (becomes `private_dot_hermes/private_config.yaml`).
2. Use `chezmoi add ~/.hermes/skills` to include the entire skills library (creates `private_dot_hermes/skills/`).
3. Never commit `~/.hermes/.env` — it is automatically excluded by Chezmoi's private_ prefix and should stay out of `.chezmoiignore` only if you want it ignored explicitly.
4. After adding, commit from the Chezmoi source: `cd ~/.local/share/chezmoi && git add private_dot_hermes && git commit -m "feat: add Hermes Agent config and skills"`.
5. On other machines: `chezmoi update -v` will restore the config and skills.

**Pitfall**: The skills directory is large (~500 files). Only do a full `chezmoi add ~/.hermes/skills` when the user explicitly asks to back up the entire agent state. For lighter backups, selectively add only high-value skills or pin them via the curator.

This pattern was validated in the 2026-05-16 session with the user's `computer-setup` repo.