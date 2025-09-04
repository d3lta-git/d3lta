# Cloudflare Configuration for GitHub Pages

## Step 1: Add Your Domain to Cloudflare

1. Sign in to your Cloudflare account
2. Click "Add a Site"
3. Enter your domain name and click "Add Site"
4. Select the free plan
5. Click "Continue to DNS"

## Step 2: Configure DNS Records

Add the following DNS records:

| Type | Name | Content | Proxy Status |
|------|------|---------|--------------|
| A | @ | 185.199.108.153 | Proxied |
| A | @ | 185.199.109.153 | Proxied |
| A | @ | 185.199.110.153 | Proxied |
| A | @ | 185.199.111.153 | Proxied |
| CNAME | www | your-github-username.github.io | Proxied |

Replace `your-github-username` with your actual GitHub username.

## Step 3: Update Nameservers

1. In your domain registrar's control panel, update the nameservers to the ones provided by Cloudflare
2. Wait for DNS propagation (this can take up to 24 hours, but usually happens within a few minutes)

## Step 4: Configure SSL/TLS

1. In Cloudflare dashboard, go to SSL/TLS > Overview
2. Set SSL/TLS encryption mode to "Full" (not Full (strict))

## Step 5: Enable Always Use HTTPS

1. In Cloudflare dashboard, go to SSL/TLS > Edge Certificates
2. Enable "Always Use HTTPS"

## Step 6: Configure GitHub Pages

1. In your GitHub repository, go to Settings > Pages
2. Under "Custom domain", enter your domain name
3. Do NOT check "Enforce HTTPS" (Cloudflare will handle this)
4. Click "Save"

## Troubleshooting

If you encounter issues:

1. Check that your DNS records are correct
2. Ensure your GitHub repository name matches your username (username.github.io)
3. Make sure GitHub Actions workflow is running successfully
4. Check Cloudflare's SSL/TLS settings

## Verification

To verify everything is working:

1. Visit your domain in a browser
2. Check that the site loads correctly
3. Verify the certificate is issued by Cloudflare