# GiorgosSearch Standalone Installer
# This script downloads and installs GiorgosSearch from GitHub
# It handles all prerequisites and runs the setup wizard

$host.UI.RawUI.WindowTitle = "GiorgosSearch Installer"
Clear-Host

function Write-ColorText {
    param(
        [string]$Text,
        [string]$ForegroundColor = "White"
    )
    Write-Host $Text -ForegroundColor $ForegroundColor
}

# ASCII Art Banner
Write-Host @"
  _____  _                              _____                      _     
 / ____|| |                            / ____|                    | |    
| |  __ | |_  ___   _ __  __ _   ___  | (___    ___  __ _  _ __  | |__  
| | |_ || __|/ _ \ | '__|/ _` | / _ \  \___ \  / _ \/ _` || '_ \ | '_ \ 
| |__| || |_| (_) || |  | (_| || (_) | ____) ||  __/ (_| || | | || | | |
 \_____| \__|\___/ |_|   \__, | \___/ |_____/  \___|\__,_||_| |_||_| |_|
                          __/ |                                          
                         |___/                                           
"@ -ForegroundColor Cyan
Write-Host "Installer" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor DarkGray
Write-Host

Write-ColorText "Welcome to the GiorgosSearch installer!" "White"
Write-ColorText "This script will download and install GiorgosSearch on your computer." "White"
Write-Host

# Check Prerequisites
Write-ColorText "Checking prerequisites..." "White"

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-ColorText "Warning: Not running as administrator. Some features may not work correctly." "Yellow"
    Write-ColorText "It's recommended to run this installer as administrator." "Yellow"
}

# Check for PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-ColorText "PowerShell 5.0 or higher is required." "Red"
    Write-ColorText "Please update PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell" "Yellow"
    exit 1
}
Write-ColorText "✓ PowerShell version OK" "Green"

# Check if Git is installed
$gitInstalled = $null -ne (Get-Command git -ErrorAction SilentlyContinue)
if (-not $gitInstalled) {
    Write-ColorText "Git is not installed. Installing Git..." "Yellow"
    
    # Download Git installer
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe"
    $gitInstaller = "$env:TEMP\git-installer.exe"
    
    try {
        Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller
        Write-ColorText "Running Git installer..." "Yellow"
        Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT" -Wait
        
        # Check if Git was installed successfully
        $gitInstalled = $null -ne (Get-Command git -ErrorAction SilentlyContinue)
        if ($gitInstalled) {
            Write-ColorText "✓ Git installed successfully" "Green"
        } else {
            Write-ColorText "Failed to install Git automatically." "Red"
            Write-ColorText "Please install Git manually from: https://git-scm.com/download/win" "Yellow"
            exit 1
        }
    }
    catch {
        Write-ColorText "Failed to download Git installer." "Red"
        Write-ColorText "Please install Git manually from: https://git-scm.com/download/win" "Yellow"
        exit 1
    }
} else {
    Write-ColorText "✓ Git is installed" "Green"
}

# Check if Docker is installed
$dockerInstalled = $null -ne (Get-Command docker -ErrorAction SilentlyContinue)
if (-not $dockerInstalled) {
    Write-ColorText "Docker is not installed." "Red"
    Write-ColorText "Docker Desktop is required to run GiorgosSearch." "Yellow"
    
    $installDocker = Read-Host "Would you like to open the Docker Desktop download page? (y/n)"
    if ($installDocker -eq "y" -or $installDocker -eq "Y") {
        Start-Process "https://www.docker.com/products/docker-desktop"
    }
    
    Write-ColorText "Please install Docker Desktop, then run this installer again." "Yellow"
    exit 1
}

# Check if Docker is running
try {
    $dockerRunning = docker info 2>$null
    Write-ColorText "✓ Docker is installed and running" "Green"
} catch {
    Write-ColorText "Docker is installed but not running." "Red"
    Write-ColorText "Please start Docker Desktop, then run this installer again." "Yellow"
    exit 1
}

Write-Host
Write-ColorText "All prerequisites are installed!" "Green"
Write-Host
Write-Host "============================================" -ForegroundColor DarkGray
Write-Host

# Ask for installation directory
$defaultDir = Join-Path $env:USERPROFILE "GiorgosSearch"
$installDir = Read-Host "Where would you like to install GiorgosSearch? (Default: $defaultDir)"

if ([string]::IsNullOrWhiteSpace($installDir)) {
    $installDir = $defaultDir
}

