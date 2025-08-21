# PowerShell script to package the extension for distribution

Write-Host "Packaging Techie Mark Down Manager Extension..." -ForegroundColor Green

# Build in Release mode
Write-Host "Building Release version..." -ForegroundColor Yellow
dotnet publish -c Release

# Create dist folder if it doesn't exist
$distPath = ".\dist"
if (!(Test-Path $distPath)) {
    New-Item -ItemType Directory -Path $distPath
}

# Package for Chrome/Edge (ZIP file)
Write-Host "Creating Chrome/Edge package..." -ForegroundColor Yellow
$chromeSource = ".\bin\Release\net9.0\publish\browserextension\*"
$chromeOutput = ".\dist\TechieMarkDownManager-Chrome-Edge.zip"
Compress-Archive -Path $chromeSource -DestinationPath $chromeOutput -Force

# Package for Firefox (ZIP file, but Firefox needs special handling)
Write-Host "Creating Firefox package..." -ForegroundColor Yellow
$firefoxOutput = ".\dist\TechieMarkDownManager-Firefox.zip"
Compress-Archive -Path $chromeSource -DestinationPath $firefoxOutput -Force

# Create CRX for direct installation (Chrome/Edge)
Write-Host "Note: CRX creation requires Chrome Extension CLI tools" -ForegroundColor Cyan

Write-Host "`nPackaging complete!" -ForegroundColor Green
Write-Host "Output files:" -ForegroundColor Cyan
Write-Host "  - Chrome/Edge: $chromeOutput" -ForegroundColor White
Write-Host "  - Firefox: $firefoxOutput" -ForegroundColor White
Write-Host "`nExtension folder: .\bin\Release\net9.0\publish\browserextension" -ForegroundColor Yellow