# Contributing to TechieExtensions

Thank you for your interest in contributing to TechieExtensions! This document provides guidelines and information for contributors.

## 🚀 Quick Start

### Development Setup

1. **Prerequisites**
   - .NET 9.0 SDK or later
   - Git
   - A code editor (Visual Studio, VS Code, etc.)

2. **Setup**
   ```bash
   # Clone the repository
   git clone https://github.com/YOUR_USERNAME/TechieExtensions.git
   cd TechieExtensions
   
   # Run setup script
   powershell -ExecutionPolicy Bypass -File scripts/setup-dev.ps1
   ```

3. **Build and Test**
   ```bash
   # Build specific extension
   cd TrMdManager  # or TrJsonManager
   dotnet build
   
   # Create package for testing
   powershell -ExecutionPolicy Bypass -File package-extension.ps1
   ```

## 📝 How to Contribute

### Reporting Issues

1. **Search existing issues** to avoid duplicates
2. **Use issue templates** when available
3. **Provide clear reproduction steps**
4. **Include browser and extension version**

### Suggesting Features

1. **Check existing feature requests**
2. **Describe the use case** clearly
3. **Explain the expected behavior**
4. **Consider implementation complexity**

### Code Contributions

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Test thoroughly**
5. **Commit with clear messages**
6. **Push and create pull request**

## 🏗️ Development Guidelines

### Code Style

#### C# (Blazor Components)
- Follow standard C# naming conventions
- Use `PascalCase` for public members
- Use `camelCase` for private fields with underscore prefix
- Add XML documentation for public APIs

```csharp
/// <summary>
/// Validates and formats JSON content
/// </summary>
/// <param name="jsonContent">The JSON string to validate</param>
/// <returns>Validation result with error details</returns>
public JsonValidationResult ValidateJson(string jsonContent)
{
    // Implementation
}
```

#### JavaScript
- Use camelCase for variables and functions
- Use UPPER_CASE for constants
- Add JSDoc comments for functions

```javascript
/**
 * Downloads JSON content as a file
 * @param {string} content - The JSON content
 * @param {string} filename - The target filename
 */
window.downloadJson = function(content, filename) {
    // Implementation
};
```

#### CSS
- Use kebab-case for class names
- Follow BEM methodology when appropriate
- Group related styles together

```css
.json-editor-container {
    /* Container styles */
}

.json-editor-container__toolbar {
    /* Toolbar styles */
}
```

### File Structure

```
TechieExtensions/
├── .github/workflows/          # GitHub Actions
├── scripts/                    # Build and utility scripts
├── TrMdManager/               # Markdown extension
│   ├── Components/            # Blazor components
│   ├── Services/              # Business logic
│   ├── wwwroot/              # Static assets
│   └── dist/                 # Build output
└── TrJsonManager/            # JSON extension
    └── (same structure)
```

### Component Guidelines

#### Blazor Components
- Keep components focused and single-purpose
- Use dependency injection for services
- Handle errors gracefully
- Make components reusable when possible

```csharp
@inject IJsonService JsonService
@inject IJSRuntime JSRuntime

<div class="component-container">
    @* Component content *@
</div>

@code {
    [Parameter] public string? InitialContent { get; set; }
    
    protected override void OnInitialized()
    {
        // Initialization logic
    }
}
```

#### Services
- Use interfaces for dependency injection
- Keep business logic separate from UI
- Add proper error handling
- Write unit tests for complex logic

### Testing

#### Manual Testing Checklist
- [ ] Extension loads in Chrome/Edge
- [ ] Extension loads in Firefox  
- [ ] All features work as expected
- [ ] No console errors
- [ ] Responsive design works
- [ ] Accessibility considerations

#### Browser Testing
Test in at least:
- Chrome (latest)
- Edge (latest)
- Firefox (latest)

### Performance Considerations

1. **Bundle Size**
   - Minimize external dependencies
   - Use tree shaking when possible
   - Optimize images and assets

2. **Memory Usage**
   - Dispose of event listeners
   - Clean up resources properly
   - Avoid memory leaks

3. **Responsiveness**
   - Use async/await for long operations
   - Implement loading states
   - Handle large file processing

## 🔄 Release Process

### Versioning
We follow [Semantic Versioning](https://semver.org/):
- **Major**: Breaking changes
- **Minor**: New features (backward compatible)
- **Patch**: Bug fixes (backward compatible)

### Creating Releases

1. **Automated (Recommended)**
   ```bash
   # Create and push version tag
   git tag v1.2.3
   git push origin v1.2.3
   
   # GitHub Actions will handle the rest
   ```

2. **Manual Release Script**
   ```bash
   powershell -ExecutionPolicy Bypass -File scripts/create-release.ps1 -ReleaseType patch
   ```

### Release Checklist
- [ ] All tests pass
- [ ] Version updated in manifest.json
- [ ] CHANGELOG updated
- [ ] Documentation updated
- [ ] Extensions tested in all browsers

## 📚 Documentation

### README Updates
- Keep feature lists current
- Update screenshots when UI changes
- Maintain installation instructions
- Update compatibility information

### Code Documentation
- Document public APIs
- Explain complex algorithms
- Add inline comments for clarity
- Update JSDoc comments

## 🤝 Community Guidelines

### Communication
- Be respectful and constructive
- Help others learn and grow
- Share knowledge and best practices
- Acknowledge contributions

### Issue Management
- Respond to issues promptly
- Label issues appropriately
- Close resolved issues
- Thank contributors

### Pull Request Reviews
- Review code for functionality
- Check for security issues
- Verify documentation updates
- Test changes locally

## 🛡️ Security

### Reporting Security Issues
- **DO NOT** open public issues for security vulnerabilities
- Email security issues privately
- Allow time for fixes before disclosure

### Security Best Practices
- Validate all user inputs
- Use HTTPS for external requests
- Follow browser extension security guidelines
- Regularly update dependencies

## 📄 License

By contributing to TechieExtensions, you agree that your contributions will be licensed under the same license as the project.

## ❓ Questions?

- **General questions**: Open a GitHub Discussion
- **Bug reports**: Create an Issue
- **Feature requests**: Create an Issue with feature template
- **Security issues**: Email privately

## 🎉 Recognition

Contributors will be:
- Listed in README.md
- Mentioned in release notes
- Added to CONTRIBUTORS.md (if created)
- Thanked in commit messages

Thank you for making TechieExtensions better! 🚀