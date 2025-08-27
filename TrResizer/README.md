# TrResizer - Browser Window Resizer Extension

A Blazor-based browser extension for resizing browser windows to preset or custom resolutions. Perfect for web developers and designers testing responsive layouts.

## 🎯 Features

- **Current Window Size Display**: Real-time display of browser window dimensions
- **8 Preset Resolutions**: HD, Full HD, 2K, 4K, Tablet, Mobile, and more
- **Custom Dimensions**: Set any width and height you need
- **Cross-Browser Support**: Works on Chrome, Edge, Firefox, and other modern browsers
- **Privacy Focused**: No data collection or external connections
- **Beautiful UI**: Modern gradient design with glassmorphism effects

## 🚀 Quick Start - Testing on Microsoft Edge

### Method 1: Load Unpacked Extension (Development)

1. **Build the extension:**
   ```powershell
   cd TrResizer
   dotnet publish -c Release
   ```

2. **Open Microsoft Edge**

3. **Navigate to Extensions:**
   - Type `edge://extensions/` in the address bar
   - Or click the three dots menu → Extensions → Manage extensions

4. **Enable Developer Mode:**
   - Toggle the "Developer mode" switch in the bottom-left corner

5. **Load the extension:**
   - Click "Load unpacked"
   - Navigate to: `F:\AIGenCode\TechieExtensions\TrResizer\bin\Release\net9.0\publish\wwwroot`
   - Click "Select Folder"

6. **Pin the extension:**
   - Click the puzzle piece icon in the toolbar
   - Click the pin icon next to TrResizer

7. **Test it:**
   - Click the TrResizer icon to open the popup
   - Try different preset sizes or enter custom dimensions

### Method 2: Using PowerShell Build Script

1. **Run the build script:**
   ```powershell
   cd TrResizer
   .\build-extension.ps1
   ```

2. **The script will:**
   - Build the Blazor app
   - Create an `extension` folder with all necessary files
   - Open Edge with the extension loaded (optional)

## 🔧 Development

### Prerequisites
- .NET 9.0 SDK or later
- Visual Studio 2022 or VS Code
- Microsoft Edge or Google Chrome

### Building from Source

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/TechieExtensions.git
   cd TechieExtensions/TrResizer
   ```

2. **Restore dependencies:**
   ```bash
   dotnet restore
   ```

3. **Build the project:**
   ```bash
   dotnet build
   ```

4. **Publish for production:**
   ```bash
   dotnet publish -c Release
   ```

### Project Structure
```
TrResizer/
├── wwwroot/
│   ├── manifest.json       # Extension manifest
│   ├── background.js       # Background script
│   ├── js/
│   │   └── window-resizer.js  # Core functionality
│   ├── icon*.png          # Extension icons
│   └── index.html         # Entry point
├── Pages/
│   └── Index.razor        # Main UI component
├── Program.cs            # Blazor entry point
└── TrResizer.csproj      # Project file
```

## 🌐 Browser Compatibility

| Browser | Status | Notes |
|---------|--------|-------|
| Google Chrome | ✅ Supported | Version 88+ |
| Microsoft Edge | ✅ Supported | Version 88+ |
| Brave | ✅ Supported | Latest version |
| Opera | ✅ Supported | Version 74+ |
| Vivaldi | ✅ Supported | Latest version |
| Firefox | ⚠️ Requires modification | Needs manifest v2 |

## 📦 Store Deployment

### Microsoft Edge Add-ons Store

1. **Package the extension:**
   ```powershell
   cd bin\Release\net9.0\publish\wwwroot
   Compress-Archive -Path * -DestinationPath ..\..\TrResizer.zip
   ```

2. **Submit to Edge Add-ons:**
   - Go to [Microsoft Partner Center](https://partner.microsoft.com/dashboard)
   - Create a new extension submission
   - Upload the ZIP file
   - Fill in the store listing information
   - Submit for review

### Chrome Web Store

1. **Create a ZIP package** (same as Edge)
2. **Submit to Chrome Web Store:**
   - Go to [Chrome Web Store Developer Dashboard](https://chrome.google.com/webstore/developer/dashboard)
   - Pay one-time developer fee ($5)
   - Upload the ZIP file
   - Complete store listing
   - Submit for review

## 🧪 Testing Different Resolutions

Test these common breakpoints:
- **Mobile S**: 320×568
- **Mobile M**: 375×667
- **Mobile L**: 414×896
- **Tablet**: 768×1024
- **Laptop**: 1366×768
- **Desktop**: 1920×1080
- **4K**: 3840×2160

## 🐛 Troubleshooting

### Extension Not Loading
- Ensure Developer Mode is enabled
- Check the console for errors (F12 → Console)
- Verify all files are in the correct location

### Window Not Resizing
- Some OS/browser combinations limit minimum window size
- Try closing other tabs (some browsers prevent resizing with multiple tabs)
- Check if your display resolution supports the target size

### Blazor Not Loading
- Clear browser cache
- Ensure .NET assemblies are properly published
- Check Content Security Policy in manifest.json

## 🔒 Privacy

TrResizer respects your privacy:
- No data collection
- No external API calls
- No tracking or analytics
- All operations run locally

## 📄 License

MIT License - See LICENSE file for details

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/TechieExtensions/issues)
- **Email**: support@techieextensions.com

## ⭐ Acknowledgments

Built with:
- [Blazor WebAssembly](https://blazor.net)
- [.NET 9](https://dot.net)
- Modern web technologies

---

Made with ❤️ by TechieExtensions