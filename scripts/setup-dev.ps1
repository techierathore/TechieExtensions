# Development Environment Setup Script
Write-Host "Setting up TechieExtensions development environment..." -ForegroundColor Green

# Check .NET installation
Write-Host "Checking .NET installation..." -ForegroundColor Cyan
$dotnetVersion = dotnet --version 2>$null
if (-not $dotnetVersion) {
    Write-Error ".NET SDK is not installed. Please install .NET 9.0 SDK from https://dotnet.microsoft.com/download"
    exit 1
}
Write-Host "✓ .NET SDK version: $dotnetVersion" -ForegroundColor Green

# Check if version is 9.0 or higher
$versionParts = $dotnetVersion.Split('.')
if ([int]$versionParts[0] -lt 9) {
    Write-Warning "⚠️  .NET 9.0 or higher is recommended. Current version: $dotnetVersion"
}

# Install required templates
Write-Host "Installing Blazor.BrowserExtension template..." -ForegroundColor Cyan
dotnet new install Blazor.BrowserExtension.Template

# Restore dependencies for both projects
Write-Host "Restoring dependencies..." -ForegroundColor Cyan

Push-Location "TrMdManager"
dotnet restore
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to restore TrMdManager dependencies"
    exit 1
}
Pop-Location

Push-Location "TrJsonManager"
dotnet restore  
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to restore TrJsonManager dependencies"
    exit 1
}
Pop-Location

# Build both projects to verify setup
Write-Host "Building projects to verify setup..." -ForegroundColor Cyan

Push-Location "TrMdManager"
dotnet build
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build TrMdManager"
    exit 1
}
Write-Host "✓ TrMdManager built successfully" -ForegroundColor Green
Pop-Location

Push-Location "TrJsonManager"
dotnet build
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build TrJsonManager"
    exit 1
}
Write-Host "✓ TrJsonManager built successfully" -ForegroundColor Green
Pop-Location

Write-Host ""
Write-Host "🎉 Development environment setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Load extensions in browser for testing:" -ForegroundColor White
Write-Host "   - Chrome/Edge: chrome://extensions/ → Load unpacked → Select browserextension folder" -ForegroundColor Gray
Write-Host "   - Firefox: about:debugging → Load Temporary Add-on → Select manifest.json" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Development commands:" -ForegroundColor White
Write-Host "   - Build: dotnet build" -ForegroundColor Gray
Write-Host "   - Package: powershell -ExecutionPolicy Bypass -File package-extension.ps1" -ForegroundColor Gray
Write-Host "   - Create release: scripts/create-release.ps1 -ReleaseType patch" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Extension locations:" -ForegroundColor White
Write-Host "   - TrMdManager: bin/Debug/net9.0/browserextension/" -ForegroundColor Gray
Write-Host "   - TrJsonManager: bin/Debug/net9.0/browserextension/" -ForegroundColor Gray