@echo off
REM deploy.bat - Deployment script for D3LTA Flutter web app (Windows)

echo Starting D3LTA deployment process...

REM Check if Flutter is installed
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter is not installed. Please install Flutter first.
    exit /b 1
)

REM Get current branch
for /f %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i

REM Ensure we're on main branch
if not "%CURRENT_BRANCH%"=="main" (
    echo Warning: You are not on the main branch. Current branch: %CURRENT_BRANCH%
    set /p REPLY="Do you want to continue? (y/N): "
    if /i not "%REPLY%"=="y" (
        echo Deployment cancelled.
        exit /b 1
    )
)

REM Run tests
echo Running tests...
flutter test

REM Check for analyzer issues
echo Checking for analyzer issues...
flutter analyze

REM Build for web
echo Building for web...
flutter build web --release

REM If we have a custom domain, create CNAME file
if defined CUSTOM_DOMAIN (
    echo %CUSTOM_DOMAIN% > build\web\CNAME
    echo Created CNAME file for %CUSTOM_DOMAIN%
)

echo Deployment process completed!
echo If you want to deploy to GitHub Pages, make sure to run:
echo npm install -g gh-pages
echo gh-pages -d build\web

pause