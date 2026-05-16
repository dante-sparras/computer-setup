# =============================================================================
# computer-setup - Universal Environment Setup Script (Windows)
# =============================================================================
# This script:
#   1. Sets up the base Windows environment
#   2. Then applies all dotfiles using Chezmoi
#
# Usage: Run in PowerShell (preferably as Administrator)
# =============================================================================

$ErrorActionPreference = "Stop"

function Write-Phase { param([string]$Text) Write-Host "`n=== $Text ===" -ForegroundColor Cyan }
function Write-Info  { param([string]$Text) Write-Host "[INFO] $Text" -ForegroundColor Blue }
function Write-Success { param([string]$Text) Write-Host "[SUCCESS] $Text" -ForegroundColor Green }
function Write-Warn  { param([string]$Text) Write-Host "[WARN] $Text" -ForegroundColor Yellow }
function Write-ErrorMsg { param([string]$Text) Write-Host "[ERROR] $Text" -ForegroundColor Red; exit 1 }

# =============================================================================
# PHASE 1: Windows Environment Setup
# =============================================================================

function Install-Chezmoi {
    if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
        Write-Info "Chezmoi already installed: $(chezmoi --version | Select-Object -First 1)"
        return
    }

    Write-Info "Installing Chezmoi..."
    $installScript = Invoke-WebRequest -UseBasicParsing https://chezmoi.io/get.ps1
    Invoke-Expression $installScript.Content

    # Add to current session PATH
    $chezmoiBin = "$env:USERPROFILE\.local\bin"
    if (Test-Path $chezmoiBin) {
        $env:PATH = "$chezmoiBin;$env:PATH"
    }
}

function Install-CLI-Tools {
    Write-Info "Installing modern CLI tools via Winget..."

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Warn "Winget not found. Skipping automatic tool installation."
        return
    }

    $packages = @(
        "eza-community.eza",
        "sharkdp.bat",
        "BurntSushi.ripgrep.MSVC",
        "sharkdp.fd",
        "Git.Git",
        "Microsoft.PowerShell",
        "Starship.Starship"
    )

    foreach ($pkg in $packages) {
        try {
            winget install --id $pkg --silent --accept-package-agreements --accept-source-agreements | Out-Null
            Write-Info "Installed/verified: $pkg"
        } catch {
            Write-Warn "Could not install $pkg (may already be present)"
        }
    }
}

function Setup-WindowsSpecific {
    Write-Info "Applying Windows-specific configurations..."

    # Ensure Git credential manager is available (handled by dot_gitconfig.tmpl)
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git config --global credential.helper manager
    }
}

# =============================================================================
# PHASE 2: Apply Dotfiles with Chezmoi
# =============================================================================

function Apply-Dotfiles {
    Write-Phase "Applying dotfiles with Chezmoi"

    $repo = "dante-sparras/computer-setup"

    if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
        Write-ErrorMsg "Chezmoi not found. Cannot apply dotfiles."
    }

    Write-Info "Running: chezmoi init --apply $repo"
    try {
        chezmoi init --apply $repo --force
        Write-Success "Dotfiles applied successfully!"
    } catch {
        Write-Warn "Chezmoi command failed. You may need to run it manually."
    }
}

# =============================================================================
# Main
# =============================================================================

function Main {
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║     computer-setup - Full Windows Environment Bootstrap    ║" -ForegroundColor Magenta
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta

    Write-Phase "Phase 1: Windows Environment Setup"
    Install-Chezmoi
    Install-CLI-Tools
    Setup-WindowsSpecific

    Write-Phase "Phase 2: Dotfiles Application"
    Apply-Dotfiles

    Write-Host ""
    Write-Success "🎉 Complete environment setup finished!"
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Restart your terminal" -ForegroundColor Yellow
    Write-Host "  2. Run 'chezmoi update' to pull latest changes" -ForegroundColor Yellow
    Write-Host "  3. Edit configs in %USERPROFILE%\.local\share\chezmoi" -ForegroundColor Yellow
    Write-Host ""
}

Main