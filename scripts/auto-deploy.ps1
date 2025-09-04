# auto-deploy.ps1 - Automated deployment script for D3LTA Flutter web app to d3lta.app

param(
    [string]$CustomDomain = "d3lta.app",
    [switch]$SkipTests,
    [switch]$SkipAnalyze
)

Write-Host "Starting automated D3LTA deployment process..." -ForegroundColor Green

# Check if Flutter is installed
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter is not installed. Please install Flutter first."
    exit 1
}

# Get current branch
$CurrentBranch = git branch --show-current

# Ensure we're on main branch
if ($CurrentBranch -ne "main") {
    Write-Warning "You are not on the main branch. Current branch: $CurrentBranch"
    $Reply = Read-Host "Do you want to continue? (y/N)"
    if ($Reply -ne "y" -and $Reply -ne "Y") {
        Write-Host "Deployment cancelled." -ForegroundColor Yellow
        exit 1
    }
}

# Run tests unless skipped
if (-not $SkipTests) {
    Write-Host "Running tests..." -ForegroundColor Cyan
    flutter test
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Tests failed. Deployment cancelled."
        exit 1
    }
}

# Check for analyzer issues unless skipped
if (-not $SkipAnalyze) {
    Write-Host "Checking for analyzer issues..." -ForegroundColor Cyan
    flutter analyze
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Analyzer found issues. Deployment cancelled."
        exit 1
    }
}

# Build for web
Write-Host "Building for web..." -ForegroundColor Cyan
flutter build web --release
if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed. Deployment cancelled."
    exit 1
}

# Create CNAME file for custom domain
if ($CustomDomain) {
    Set-Content -Path "build\web\CNAME" -Value $CustomDomain
    Write-Host "Created CNAME file for $CustomDomain" -ForegroundColor Green
}

# Deploy to GitHub Pages using gh-pages
Write-Host "Deploying to GitHub Pages..." -ForegroundColor Cyan
npx gh-pages -d build\web

if ($LASTEXITCODE -eq 0) {
    Write-Host "Deployment completed successfully!" -ForegroundColor Green
    Write-Host "Your app should be available at https://$CustomDomain within a few minutes." -ForegroundColor Green
} else {
    Write-Error "Deployment failed."
    exit 1
}