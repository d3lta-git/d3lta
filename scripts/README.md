# Deployment Scripts

This directory contains scripts to automate the deployment process for the D3LTA Flutter web app.

## Available Scripts

### deploy.sh
- Bash script for Unix-like systems (Linux, macOS)
- Runs tests, checks for analyzer issues, and builds the web app
- Can deploy to GitHub Pages if gh-pages is installed

### deploy.bat
- Batch script for Windows
- Runs tests, checks for analyzer issues, and builds the web app

### deploy.ps1
- PowerShell script for Windows
- Runs tests, checks for analyzer issues, and builds the web app

## Usage

### Unix-like systems (Linux, macOS):
```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

### Windows (Command Prompt):
```cmd
scripts\deploy.bat
```

### Windows (PowerShell):
```powershell
.\scripts\deploy.ps1
```

## Environment Variables

- `CUSTOM_DOMAIN`: If set, creates a CNAME file with this domain for GitHub Pages

## Prerequisites

1. Flutter SDK installed and in PATH
2. For GitHub Pages deployment: `gh-pages` npm package installed globally
   ```bash
   npm install -g gh-pages
   ```

## GitHub Pages Deployment

After running the build script, you can deploy to GitHub Pages with:
```bash
gh-pages -d build/web
```