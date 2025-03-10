# Script to set up and push to GitHub repository
Write-Host "Setting up GiorgosSearch repository..." -ForegroundColor Green

# Check if git is installed
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed. Please install Git and try again." -ForegroundColor Red
    exit 1
}

# Initialize git in the Perplexica directory if not already initialized
if (!(Test-Path ".\Perplexica\.git")) {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    Set-Location .\Perplexica
    git init
} else {
    Set-Location .\Perplexica
}

# Create .gitignore if it doesn't exist
if (!(Test-Path ".gitignore")) {
    Write-Host "Creating .gitignore file..." -ForegroundColor Yellow
    @"
node_modules/
.env
.env.local
config.toml
data/
uploads/
dist/
"@ | Out-File -FilePath ".gitignore" -Encoding utf8
}

# Create a sample.config.toml file for users
if (Test-Path "config.toml" -and !(Test-Path "sample.config.toml")) {
    Write-Host "Creating sample.config.toml file..." -ForegroundColor Yellow
    Copy-Item "config.toml" -Destination "sample.config.toml"
}

# Add remote repository
Write-Host "Adding remote repository..." -ForegroundColor Yellow
git remote remove origin 2>$null
git remote add origin https://github.com/Qualiasolutions/GiorgosSearch.git

# Stage all files
Write-Host "Staging files..." -ForegroundColor Yellow
git add .

# Commit changes
Write-Host "Committing changes..." -ForegroundColor Yellow
git commit -m "Initial commit"

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin master

Write-Host "Repository setup complete!" -ForegroundColor Green
Write-Host "Your project is now available at: https://github.com/Qualiasolutions/GiorgosSearch" -ForegroundColor Green 