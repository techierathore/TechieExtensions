# Techie JSON Manager - Browser Extension

A powerful Blazor WebAssembly-based browser extension for viewing, editing, beautifying, and validating JSON files directly in your browser.

## Features

### Core Functionality
- **🔍 JSON Validation**: Real-time validation with detailed error messages including line and position
- **✨ Beautify/Format**: One-click JSON formatting with proper indentation
- **📦 Minify**: Compress JSON by removing unnecessary whitespace
- **🌳 Tree View**: Interactive hierarchical view of JSON structure
- **📋 Form View**: Edit JSON values through a user-friendly form interface
- **📝 Code Editor**: Syntax-highlighted editor with line numbers

### Additional Features
- **📊 JSON Statistics**: 
  - Total objects and arrays count
  - Total keys and values
  - Maximum depth calculation
- **📋 Copy to Clipboard**: One-click copy functionality
- **💾 Download**: Save edited JSON to file
- **🎨 Beautiful UI**: Modern gradient design with intuitive controls

## Installation

### Development Build
1. Navigate to the project directory:
   ```bash
   cd TrJsonManager
   ```

2. Build the project:
   ```bash
   dotnet build
   ```

3. The browser extension will be generated in: `bin\Debug\net9.0\browserextension`

### Loading in Browser

#### Chrome/Edge:
1. Open `chrome://extensions/` (Chrome) or `edge://extensions/` (Edge)
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select the `bin\Debug\net9.0\browserextension` folder

#### Firefox:
1. Navigate to `about:debugging`
2. Click "This Firefox"
3. Click "Load Temporary Add-on"
4. Select the `manifest.json` file in the `browserextension` folder

## Usage

### Automatic JSON Detection
- The extension automatically detects and enhances `.json` files opened in the browser
- Click "Open in Editor" button to launch the full-featured editor

### Manual Usage
- Click the extension icon in your browser toolbar
- Opens a popup with quick JSON editing capabilities
- Access full editor through the options page

### Editor Views

#### Code View
- Traditional text editor with syntax highlighting
- Line numbers for easy navigation
- Real-time validation feedback
- Tab key support for indentation

#### Tree View
- Expandable/collapsible nodes
- Color-coded values by type:
  - 🔵 Strings (blue)
  - 🟢 Numbers (green)
  - 🔷 Booleans (blue)
  - ⚫ Null values (gray)
- Click nodes to expand/collapse

#### Form View
- Edit JSON values through form inputs
- Type indicators for each field
- Hierarchical structure preserved

### Toolbar Functions

| Button | Function | Description |
|--------|----------|-------------|
| ✨ Beautify | Format JSON | Formats JSON with proper indentation |
| 📦 Minify | Compress | Removes unnecessary whitespace |
| ✓ Validate | Check syntax | Validates JSON and shows errors |
| 📝 Code | Code view | Switch to code editor |
| 🌳 Tree | Tree view | Switch to hierarchical view |
| 📋 Form | Form view | Switch to form editor |
| 🗑️ Clear | Clear all | Removes all content |
| 📋 Copy | Copy to clipboard | Copies JSON to clipboard |
| 💾 Download | Save file | Downloads JSON as file |
| 📄 Sample | Load example | Loads sample JSON data |

## Development

### Technologies Used
- **Blazor WebAssembly**: For building the UI
- **Newtonsoft.Json**: For JSON parsing and manipulation
- **Blazor.BrowserExtension**: For browser extension integration
- **C# 9.0**: Primary programming language

### Project Structure
```
TrJsonManager/
├── Components/           # Blazor components
│   ├── JsonEditor.razor  # Main editor component
│   ├── JsonTreeView.razor # Tree view component
│   └── JsonFormView.razor # Form view component
├── Services/            # Business logic
│   └── JsonService.cs   # JSON processing service
├── Pages/               # Blazor pages
│   ├── Index.razor      # Main editor page
│   └── Popup.razor      # Popup page
├── wwwroot/            # Static assets
│   ├── content/        # Content scripts
│   │   └── JsonHandler.js
│   ├── js/             # JavaScript helpers
│   │   └── json-helper.js
│   └── manifest.json   # Extension manifest
└── Program.cs          # Application entry point
```

### Building for Production
```bash
dotnet publish -c Release
```

The production-ready extension will be in `bin\Release\net9.0\publish\browserextension`

## Features in Detail

### JSON Validation
- Syntax checking with specific error location
- Support for all JSON types (objects, arrays, strings, numbers, booleans, null)
- Real-time validation as you type
- Visual feedback for valid/invalid JSON

### Statistics Display
- **Objects**: Count of JSON objects
- **Arrays**: Count of arrays
- **Keys**: Total number of keys
- **Depth**: Maximum nesting level


## Browser Compatibility
- ✅ Google Chrome (Manifest V3)
- ✅ Microsoft Edge (Manifest V3)
- ✅ Mozilla Firefox (with minor adjustments)
- ✅ Any Chromium-based browser

## Performance
- Handles large JSON files efficiently
- Lazy loading for tree view nodes
- Optimized rendering for better performance

## Known Limitations
- Very large files (>10MB) may experience slower performance
- Form view is read-only for complex nested structures

## Contributing
Feel free to submit issues and enhancement requests!

## License
Part of the TechieExtensions suite

## Comparison with Similar Tools
| Feature | Techie JSON Manager | jsonformatter.org | codebeautify.org |
|---------|---------------------|-------------------|------------------|
| Offline capable | ✅ | ❌ | ❌ |
| No ads | ✅ | ❌ | ❌ |
| Tree view | ✅ | ✅ | ✅ |
| Form editor | ✅ | ❌ | ✅ |
| Browser extension | ✅ | ❌ | ❌ |
| Privacy-focused | ✅ | ❓ | ❓ |
| No data tracking | ✅ | ❓ | ❓ |