# Create the directory if it doesn't exist
if (-not (Test-Path $installDir)) {
    Write-ColorText "Creating directory $installDir..." "Yellow"
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Navigate to the installation directory
Set-Location $installDir

# Clone the repository
Write-Host
Write-ColorText "Downloading GiorgosSearch from GitHub..." "White"
Write-ColorText "This may take a few minutes depending on your internet connection..." "White"

try {
    # Check if the repository already exists
    if (Test-Path (Join-Path $installDir ".git")) {
        Write-ColorText "Repository already exists. Updating..." "Yellow"
        git pull
    } else {
        git clone https://github.com/Qualiasolutions/GiorgosSearch.git .
    }
    
    Write-ColorText "✓ Download complete!" "Green"
} catch {
    Write-ColorText "Failed to download GiorgosSearch from GitHub." "Red"
    Write-ColorText "Error: $_" "Red"
    exit 1
}

Write-Host
Write-Host "============================================" -ForegroundColor DarkGray
Write-Host

# Run the setup wizard
Write-ColorText "Running the setup wizard..." "White"

try {
    # Create a setup wizard script if it doesn't exist (in case the repository doesn't have it)
    $setupWizardPath = Join-Path $installDir "setup-wizard.ps1"
    
    if (-not (Test-Path $setupWizardPath)) {
        Write-ColorText "Creating setup wizard script..." "Yellow"
        
        $setupWizardContent = @"
# GiorgosSearch Setup Wizard
`$host.UI.RawUI.WindowTitle = "GiorgosSearch Setup Wizard"
Clear-Host

function Write-ColorText {
    param(
        [string]`$Text,
        [string]`$ForegroundColor = "White"
    )
    Write-Host `$Text -ForegroundColor `$ForegroundColor
}

# Check if config.toml exists, if not create from sample
if (-not (Test-Path "config.toml")) {
    if (Test-Path "sample.config.toml") {
        Write-ColorText "Creating config.toml from sample..." "Yellow"
        Copy-Item "sample.config.toml" -Destination "config.toml"
    } else {
        Write-ColorText "Error: sample.config.toml not found!" "Red"
        exit 1
    }
}

# Start GiorgosSearch
Write-Host
Write-ColorText "Ready to start GiorgosSearch!" "Cyan"
`$startNow = Read-Host "Would you like to start GiorgosSearch now? (y/n)"

if (`$startNow -eq "y" -or `$startNow -eq "Y") {
    Write-ColorText "Starting GiorgosSearch..." "Yellow"
    Write-ColorText "This may take a few minutes on first start as Docker images are downloaded." "Yellow"
    
    # Start Docker Compose
    docker compose up -d
    
    if (`$LASTEXITCODE -eq 0) {
        Write-ColorText "GiorgosSearch is now running!" "Green"
        Write-ColorText "You can access it at: http://localhost:3000" "Cyan"
        Start-Process "http://localhost:3000"
    } else {
        Write-ColorText "Error starting GiorgosSearch. Please check the Docker logs." "Red"
    }
} else {
    Write-ColorText "You can start GiorgosSearch later by running 'docker compose up -d' in this directory." "Yellow"
}
"@
        
        $setupWizardContent | Out-File -FilePath $setupWizardPath -Encoding utf8
    }
    
    # Run the setup wizard
    & powershell -ExecutionPolicy Bypass -File $setupWizardPath
    
} catch {
    Write-ColorText "Failed to run the setup wizard." "Red"
    Write-ColorText "Error: $_" "Red"
    
    # Fallback: Try to start GiorgosSearch directly
    Write-ColorText "Attempting to start GiorgosSearch directly..." "Yellow"
    
    # Check if config.toml exists, if not create from sample
    if (-not (Test-Path "config.toml") -and (Test-Path "sample.config.toml")) {
        Copy-Item "sample.config.toml" -Destination "config.toml"
    }
    
    docker compose up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorText "GiorgosSearch is now running!" "Green"
        Write-ColorText "You can access it at: http://localhost:3000" "Cyan"
        Start-Process "http://localhost:3000"
    }
}

Write-Host
Write-ColorText "Installation complete!" "Green"
Write-ColorText "You can start GiorgosSearch anytime by running 'docker compose up -d' in $installDir" "White"
Write-ColorText "Or by running Docker Desktop and starting the containers there." "White"
Write-Host

# Create a shortcut on the desktop
$createShortcut = Read-Host "Would you like to create a shortcut on the desktop? (y/n)"
if ($createShortcut -eq "y" -or $createShortcut -eq "Y") {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\GiorgosSearch.lnk")
    $Shortcut.TargetPath = "http://localhost:3000"
    $Shortcut.Save()
    
    Write-ColorText "Shortcut created on the desktop!" "Green"
}

Write-Host
Write-ColorText "Thank you for installing GiorgosSearch!" "Cyan"
Write-ColorText "Press Enter to exit..." "White"
Read-Host 