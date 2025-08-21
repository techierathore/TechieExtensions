# Publishing TrMdManager Extension

## 📦 Quick Distribution (Easiest Methods)

### Method 1: Direct ZIP Installation (Simplest for Users)
1. Run the packaging script:
   ```powershell
   .\package-extension.ps1
   ```
2. Share the `dist\TrMdManager-Chrome-Edge.zip` file
3. Users can:
   - Download the ZIP file
   - Open `chrome://extensions/` or `edge://extensions/`
   - Enable Developer Mode
   - Drag and drop the ZIP file onto the page

### Method 2: GitHub Releases (Recommended)
1. Create a GitHub repository for your extension
2. Push your code
3. Create a release and upload the ZIP files
4. Users can download from your releases page
5. Provide simple installation instructions

## 🏪 Publishing to Official Stores

### Chrome Web Store
**Cost:** $5 one-time developer fee  
**Review Time:** 1-3 days typically

1. **Create Developer Account**
   - Go to [Chrome Web Store Developer Dashboard](https://chrome.google.com/webstore/devconsole)
   - Pay $5 registration fee
   - Verify your account

2. **Prepare for Submission**
   - Create screenshots (1280x800 or 640x400)
   - Write a detailed description
   - Create promotional images (optional)

3. **Upload Extension**
   ```bash
   # Use the ZIP from dist folder
   dist\TrMdManager-Chrome-Edge.zip
   ```

4. **Fill Store Listing**
   - Category: Developer Tools or Productivity
   - Language: English
   - Description: Your README content
   - Screenshots: At least 1, maximum 5

5. **Submit for Review**

### Microsoft Edge Add-ons Store
**Cost:** FREE  
**Review Time:** 1-7 days

1. **Create Developer Account**
   - Go to [Partner Center](https://partner.microsoft.com/dashboard/microsoftedge/overview)
   - Sign in with Microsoft account
   - Complete registration (FREE)

2. **Create New Extension**
   - Click "New extension"
   - Upload `dist\TrMdManager-Chrome-Edge.zip`
   - Same package works for Edge!

3. **Complete Listing**
   - Similar to Chrome Store
   - Edge automatically syncs with Chrome manifest

### Firefox Add-ons (AMO)
**Cost:** FREE  
**Review Time:** 1-2 days

1. **Create Account**
   - Go to [Firefox Add-on Developer Hub](https://addons.mozilla.org/developers/)
   - Sign up for free account

2. **Submit Add-on**
   - Upload `dist\TrMdManager-Firefox.zip`
   - May need minor manifest adjustments

## 🚀 Alternative Distribution Methods

### 1. **Self-Hosted Installation Page**
Create a simple website with:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Install TrMdManager</title>
</head>
<body>
    <h1>TrMdManager - Markdown Extension</h1>
    <button onclick="installExtension()">Install for Chrome/Edge</button>
    
    <script>
    function installExtension() {
        // For Chrome/Edge
        window.open('https://github.com/yourusername/TrMdManager/releases/latest');
    }
    </script>
</body>
</html>
```

### 2. **Private/Enterprise Distribution**
For organizations:
- Use Google Workspace Admin Console
- Use Microsoft Endpoint Manager
- Deploy via Group Policy

### 3. **Create Installer Script**
PowerShell installer for Windows users:

```powershell
# Save as Install-TrMdManager.ps1
$extensionUrl = "https://github.com/yourusername/TrMdManager/releases/latest/download/TrMdManager-Chrome-Edge.zip"
$tempPath = "$env:TEMP\TrMdManager.zip"
$extractPath = "$env:LOCALAPPDATA\TrMdManager"

# Download
Invoke-WebRequest -Uri $extensionUrl -OutFile $tempPath

# Extract
Expand-Archive -Path $tempPath -DestinationPath $extractPath -Force

# Open browser extensions page
Start-Process "chrome://extensions"
Write-Host "Extension downloaded to: $extractPath"
Write-Host "Please enable Developer Mode and click 'Load unpacked' to install"
```

## 📋 Pre-Publishing Checklist

Before publishing, update these files:

### 1. Update Version in manifest.json
```json
{
  "version": "1.0.0",  // Semantic versioning
  "version_name": "1.0.0 - Initial Release"  // Optional, human-readable
}
```

### 2. Add Privacy Policy (Required for stores)
Create `PRIVACY.md`:
```markdown
# Privacy Policy for TrMdManager

TrMdManager does not collect, store, or transmit any personal data.
All markdown processing happens locally in your browser.
```

### 3. Add Screenshots
Create `screenshots` folder with:
- `screenshot1.png` - Main editor view
- `screenshot2.png` - Split view feature
- `screenshot3.png` - Markdown file detection

## 🎯 Quick Start Commands

```powershell
# 1. Package the extension
.\package-extension.ps1

# 2. Test the package
# Extract ZIP and load in browser to verify

# 3. Create GitHub release
git tag v1.0.0
git push origin v1.0.0
# Then create release on GitHub and upload ZIPs

# 4. Submit to stores
# Use the ZIP files from dist folder
```

## 📊 Store Listing Template

**Name:** TrMdManager - Markdown Viewer & Editor

**Short Description:** (132 chars max)
View and edit Markdown files directly in your browser with live preview, split view, and synchronized scrolling.

**Detailed Description:**
TrMdManager is a powerful Markdown viewer and editor browser extension built with Blazor WebAssembly.

Features:
✅ Automatic Markdown file detection (.md, .markdown)
✅ Live preview as you type
✅ Split view for simultaneous editing and preview
✅ Synchronized scrolling between editor and preview
✅ Syntax highlighting for code blocks
✅ Support for tables, task lists, and emojis
✅ Copy to clipboard functionality
✅ Clean, modern interface

Perfect for developers, writers, and anyone working with Markdown files!

**Category:** Developer Tools / Productivity

**Tags:** markdown, editor, preview, developer, productivity, blazor

## 🆘 Troubleshooting

### Common Issues:

1. **"Manifest version not supported"**
   - Firefox might need manifest v2, while Chrome uses v3
   - May need separate builds

2. **"Package invalid"**
   - Ensure no hidden files (.git, .vs)
   - Check manifest.json is valid JSON

3. **Size too large**
   - Optimize with: `dotnet workload install wasm-tools`
   - Then rebuild with optimizations

## 📈 Post-Publishing

1. **Monitor Reviews** - Respond to user feedback
2. **Regular Updates** - Fix bugs, add features
3. **Marketing**:
   - Post on Reddit (r/chrome, r/webdev, r/markdown)
   - Tweet with #markdown #browserextension
   - Write a dev.to article
   - Submit to Product Hunt

## 🎉 Success Tips

1. **Good screenshots** make a huge difference
2. **Respond quickly** to user reviews
3. **Update regularly** to show active development
4. **Clear documentation** reduces support requests
5. **Free is popular** - consider keeping it free with optional donations