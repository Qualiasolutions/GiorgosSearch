# Perplexica Setup Wizard
$host.UI.RawUI.WindowTitle = "Perplexica Setup Wizard"
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
 _____           _           _           
|  __ \         | |         (_)          
| |__) |__ _ __ | | _____  ___  ___ __ _ 
|  ___/ _ \ '_ \| |/ _ \ \/ / |/ __/ _` |
| |  |  __/ |_) | |  __/>  <| | (_| (_| |
|_|   \___| .__/|_|\___/_/\_\_|\___\__,_|
          | |                            
          |_|                            
"@ -ForegroundColor Cyan
Write-Host "Setup Wizard" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor DarkGray
Write-Host

# Check Prerequisites
Write-ColorText "Checking prerequisites..." "White"

# Check Docker
$dockerInstalled = Get-Command docker -ErrorAction SilentlyContinue
if (-not $dockerInstalled) {
    Write-ColorText "Docker is not installed!" "Red"
    Write-ColorText "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop" "Yellow"
    Write-ColorText "Press any key to exit..." "White"
    $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}
Write-ColorText "✓ Docker is installed" "Green"

# Check Docker Compose
$dockerComposeInstalled = $null -ne (docker compose version 2>&1)
if (-not $dockerComposeInstalled) {
    Write-ColorText "Docker Compose is not installed!" "Red"
    Write-ColorText "Please install Docker Compose or use a newer version of Docker Desktop" "Yellow"
    Write-ColorText "Press any key to exit..." "White"
    $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}
Write-ColorText "✓ Docker Compose is installed" "Green"

# Check Git
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitInstalled) {
    Write-ColorText "Git is not installed! It's recommended but not required." "Yellow"
}
else {
    Write-ColorText "✓ Git is installed" "Green"
}

Write-Host
Write-ColorText "All essential prerequisites are installed!" "Green"
Write-Host
Write-Host "============================================" -ForegroundColor DarkGray

# Config Setup
Write-Host
Write-ColorText "Setting up configuration..." "White"

# Check if config.toml exists, if not create from sample
if (-not (Test-Path "config.toml")) {
    if (Test-Path "sample.config.toml") {
        Write-ColorText "Creating config.toml from sample..." "Yellow"
        Copy-Item "sample.config.toml" -Destination "config.toml"
    } else {
        Write-ColorText "Error: sample.config.toml not found!" "Red"
        Write-ColorText "Press any key to exit..." "White"
        $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit
    }
}

# Edit the config file
Write-ColorText "Let's configure your Perplexica installation." "Cyan"
Write-ColorText "Would you like to:" "White"
Write-ColorText "1. Use OpenAI API (requires API key)" "White"
Write-ColorText "2. Use Ollama (local models - recommended)" "White"
Write-ColorText "3. Use other providers (Groq, Anthropic, etc.)" "White"
Write-ColorText "4. Skip configuration for now" "White"

$choice = Read-Host "Enter your choice (1-4)"

# Load the config
$configPath = (Get-Item "config.toml").FullName
$configContent = Get-Content $configPath -Raw

switch ($choice) {
    "1" {
        $apiKey = Read-Host "Enter your OpenAI API key"
        if ($configContent -match '(?m)^OPENAI\s*=\s*".*"') {
            $configContent = $configContent -replace '(?m)^OPENAI\s*=\s*".*"', "OPENAI = `"$apiKey`""
        } else {
            $configContent += "`nOPENAI = `"$apiKey`""
        }
        Write-ColorText "OpenAI API key configured!" "Green"
    }
    "2" {
        $ollamaUrl = Read-Host "Enter your Ollama URL (default: http://host.docker.internal:11434)"
        if ([string]::IsNullOrWhiteSpace($ollamaUrl)) {
            $ollamaUrl = "http://host.docker.internal:11434"
        }

        if ($configContent -match '(?m)^OLLAMA\s*=\s*".*"') {
            $configContent = $configContent -replace '(?m)^OLLAMA\s*=\s*".*"', "OLLAMA = `"$ollamaUrl`""
        } else {
            $configContent += "`nOLLAMA = `"$ollamaUrl`""
        }
        Write-ColorText "Ollama URL configured!" "Green"
        Write-ColorText "Note: Make sure Ollama is installed and running locally" "Yellow"
        Write-ColorText "You can download it from: https://ollama.com/download" "Yellow"
    }
    "3" {
        $provider = Read-Host "Which provider would you like to use? (GROQ, ANTHROPIC)"
        $apiKey = Read-Host "Enter your API key"
        
        if ($configContent -match "(?m)^$provider\s*=\s*`".*`"") {
            $configContent = $configContent -replace "(?m)^$provider\s*=\s*`".*`"", "$provider = `"$apiKey`""
        } else {
            $configContent += "`n$provider = `"$apiKey`""
        }
        Write-ColorText "$provider API key configured!" "Green"
    }
    "4" {
        Write-ColorText "Skipping configuration. You can edit config.toml manually later." "Yellow"
    }
    default {
        Write-ColorText "Invalid choice. Skipping configuration." "Red"
    }
}

# Save the modified config
$configContent | Set-Content $configPath

Write-Host
Write-ColorText "Configuration complete!" "Green"
Write-Host "============================================" -ForegroundColor DarkGray

# Start Perplexica
Write-Host
Write-ColorText "Ready to start Perplexica!" "Cyan"
$startNow = Read-Host "Would you like to start Perplexica now? (y/n)"

if ($startNow -eq "y" -or $startNow -eq "Y") {
    Write-ColorText "Starting Perplexica..." "Yellow"
    Write-ColorText "This may take a few minutes on first start as Docker images are downloaded." "Yellow"
    
    # Start Docker Compose
    docker compose up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorText "Perplexica is now running!" "Green"
        Write-ColorText "You can access it at: http://localhost:3000" "Cyan"
    } else {
        Write-ColorText "Error starting Perplexica. Please check the Docker logs." "Red"
    }
} else {
    Write-ColorText "You can start Perplexica later by running 'docker compose up -d' in this directory." "Yellow"
}

Write-Host
Write-ColorText "Setup complete! Thank you for installing Perplexica." "Green"
Write-ColorText "Press any key to exit..." "White"
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 