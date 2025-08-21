# Techie Mark Down Manager - Browser Extension

A powerful Markdown Viewer & Editor browser extension built with Blazor WebAssembly for viewing and editing Markdown files directly in your browser.

## Features

- **Live Markdown Preview**: Real-time rendering of Markdown content as you type
- **Split View Mode**: View your Markdown source and preview side-by-side
- **Syntax Support**: Full support for:
  - Headers (H1-H6)
  - Bold, italic, and strikethrough text
  - Lists (ordered and unordered)
  - Task lists
  - Tables
  - Code blocks with syntax highlighting
  - Blockquotes
  - Links and images
  - Emojis
- **Editor Toolbar**: Quick access to toggle between edit/preview modes, split view, save, and copy functions
- **Content Script**: Automatically detects and renders `.md` and `.markdown` files when opened in the browser
- **Popup Editor**: Quick access to a Markdown editor from the browser toolbar

## Installation

### Development Build

1. Build the project:
   ```bash
   cd TrMdManager
   dotnet build
   ```

2. The browser extension will be generated in: `bin\Debug\net9.0\browserextension`

### Loading in Browser

#### Chrome/Edge:
1. Open browser and navigate to `chrome://extensions/` (Chrome) or `edge://extensions/` (Edge)
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select the `bin\Debug\net9.0\browserextension` folder
5. The extension will be loaded and ready to use

#### Firefox:
1. Navigate to `about:debugging`
2. Click "This Firefox"
3. Click "Load Temporary Add-on"
4. Navigate to `bin\Debug\net9.0\browserextension` and select the `manifest.json` file

## Usage

### Viewing Markdown Files
- When you open a `.md` or `.markdown` file in your browser, the extension will automatically render it
- Use the toolbar buttons to toggle between raw and rendered views
- Click "Open Editor" to edit the file in a new tab

### Using the Popup Editor
- Click the extension icon in your browser toolbar
- A popup window will open with a quick Markdown editor
- Type or paste your Markdown content
- Toggle between edit and preview modes
- Save or copy your content as needed

### Using the Full Editor
- Click the extension icon and select "Options" or navigate to the extension's options page
- The full-featured editor will open in a new tab
- Create, edit, and preview Markdown documents
- Use split view for simultaneous editing and preview

## Development

### Prerequisites
- .NET 9.0 SDK or later
- Blazor.BrowserExtension.Template package

### Project Structure
```
TrMdManager/
├── Components/          # Blazor components
│   ├── MarkdownEditor.razor
│   └── MarkdownEditor.razor.css
├── Services/           # Services
│   └── MarkdownService.cs
├── Pages/              # Blazor pages
│   ├── Index.razor     # Main editor page
│   ├── Options.razor   # Options page
│   └── Popup.razor     # Popup editor
├── wwwroot/           # Static assets
│   ├── content/       # Content scripts
│   │   └── MarkdownHandler.js
│   ├── css/          # Stylesheets
│   └── manifest.json  # Extension manifest
└── Program.cs         # Application entry point
```

### Building for Production

```bash
dotnet publish -c Release
```

The production-ready extension will be in `bin\Release\net9.0\browserextension`

## Technologies Used

- **Blazor WebAssembly**: For building the UI components
- **Markdig**: For Markdown parsing and rendering
- **Blazor.BrowserExtension**: For creating browser extensions with Blazor
- **WebExtensions.Net**: For browser extension APIs

## License

This project is part of the TechieExtensions solution.

## Contributing

Feel free to submit issues and enhancement requests!