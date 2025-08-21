# TechieExtensions Suite

A collection of powerful browser extensions built with Blazor WebAssembly for developers and content creators.

## 📦 Extensions in this Suite

### 1. 📝 Techie Mark Down Manager
**Markdown Viewer & Editor**

A comprehensive Markdown viewer and editor that automatically enhances `.md` files in your browser.

**Features:**
- ✨ Live preview with synchronized scrolling
- 🎛️ Split view for simultaneous editing and preview
- 📋 Copy to clipboard functionality
- 🎨 Support for tables, task lists, code blocks, and emojis
- 📂 Automatic detection of `.md` and `.markdown` files

**Installation Package:** `TrMdManager\dist\TechieMarkDownManager-Chrome-Edge.zip`

---

### 2. 🔧 Techie JSON Manager
**JSON Viewer, Editor & Beautifier**

A feature-rich JSON tool for viewing, editing, beautifying, and validating JSON files directly in your browser.

**Features:**
- ✅ Real-time JSON validation with error reporting
- ✨ One-click beautify/format with proper indentation
- 📦 Minify to compress JSON
- 🌳 Interactive tree view for hierarchical visualization
- 📋 Form view for easy value editing
- 📊 JSON statistics (objects, arrays, keys, depth)
- 📂 Automatic detection of `.json` files

**Installation Package:** `TrJsonManager\dist\TechieJsonManager-Chrome-Edge.zip`

---

## 🚀 Quick Installation

### For All Extensions:

1. **Download the Package**
   - Navigate to the respective `dist` folder
   - Get the `.zip` file for your browser

2. **Install in Browser**
   
   **Chrome/Edge:**
   - Open `chrome://extensions/` or `edge://extensions/`
   - Enable "Developer mode" (toggle in top-right)
   - Drag and drop the ZIP file onto the page
   
   **Firefox:**
   - Open `about:debugging`
   - Click "This Firefox"
   - Click "Load Temporary Add-on"
   - Select the ZIP file

## 💻 Development Setup

### Prerequisites
- .NET 9.0 SDK or later
- Node.js (for npm packages)
- Visual Studio 2022 or VS Code

### Building from Source

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd TechieExtensions
   ```

2. **Build all projects**
   ```bash
   dotnet build TechieExtensions.sln
   ```

3. **Build individual extension**
   ```bash
   cd TrMdManager  # or TrJsonManager
   dotnet build
   ```

4. **Create production package**
   ```bash
   powershell -ExecutionPolicy Bypass -File package-extension.ps1
   ```

## 📁 Project Structure

```
TechieExtensions/
├── TechieExtensions.sln         # Solution file
├── TrMdManager/                 # Markdown Manager Extension
│   ├── Components/              # Blazor components
│   ├── Services/               # Business logic
│   ├── wwwroot/               # Static assets
│   └── dist/                  # Distribution packages
└── TrJsonManager/              # JSON Manager Extension
    ├── Components/             # Blazor components
    ├── Services/              # Business logic
    ├── wwwroot/              # Static assets
    └── dist/                 # Distribution packages
```

## 🎯 Features Comparison

| Feature | Techie Mark Down Manager | Techie JSON Manager |
|---------|-------------------------|---------------------|
| Auto file detection | ✅ (.md, .markdown) | ✅ (.json) |
| Syntax highlighting | ✅ | ✅ |
| Live preview | ✅ | ✅ (Tree view) |
| Beautify/Format | ✅ | ✅ |
| Validation | N/A | ✅ |
| Copy to clipboard | ✅ | ✅ |
| Download file | ❌ | ✅ |
| Split view | ✅ | ❌ |
| Tree view | ❌ | ✅ |
| Form editor | ❌ | ✅ |
| Sync scroll | ✅ | N/A |
| Statistics | ❌ | ✅ |

## 🛡️ Privacy & Security

- **100% Offline**: All processing happens locally in your browser
- **No Data Collection**: No telemetry, analytics, or tracking
- **No External Requests**: Works without internet connection
- **Open Source**: Fully auditable code
- **No Ads**: Clean, distraction-free interface

## 🤝 Contributing

We welcome contributions! Please feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## 📝 License

This project is part of the TechieExtensions suite. Each extension maintains its own licensing terms.

## 🆘 Support

For issues, questions, or suggestions:
- Create an issue in the GitHub repository
- Check individual extension README files for specific documentation

## 🚀 Future Extensions (Planned)

- [ ] CSS Beautifier & Minifier
- [ ] HTML Formatter
- [ ] XML Viewer & Editor
- [ ] YAML Editor
- [ ] Base64 Encoder/Decoder
- [ ] JWT Decoder
- [ ] Color Picker & Palette Generator
- [ ] Lorem Ipsum Generator

## ⭐ Why Choose TechieExtensions?

1. **Privacy First**: Your data never leaves your browser
2. **No Internet Required**: Works completely offline
3. **Fast & Lightweight**: Built with performance in mind
4. **Modern UI**: Clean, intuitive interface
5. **Regular Updates**: Active development and support
6. **Free Forever**: No premium tiers or paywalls

## 📊 Stats

- **Total Extensions**: 2
- **Supported Browsers**: Chrome, Edge, Firefox
- **Technology**: Blazor WebAssembly, C#, JavaScript
- **Manifest Version**: v3 (Chrome/Edge)

---

**Built with ❤️ using Blazor WebAssembly**