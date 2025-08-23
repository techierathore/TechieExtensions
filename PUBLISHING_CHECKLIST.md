# Publishing Checklist - TechieExtensions

## ✅ Pre-Publishing Checklist

### Icons (Required)
- [ ] Open `generate-icons.html` in Chrome
- [ ] Save/screenshot each icon as PNG
- [ ] For **TrJsonManager**, create:
  - [ ] `icon-16.png` (16x16)
  - [ ] `icon-48.png` (48x48)
  - [ ] `icon-128.png` (128x128)
  - [ ] Place in `TrJsonManager/wwwroot/`
- [ ] For **TrMdManager**, create:
  - [ ] `icon-16.png` (16x16)
  - [ ] `icon-48.png` (48x48)
  - [ ] `icon-128.png` (128x128)
  - [ ] Place in `TrMdManager/wwwroot/`

### Build Production Packages
```powershell
# Build JSON Manager
cd TrJsonManager
powershell -ExecutionPolicy Bypass -File package-extension.ps1

# Build Markdown Manager
cd ../TrMdManager
powershell -ExecutionPolicy Bypass -File package-extension.ps1
```

### Files Created
- [ ] `TrJsonManager/dist/TechieJsonManager-Chrome-Edge.zip`
- [ ] `TrJsonManager/dist/TechieJsonManager-Firefox.zip`
- [ ] `TrMdManager/dist/TechieMarkDownManager-Chrome-Edge.zip`
- [ ] `TrMdManager/dist/TechieMarkDownManager-Firefox.zip`

### Screenshots (Required for Stores)
Take screenshots of both extensions showing:
1. **Main Interface** (1280x800 or 640x400)
2. **Feature in Action** (JSON validation or Markdown preview)
3. **Different Views** (Tree view, Split view, etc.)

---

## 🔷 Microsoft Edge Add-ons (FREE - Start Here!)

### 1. Create Account
- [ ] Go to [Partner Center](https://partner.microsoft.com/dashboard/microsoftedge/overview)
- [ ] Sign in with Microsoft account
- [ ] Complete registration (FREE)
- [ ] Accept developer agreement

### 2. Submit JSON Manager
- [ ] Click "New extension"
- [ ] Upload `TechieJsonManager-Chrome-Edge.zip`
- [ ] Fill in details:
  - **Name**: Techie JSON Manager
  - **Category**: Developer Tools
  - **Description**: Use from `STORE_LISTINGS.md`
- [ ] Upload screenshots
- [ ] Set as FREE
- [ ] Submit for review

### 3. Submit Markdown Manager
- [ ] Repeat for `TechieMarkDownManager-Chrome-Edge.zip`
- [ ] Use descriptions from `STORE_LISTINGS.md`

---

## 🦊 Firefox Add-ons (FREE)

### 1. Create Account
- [ ] Go to [Firefox Developer Hub](https://addons.mozilla.org/developers/)
- [ ] Create Firefox account
- [ ] Complete developer profile

### 2. Submit Extensions
- [ ] Click "Submit a New Add-on"
- [ ] Upload `TechieJsonManager-Firefox.zip`
- [ ] Choose "On this site" distribution
- [ ] Fill in listing details
- [ ] Repeat for `TechieMarkDownManager-Firefox.zip`

---

## 🦁 Brave Browser (Uses Chrome Web Store)

Brave users can install from Chrome Web Store, but you can also:

### Submit to Brave-specific collections
- [ ] After Chrome Web Store approval
- [ ] Submit to Brave's curated lists
- [ ] Tag with "privacy-focused" and "offline"

---

## 🏪 Chrome Web Store ($5 fee - Do Last)

### 1. Create Developer Account
- [ ] Go to [Chrome Developer Dashboard](https://chrome.google.com/webstore/devconsole)
- [ ] Pay $5 one-time fee
- [ ] Complete profile

### 2. Submit Extensions
- [ ] Upload ZIP files
- [ ] Fill in all details
- [ ] Upload screenshots
- [ ] Submit for review

---

## 📝 Store Listing Information

### For ALL Stores, Use:

**JSON Manager:**
- **Name**: Techie JSON Manager
- **Short Description**: JSON Viewer, Editor & Beautifier - View, edit, beautify, and validate JSON files
- **Category**: Developer Tools
- **Full Description**: See `STORE_LISTINGS.md`

**Markdown Manager:**
- **Name**: Techie Mark Down Manager  
- **Short Description**: Markdown Viewer & Editor - View, edit, and preview Markdown files with live sync
- **Category**: Developer Tools
- **Full Description**: See `STORE_LISTINGS.md`

### Privacy Policy
- Use the content from `PRIVACY_POLICY.md`
- Host it on GitHub Pages or your website
- Required for all stores

### Support URL
- GitHub repository: https://github.com/[yourusername]/TechieExtensions
- Or create a simple support page

---

## 🚀 Post-Publishing Tasks

### After Approval:
- [ ] Update README with store links
- [ ] Share on social media
- [ ] Post on Reddit (r/webdev, r/javascript)
- [ ] Create GitHub release
- [ ] Tag version in git

### Monitor:
- [ ] Check reviews weekly
- [ ] Respond to user feedback
- [ ] Track installation numbers
- [ ] Plan updates based on feedback

---

## 📊 Expected Timeline

- **Edge Add-ons**: 1-3 days approval
- **Firefox**: 1-2 days approval  
- **Chrome**: 1-7 days approval
- **Brave**: Inherits from Chrome

---

## 🎯 Quick Start Recommendation

1. **Start with Edge** (Free, fast approval)
2. **Then Firefox** (Free, good for testing)
3. **Finally Chrome** (Has fee, but largest audience)
4. **Brave users** can install from Chrome Web Store

---

## 📞 Support Links

- **Edge Support**: https://developer.microsoft.com/microsoft-edge/extensions/
- **Firefox Support**: https://extensionworkshop.com/
- **Chrome Support**: https://developer.chrome.com/docs/webstore/

---

## ⚠️ Important Notes

1. **Test thoroughly** before submission
2. **Icons must be exact sizes** (16, 48, 128)
3. **Screenshots are crucial** for approval and downloads
4. **Privacy policy is required** - use provided template
5. **Start with Edge** - it's free and fastest

---

**Ready to publish? Start with Microsoft Edge Add-ons - it's FREE!** 🚀