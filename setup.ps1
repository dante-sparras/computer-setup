# =============================================================================
# computer-setup - Universal Environment Setup (Windows / PowerShell)
# =============================================================================
# This script fully sets up your development environment using Chezmoi.
# Run in PowerShell (as Administrator recommended): .\setup.ps1
# =============================================================================

$ErrorActionPreference = "Stop"

function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Write-Info { param([string]$Text) Write-Color "[INFO] $Text" "Cyan" }
function Write-Success { param([string]$Text) Write-Color "[SUCCESS] $Text" "Green" }
function Write-Warn { param([string]$Text) Write-Color "[WARN] $Text" "Yellow" }
function Write-ErrorMsg { param([string]$Text) Write-Color "[ERROR] $Text" "Red"; exit 1 }

# Detect if running in WSL or native Windows
function Detect-Environment {
    if ($env:WSL_DISTRO_NAME) {
        return "wsl"
    } elseif ($IsWindows -or $env:OS -match "Windows") {
        return "windows"
    } else {
        return "unknown"
    }
}

# Install Chezmoi if not present
function Install-Chezmoi {
    if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
        Write-Info "Chezmoi already installed: $(chezmoi --version | Select-Object -First 1)"
        return
    }

    Write-Info "Installing Chezmoi..."

    $installScript = Invoke-WebRequest -UseBasicParsing https://chezmoi.io/get.ps1
    Invoke-Expression $installScript.Content

    # Add to PATH for current session
    $chezmoiPath = "$env:USERPROFILE\.local\bin"
    if (Test-Path $chezmoiPath) {
        $env:PATH = "$chezmoiPath;$env:PATH"
    }

    Write-Success "Chezmoi installed successfully"
}

# Install modern CLI tools on Windows
function Install-CLI-Tools {
    Write-Info "Installing modern CLI tools..."

    # Check for Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Info "Using Winget to install tools..."
        $tools = @(
            "eza-community.eza",
            "sharkdp.bat",
            "BurntSushi.ripgrep.MSVC",
            "sharkdp.fd",
            "Microsoft.PowerShell",
            "Git.Git"
        )
        foreach ($tool in $tools) {
            try {
                winget install --id $tool --silent --accept-package-agreements --accept-source-agreements | Out-Null
            } catch {
                Write-Warn "Could not install $tool (may already exist)"
            }
        }
    } else {
        Write-Warn "Winget not found. Please install modern CLI tools manually (eza, bat, ripgrep, fd)."
    }

    Write-Success "CLI tools installation attempted"
}

# Initialize and apply dotfiles
function Setup-Dotfiles {
    Write-Info "Initializing dotfiles with Chezmoi..."

    $repo = "dante-sparras/computer-setup"

    try {
        chezmoi init --apply $repo --force
        Write-Success "Dotfiles applied successfully!"
    } catch {
        Write-ErrorMsg "Failed to initialize Chezmoi: $_"
    }
}

# Main execution
function Main {
    Write-Host "==========================================" -ForegroundColor Magenta
    Write-Host "   computer-setup - Full Environment Setup (Windows)" -ForegroundColor Magenta
    Write-Host "==========================================" -ForegroundColor Magenta

    $envType = Detect-Environment
    Write-Info "Detected environment: $envType"

    Install-Chezmoi
    Install-CLI-Tools
    Setup-Dotfiles

    Write-Host ""
    Write-Success "🎉 Environment setup complete!"
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  • Restart your terminal" -ForegroundColor Yellow
    Write-Host "  • Run 'chezmoi update' to pull future changes" -ForegroundColor Yellow
    Write-Host "  • Edit configs in %USERPROFILE%\.local\share\chezmoi" -ForegroundColor Yellow
    Write-Host ""
}

Main