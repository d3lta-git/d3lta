#!/bin/bash
# verify_setup.sh - Script to verify D3LTA setup

echo "=== D3LTA Setup Verification ==="
echo

# Check if Flutter is installed
echo "1. Checking Flutter installation..."
if command -v flutter &> /dev/null
then
    flutter --version
    echo "✅ Flutter is installed"
else
    echo "❌ Flutter is not installed"
    echo "   Please install Flutter from https://flutter.dev/docs/get-started/install"
fi
echo

# Check if Git is installed
echo "2. Checking Git installation..."
if command -v git &> /dev/null
then
    git --version
    echo "✅ Git is installed"
else
    echo "❌ Git is not installed"
    echo "   Please install Git from https://git-scm.com/downloads"
fi
echo

# Check if we're in a git repository
echo "3. Checking Git repository..."
if git rev-parse --git-dir > /dev/null 2>&1
then
    echo "✅ Git repository initialized"
    echo "   Current branch: $(git branch --show-current)"
    echo "   Last commit: $(git log -1 --oneline)"
else
    echo "❌ Not in a Git repository"
    echo "   Run 'git init' to initialize a repository"
fi
echo

# Check if GitHub remote is configured
echo "4. Checking GitHub remote..."
if git remote get-url origin > /dev/null 2>&1
then
    echo "✅ GitHub remote configured"
    echo "   Remote URL: $(git remote get-url origin)"
else
    echo "⚠️  GitHub remote not configured"
    echo "   Run 'git remote add origin YOUR_REPOSITORY_URL' to add remote"
fi
echo

# Check if build directory exists
echo "5. Checking build directory..."
if [ -d "build/web" ]
then
    echo "✅ Build directory exists"
    echo "   Build files: $(ls build/web | wc -l) files"
else
    echo "⚠️  Build directory not found"
    echo "   Run 'flutter build web' to create build"
fi
echo

# Check for required files
echo "6. Checking required files..."
required_files=(
    ".github/workflows/deploy.yml"
    "scripts/deploy.sh"
    "scripts/deploy.bat"
    "scripts/deploy.ps1"
    "CLOUDFLARE_SETUP.md"
    "BACKEND_SERVICES.md"
    "DEPLOYMENT_GUIDE.md"
)

all_files_exist=true
for file in "${required_files[@]}"
do
    if [ -f "$file" ]
    then
        echo "✅ $file"
    else
        echo "❌ $file"
        all_files_exist=false
    fi
done

if $all_files_exist
then
    echo "✅ All required files present"
else
    echo "❌ Some required files are missing"
fi
echo

echo "=== Setup Verification Complete ==="
echo
echo "Next steps:"
echo "1. If any checks failed, address the issues"
echo "2. Create GitHub repository if not done already"
echo "3. Push to GitHub: git push -u origin main"
echo "4. Enable GitHub Pages in repository settings"
echo "5. Configure Cloudflare DNS"
echo "6. Test deployment at your domain"