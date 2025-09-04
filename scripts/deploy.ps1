# deploy.ps1 - Deployment script for D3LTA Flutter web app (PowerShell)

Write-Host "Starting D3LTA deployment process..."

# Check if Flutter is installed
try {
    $flutterVersion = flutter --version
    Write-Host "Flutter found: $flutterVersion"
} catch {
    Write-Host "Flutter is not installed. Please install Flutter first."
    exit 1
}

# Get current branch
$currentColor = $Host.UI.RawUI.ForegroundColor
$Host.UI.RawUI.ForegroundColor = "Yellow"
$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch"
$Host.UI.RawUI.ForegroundColor = $currentColor

# Ensure we're on main branch
if ($currentBranch -ne "main") {
    Write-Host "Warning: You are not on the main branch." -ForegroundColor Yellow
    $response = Read-Host "Do you want to continue? (y/N)"
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host "Deployment cancelled."
        exit 1
    }
}

# Run tests
Write-Host "Running tests..."
flutter test

# Check for analyzer issues
Write-Host "Checking for analyzer issues..."
flutter analyze

# Build for web
Write-Host "Building for web..."
flutter build web --release

# If we have a custom domain, create CNAME file
if ($env:CUSTOM_DOMAIN) {
    Set-Content -Path "build\web\CNAME" -Value $env:CUSTOM_DOMAIN
    Write-Host "Created CNAME file for $env:CUSTOM_DOMAIN"
}

Write-Host "Deployment process completed!" -ForegroundColor Green
Write-Host "If you want to deploy to GitHub Pages, make sure to run:" -ForegroundColor Cyan
Write-Host "npm install -g gh-pages" -ForegroundColor Cyan
Write-Host "gh-pages -d build\web" -ForegroundColor Cyan

Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")