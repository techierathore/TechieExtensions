# Store Deployment Guide - TechieExtensions

This guide will walk you through publishing your browser extensions to various web stores.

## 📋 Pre-Deployment Checklist

### 1. Prepare Assets
- [ ] Extension icons (16x16, 48x48, 128x128 PNG format)
- [ ] Screenshots (1280x800 or 640x400 for Chrome Web Store)
- [ ] Promotional images (if required)
- [ ] Privacy policy document
- [ ] Extension descriptions and metadata

### 2. Build Production Packages
```bash
# Build both extensions
cd TrMdManager
powershell -ExecutionPolicy Bypass -File package-extension.ps1

cd ../TrJsonManager  
powershell -ExecutionPolicy Bypass -File package-extension.ps1
```

**Output files:**
- `TrMdManager/dist/TechieMarkDownManager-Chrome-Edge.zip`
- `TrMdManager/dist/TechieMarkDownManager-Firefox.zip`
- `TrJsonManager/dist/TechieJsonManager-Chrome-Edge.zip`
- `TrJsonManager/dist/TechieJsonManager-Firefox.zip`

---

## 🏪 Chrome Web Store

### Cost: $5 one-time developer registration fee
### Review Time: 1-3 days typically

### Step 1: Create Developer Account
1. Go to [Chrome Web Store Developer Dashboard](https://chrome.google.com/webstore/devconsole)
2. Sign in with your Google account
3. Pay the $5 one-time registration fee
4. Complete your developer profile

### Step 2: Upload Extension

#### For Techie Mark Down Manager:
1. Click "New Item"
2. Upload `TechieMarkDownManager-Chrome-Edge.zip`
3. Fill in store listing:

**Basic Information:**
- **Name**: Techie Mark Down Manager
- **Summary**: Markdown Viewer & Editor - View and edit Markdown files directly in your browser
- **Category**: Developer Tools
- **Language**: English

**Detailed Description:**
```
Techie Mark Down Manager is a powerful Markdown viewer and editor browser extension built with Blazor WebAssembly.

✨ KEY FEATURES:
• Live preview with synchronized scrolling
• Split view for simultaneous editing and preview  
• Automatic detection of .md and .markdown files
• Copy to clipboard functionality
• Support for tables, task lists, code blocks, and emojis
• Beautiful syntax highlighting
• Privacy-focused - works completely offline

🔒 PRIVACY & SECURITY:
• 100% offline processing - your data never leaves your browser
• No tracking, analytics, or data collection
• No ads or distractions
• Open source and fully auditable

Perfect for developers, writers, and anyone working with Markdown files!
```

**Screenshots needed:**
- Main editor interface
- Split view demonstration
- Markdown file auto-detection
- Tree view (if applicable)

#### For Techie JSON Manager:
1. Repeat the same process
2. Upload `TechieJsonManager-Chrome-Edge.zip`

**Store Listing:**
- **Name**: Techie JSON Manager
- **Summary**: JSON Viewer, Editor & Beautifier - View, edit, beautify, and validate JSON files
- **Category**: Developer Tools

**Detailed Description:**
```
Techie JSON Manager is a comprehensive JSON tool for viewing, editing, beautifying, and validating JSON files directly in your browser.

✨ KEY FEATURES:
• Real-time JSON validation with detailed error reporting
• One-click beautify/format with proper indentation
• Minify to compress JSON files
• Interactive tree view for hierarchical visualization
• Form view for easy value editing
• JSON statistics (objects, arrays, keys, depth)
• Automatic detection of .json files

🔒 PRIVACY & SECURITY:
• 100% offline processing - your data never leaves your browser
• No tracking, analytics, or data collection
• No ads or distractions
• Open source and fully auditable

Perfect for developers, API testing, and JSON data management!
```

### Step 3: Review and Publish
1. Upload screenshots (at least 1, max 5)
2. Set pricing (Free)
3. Select regions (Worldwide recommended)
4. Submit for review

---

## 🔷 Microsoft Edge Add-ons Store

### Cost: FREE
### Review Time: 1-7 days

### Step 1: Create Partner Center Account
1. Go to [Microsoft Partner Center](https://partner.microsoft.com/dashboard/microsoftedge/overview)
2. Sign in with Microsoft account
3. Complete registration (FREE)
4. Accept agreements

### Step 2: Submit Extensions
1. Click "New extension"
2. Upload the same ZIP files used for Chrome
3. Edge store accepts Chrome Web Store packages!

**Advantages:**
- Free submission
- Same manifest v3 support
- Faster review process typically
- Good reach with Edge users

### Step 3: Store Listing
- Use similar descriptions as Chrome Web Store
- Edge automatically imports some metadata
- Upload same screenshots

---

## 🦊 Firefox Add-ons (AMO)

### Cost: FREE
### Review Time: 1-2 days

### Step 1: Create AMO Account
1. Go to [Firefox Add-on Developer Hub](https://addons.mozilla.org/developers/)
2. Create Firefox account if needed
3. Complete developer profile

### Step 2: Submit Add-ons
1. Click "Submit a New Add-on"
2. Upload respective Firefox ZIP files
3. Choose "On this site" distribution

**Note**: Firefox may require minor manifest adjustments for full compatibility.

### Step 3: Listing Information
- Use similar descriptions
- Firefox focuses heavily on privacy (emphasize offline processing)
- Upload screenshots

---

## 📝 Store Listing Assets

### Required Screenshots (Prepare these in advance):

#### Markdown Manager:
1. **Main Interface** (1280x800):
   - Show split view with markdown on left, preview on right
   - Include toolbar buttons visible

2. **Auto-Detection** (1280x800):
   - Browser showing .md file with extension overlay

3. **Features Demo** (1280x800):
   - Show sync scrolling or table/task list rendering

#### JSON Manager:
1. **Main Interface** (1280x800):
   - Show JSON editor with validation
   - Include toolbar and statistics

2. **Tree View** (1280x800):
   - Expandable JSON hierarchy

3. **Validation** (1280x800):
   - Show error highlighting and statistics

### Icon Requirements:
- **Chrome**: 128x128 PNG (main), 16x16, 48x48
- **Edge**: Same as Chrome
- **Firefox**: 48x48 PNG (minimum), 96x96 recommended

---

## 🤖 Automated Store Updates

### Using GitHub Actions for Store Updates:

Create additional workflows for automatic store publishing:

#### Chrome Web Store API:
```yaml
# .github/workflows/chrome-store-update.yml
name: Update Chrome Web Store

on:
  release:
    types: [published]

jobs:
  upload:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Upload to Chrome Web Store
        uses: mnao305/chrome-extension-upload@v4.0.1
        with:
          file-path: ./artifacts/TechieMarkDownManager-Chrome-Edge.zip
          extension-id: ${{ secrets.CHROME_EXTENSION_ID }}
          client-id: ${{ secrets.CHROME_CLIENT_ID }}
          client-secret: ${{ secrets.CHROME_CLIENT_SECRET }}
          refresh-token: ${{ secrets.CHROME_REFRESH_TOKEN }}
```

#### Edge Add-ons API:
```yaml
# Similar workflow for Edge
# Edge Partner Center API integration
```

---

## 🔐 Required Secrets for Automation

Add these to your GitHub repository secrets:

### Chrome Web Store:
- `CHROME_CLIENT_ID`
- `CHROME_CLIENT_SECRET`
- `CHROME_REFRESH_TOKEN`
- `CHROME_EXTENSION_ID_MARKDOWN`
- `CHROME_EXTENSION_ID_JSON`

### Edge Add-ons:
- `EDGE_CLIENT_ID`
- `EDGE_CLIENT_SECRET`
- `EDGE_ACCESS_TOKEN`

---

## 📊 Post-Publication Monitoring

### Analytics and Metrics:
1. **Chrome Web Store**: Built-in analytics dashboard
2. **Edge Add-ons**: Partner Center analytics
3. **Firefox**: AMO statistics page

### Review Management:
- Respond to user reviews promptly
- Address bug reports quickly
- Collect feature requests

### Update Strategy:
1. **Patch releases**: Bug fixes, minor improvements
2. **Minor releases**: New features, UI improvements  
3. **Major releases**: Significant functionality changes

---

## 🎯 Store Optimization Tips

### 1. SEO Optimization:
- Use relevant keywords in titles and descriptions
- Include terms like: "developer tools", "JSON", "Markdown", "editor", "beautifier"

### 2. Visual Appeal:
- High-quality screenshots showing key features
- Consistent branding across all stores
- Clear, professional icons

### 3. Description Best Practices:
- Start with clear value proposition
- Use bullet points for features
- Emphasize privacy and offline capabilities
- Include relevant keywords naturally

### 4. Regular Updates:
- Maintain active development
- Respond to user feedback
- Keep extensions compatible with browser updates

---

## 🚨 Common Pitfalls to Avoid

1. **Manifest Issues**: Test thoroughly in target browsers
2. **Permission Overreach**: Only request necessary permissions
3. **Poor Screenshots**: Low-quality images hurt downloads
4. **Inconsistent Branding**: Keep names/descriptions aligned
5. **Slow Review Response**: Address reviewer feedback quickly
6. **No Update Strategy**: Plan for ongoing maintenance

---

## 📞 Support Contacts

### Chrome Web Store:
- [Developer Support](https://support.google.com/chrome_webstore/contact/developer_support)
- [Policy Questions](https://support.google.com/chrome_webstore/contact/policy)

### Edge Add-ons:
- [Partner Support](https://developer.microsoft.com/microsoft-edge/extensions/support/)

### Firefox Add-ons:
- [Developer Hub Support](https://developer.mozilla.org/docs/Mozilla/Add-ons/Contact_us)

---

## ✅ Launch Checklist

### Pre-Launch:
- [ ] All extensions built and tested
- [ ] Screenshots captured and optimized
- [ ] Store descriptions written and reviewed
- [ ] Privacy policy created
- [ ] Developer accounts created and verified
- [ ] Payment processed (Chrome only)

### Launch Day:
- [ ] Upload packages to all stores
- [ ] Submit for review
- [ ] Monitor for approval
- [ ] Update repository README with store links

### Post-Launch:
- [ ] Monitor reviews and ratings
- [ ] Set up analytics tracking
- [ ] Plan first update cycle
- [ ] Promote on social media/blogs

---

**🎉 Good luck with your store deployments!**

Remember: Start with Edge Add-ons (free and faster), then Chrome Web Store, then Firefox. This gives you experience and user feedback before the paid Chrome submission.