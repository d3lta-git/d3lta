# Complete Deployment Guide

This guide walks you through the complete deployment process for the D3LTA Flutter web app.

## Prerequisites

1. Flutter SDK installed
2. Git installed
3. GitHub account
4. Domain name registered
5. Cloudflare account

## Step 1: GitHub Repository Setup

1. Create a new repository on GitHub named `your-github-username.github.io`
2. Do NOT initialize with a README, .gitignore, or license
3. Add the remote to your local repository:
   ```bash
   cd C:\dev\d3lta
   git remote add origin https://github.com/your-github-username/your-github-username.github.io.git
   git branch -M main
   git push -u origin main
   ```

## Step 2: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click on "Settings" tab
3. Scroll down to "Pages" section
4. Under "Source", select "Deploy from a branch"
5. Select "main" branch and "/ (root)" folder
6. Click "Save"

## Step 3: Cloudflare Setup

Follow the instructions in `CLOUDFLARE_SETUP.md`:

1. Add your domain to Cloudflare
2. Update your domain's nameservers
3. Configure DNS records for GitHub Pages
4. Set up SSL/TLS encryption

## Step 4: Deploy the Application

### Option 1: Using GitHub Actions (Recommended)

The GitHub Actions workflow will automatically deploy your app when you push to the main branch.

### Option 2: Manual Deployment

Run the deployment script:
```bash
# On Unix-like systems
chmod +x scripts/deploy.sh
./scripts/deploy.sh

# On Windows (Command Prompt)
scripts\deploy.bat

# On Windows (PowerShell)
.\scripts\deploy.ps1
```

### Option 3: Automated PowerShell Deployment (Recommended for Windows)

For Windows users, we've created an automated PowerShell deployment script that handles the entire process:

```bash
# On Windows (PowerShell)
.\scripts\auto-deploy.ps1
```

This script will:
1. Run tests
2. Check for analyzer issues
3. Build the application
4. Deploy to GitHub Pages
5. Handle custom domain configuration

You can also pass parameters to the script:
```bash
# Skip tests and analyzer checks (not recommended for production)
.\scripts\auto-deploy.ps1 -SkipTests -SkipAnalyze

# Deploy with a custom domain
.\scripts\auto-deploy.ps1 -CustomDomain "yourdomain.com"
```

Then deploy to GitHub Pages:
```bash
npx gh-pages -d build/web
```

## Step 5: Configure Custom Domain

1. In your GitHub repository, go to Settings > Pages
2. Under "Custom domain", enter your domain name
3. Do NOT check "Enforce HTTPS" (Cloudflare will handle this)
4. Click "Save"

## Step 6: Backend Services Setup

Follow the instructions in `BACKEND_SERVICES.md` to set up Firebase or your preferred backend service.

## Verification

1. Visit your domain in a browser
2. Check that the site loads correctly
3. Verify the certificate is issued by Cloudflare
4. Test all form submissions
5. Verify seller keyword validation works
6. Test QR code generation

## Troubleshooting

### GitHub Pages Issues

1. Check that your repository name matches your GitHub username
2. Ensure GitHub Actions workflow is running successfully
3. Check the build logs in the Actions tab

### Cloudflare Issues

1. Verify DNS records are correct
2. Check SSL/TLS encryption mode is set to "Full"
3. Ensure "Always Use HTTPS" is enabled

### Flutter Build Issues

1. Run `flutter clean` and try building again
2. Check for analyzer issues with `flutter analyze`
3. Ensure all dependencies are installed with `flutter pub get`

### PowerShell Script Issues

1. Ensure you have the gh-pages npm package installed globally: `npm install -g gh-pages`
2. Check that your Git repository is properly configured
3. Verify you have the necessary permissions to push to the repository

## Maintenance

1. Regularly update dependencies
2. Monitor GitHub Actions for build failures
3. Check Cloudflare analytics for traffic patterns
4. Monitor backend service usage and costs

## Updating the Application

1. Make your code changes
2. Run tests: `flutter test`
3. Check for analyzer issues: `flutter analyze`
4. Commit and push to main branch
5. GitHub Actions will automatically deploy the updated app
6. Alternatively, run the PowerShell deployment script for immediate deployment

## Cost Considerations

1. GitHub Pages is free for public repositories
2. Cloudflare free plan is sufficient for most use cases
3. Firebase free tier may be sufficient for low-traffic sites
4. Consider upgrading to paid plans as traffic increases