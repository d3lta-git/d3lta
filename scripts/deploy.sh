#!/bin/bash
# deploy.sh - Deployment script for D3LTA Flutter web app

# Exit on any error
set -e

echo "Starting D3LTA deployment process..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Ensure we're on main branch
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "Warning: You are not on the main branch. Current branch: $CURRENT_BRANCH"
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo "Deployment cancelled."
        exit 1
    fi
fi

# Run tests
echo "Running tests..."
flutter test

# Check for analyzer issues
echo "Checking for analyzer issues..."
flutter analyze

# Build for web
echo "Building for web..."
flutter build web --release

# If we have a custom domain, create CNAME file
if [ -n "$CUSTOM_DOMAIN" ]; then
    echo "$CUSTOM_DOMAIN" > build/web/CNAME
    echo "Created CNAME file for $CUSTOM_DOMAIN"
fi

# Deploy to GitHub Pages (if gh-pages is installed)
if command -v gh-pages &> /dev/null
then
    echo "Deploying to GitHub Pages..."
    gh-pages -d build/web
else
    echo "gh-pages not installed. To deploy to GitHub Pages, run:"
    echo "npm install -g gh-pages"
    echo "gh-pages -d build/web"
fi

echo "Deployment process completed!"
echo "If you want to deploy to GitHub Pages, make sure to run:"
echo "npm install -g gh-pages"
echo "gh-pages -d build/web"