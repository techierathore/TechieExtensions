# Easy Installation Guide for TrMdManager

## 🎯 For Non-Technical Users

### Option 1: One-Click Install (When Published)
Once published to stores, installation will be as simple as:

**Chrome Users:**
1. Visit [Chrome Web Store Link] (coming soon)
2. Click "Add to Chrome"
3. Click "Add Extension"
4. Done! ✅

**Edge Users:**
1. Visit [Edge Add-ons Link] (coming soon)
2. Click "Get"
3. Click "Add Extension"
4. Done! ✅

### Option 2: Install from ZIP File (Current Method)

#### For Windows Users:

**Step 1: Download the Extension**
- Download `TrMdManager-Chrome-Edge.zip` from [releases page]
- Save it to your Downloads folder

**Step 2: Open Extension Settings**
- **Chrome:** Type `chrome://extensions` in address bar and press Enter
- **Edge:** Type `edge://extensions` in address bar and press Enter

**Step 3: Enable Developer Mode**
- Look for "Developer mode" toggle (usually top-right)
- Click to turn it ON (it will turn blue/green)

**Step 4: Install the Extension**
- Simply **drag** the ZIP file from your Downloads folder
- **Drop** it onto the extensions page
- Click "Add Extension" when prompted

**That's it! You're done!** 🎉

### How to Use:

1. **For Markdown Files:**
   - Open any `.md` file in your browser
   - Click "Open Editor" button that appears

2. **Quick Access:**
   - Click the extension icon (puzzle piece) in toolbar
   - Click TrMdManager icon

## 🎁 For Someone to Share This Extension

If you want to share this extension with friends/colleagues:

### Create an Installer Package:

1. **Create a simple installer batch file** (`Install-TrMdManager.bat`):
```batch
@echo off
echo Installing TrMdManager Extension...
echo.
echo Step 1: Opening Chrome Extensions page...
start chrome://extensions
echo.
echo Step 2: Please follow these steps:
echo   1. Turn ON "Developer mode" (top-right toggle)
echo   2. Drag the TrMdManager-Chrome-Edge.zip file onto the page
echo.
echo Location of extension: %~dp0TrMdManager-Chrome-Edge.zip
echo.
pause
```

2. **Create a ZIP bundle** containing:
   - `TrMdManager-Chrome-Edge.zip` (the extension)
   - `Install-TrMdManager.bat` (the installer)
   - `README.txt` (simple instructions)

3. **Share the bundle** via:
   - Email
   - Google Drive/OneDrive/Dropbox
   - USB drive
   - Company network share

### Simple README.txt for Users:
```
TrMdManager - Markdown Viewer & Editor
======================================

TO INSTALL:
1. Double-click "Install-TrMdManager.bat"
2. Follow the on-screen instructions

WHAT IT DOES:
- Opens and edits Markdown (.md) files
- Shows live preview of your Markdown
- Works in Chrome and Edge browsers

NEED HELP?
Contact: [your-email@example.com]
```

## 🚀 For IT Administrators

### Deploy to Multiple Computers:

**Via Group Policy (Windows Domain):**
```json
// Create policy with this registry entry
{
  "ExtensionInstallForcelist": {
    "1": "extensionID;file:///path/to/extension"
  }
}
```

**Via PowerShell Script:**
```powershell
# Deploy-TrMdManager.ps1
$extensionPath = "\\server\share\TrMdManager"
$targetPath = "$env:LOCALAPPDATA\Extensions\TrMdManager"

# Copy extension
Copy-Item -Path $extensionPath -Destination $targetPath -Recurse -Force

# Add to Chrome
$regPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"
New-ItemProperty -Path $regPath -Name "1" -Value "file:///$targetPath" -Force
```

## 📱 Sharing via QR Code

Create a QR code that links to:
1. Your GitHub releases page
2. A simple landing page with install instructions
3. Direct download link

## 🌐 Create a Simple Landing Page

Host on GitHub Pages (FREE):

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head>
    <title>TrMdManager - Install</title>
    <style>
        body { 
            font-family: Arial; 
            max-width: 600px; 
            margin: 50px auto; 
            padding: 20px;
        }
        .button {
            display: inline-block;
            padding: 15px 30px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 10px;
        }
        .steps {
            background: #f0f0f0;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <h1>📝 TrMdManager</h1>
    <p>Markdown Viewer & Editor for Chrome/Edge</p>
    
    <div class="steps">
        <h2>Easy Install (3 Steps):</h2>
        <ol>
            <li>Download the extension file below</li>
            <li>Open chrome://extensions (or edge://extensions)</li>
            <li>Drag the downloaded file onto the page</li>
        </ol>
    </div>
    
    <a href="TrMdManager-Chrome-Edge.zip" class="button" download>
        ⬇️ Download Extension
    </a>
    
    <a href="https://youtu.be/your-video" class="button">
        ▶️ Watch Install Video
    </a>
</body>
</html>
```

## 💡 Pro Tips for Sharing

1. **Create a 1-minute video** showing installation
2. **Use screenshots** in your instructions
3. **Test with a non-technical friend** first
4. **Provide your email** for support
5. **Consider creating a Telegram/Discord** for users

## 🎯 Simplest Possible Instructions

For absolute beginners, provide this:

```
INSTALL MARKDOWN EDITOR - 3 CLICKS:

1. CLICK this file: TrMdManager-Install.bat
2. CLICK "Developer mode" to turn it ON  
3. DRAG the ZIP file onto the browser

You're done! 
To use: Click the puzzle piece icon → Find TrMdManager
```

Remember: The simpler the instructions, the more people will successfully install it!