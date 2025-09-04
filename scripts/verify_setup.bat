@echo off
REM verify_setup.bat - Script to verify D3LTA setup (Windows)

echo === D3LTA Setup Verification ===
echo.

REM Check if Flutter is installed
echo 1. Checking Flutter installation...
where flutter >nul 2>&1
if %errorlevel% equ 0 (
    flutter --version
    echo ✅ Flutter is installed
) else (
    echo ❌ Flutter is not installed
    echo    Please install Flutter from https://flutter.dev/docs/get-started/install
)
echo.

REM Check if Git is installed
echo 2. Checking Git installation...
where git >nul 2>&1
if %errorlevel% equ 0 (
    git --version
    echo ✅ Git is installed
) else (
    echo ❌ Git is not installed
    echo    Please install Git from https://git-scm.com/downloads
)
echo.

REM Check if we're in a git repository
echo 3. Checking Git repository...
git rev-parse --git-dir >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Git repository initialized
    for /f %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i
    echo    Current branch: %CURRENT_BRANCH%
    for /f "tokens=*" %%i in ('git log -1 --oneline') do set LAST_COMMIT=%%i
    echo    Last commit: %LAST_COMMIT%
) else (
    echo ❌ Not in a Git repository
    echo    Run 'git init' to initialize a repository
)
echo.

REM Check if GitHub remote is configured
echo 4. Checking GitHub remote...
git remote get-url origin >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ GitHub remote configured
    for /f "tokens=*" %%i in ('git remote get-url origin') do set REMOTE_URL=%%i
    echo    Remote URL: %REMOTE_URL%
) else (
    echo ⚠️  GitHub remote not configured
    echo    Run 'git remote add origin YOUR_REPOSITORY_URL' to add remote
)
echo.

REM Check if build directory exists
echo 5. Checking build directory...
if exist "build\web" (
    echo ✅ Build directory exists
    for /f %%i in ('dir "build\web" /b ^| find /c /v ""') do set FILE_COUNT=%%i
    echo    Build files: %FILE_COUNT% files
) else (
    echo ⚠️  Build directory not found
    echo    Run 'flutter build web' to create build
)
echo.

REM Check for required files
echo 6. Checking required files...
set ALL_FILES_EXIST=true

if exist ".github\workflows\deploy.yml" (
    echo ✅ .github\workflows\deploy.yml
) else (
    echo ❌ .github\workflows\deploy.yml
    set ALL_FILES_EXIST=false
)

if exist "scripts\deploy.sh" (
    echo ✅ scripts\deploy.sh
) else (
    echo ❌ scripts\deploy.sh
    set ALL_FILES_EXIST=false
)

if exist "scripts\deploy.bat" (
    echo ✅ scripts\deploy.bat
) else (
    echo ❌ scripts\deploy.bat
    set ALL_FILES_EXIST=false
)

if exist "scripts\deploy.ps1" (
    echo ✅ scripts\deploy.ps1
) else (
    echo ❌ scripts\deploy.ps1
    set ALL_FILES_EXIST=false
)

if exist "CLOUDFLARE_SETUP.md" (
    echo ✅ CLOUDFLARE_SETUP.md
) else (
    echo ❌ CLOUDFLARE_SETUP.md
    set ALL_FILES_EXIST=false
)

if exist "BACKEND_SERVICES.md" (
    echo ✅ BACKEND_SERVICES.md
) else (
    echo ❌ BACKEND_SERVICES.md
    set ALL_FILES_EXIST=false
)

if exist "DEPLOYMENT_GUIDE.md" (
    echo ✅ DEPLOYMENT_GUIDE.md
) else (
    echo ❌ DEPLOYMENT_GUIDE.md
    set ALL_FILES_EXIST=false
)

if "%ALL_FILES_EXIST%"=="true" (
    echo ✅ All required files present
) else (
    echo ❌ Some required files are missing
)
echo.

echo === Setup Verification Complete ===
echo.
echo Next steps:
echo 1. If any checks failed, address the issues
echo 2. Create GitHub repository if not done already
echo 3. Push to GitHub: git push -u origin main
echo 4. Enable GitHub Pages in repository settings
echo 5. Configure Cloudflare DNS
echo 6. Test deployment at your domain
echo.

pause