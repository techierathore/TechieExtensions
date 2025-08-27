# Simple build script for TrResizer (non-Blazor version)

Write-Host "Building TrResizer Simple Extension..." -ForegroundColor Cyan

# Create dist folder
$distPath = "dist-simple"
if (Test-Path $distPath) {
    Remove-Item -Path $distPath -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $distPath | Out-Null

# Copy required files
Write-Host "Copying extension files..." -ForegroundColor Yellow

# Copy HTML, CSS, JS
Copy-Item -Path "wwwroot\popup.html" -Destination $distPath
Copy-Item -Path "wwwroot\manifest.json" -Destination $distPath
Copy-Item -Path "wwwroot\css" -Destination $distPath -Recurse
Copy-Item -Path "wwwroot\js" -Destination $distPath -Recurse

# Copy icons
$icons = @("icon16.png", "icon32.png", "icon48.png", "icon128.png")
foreach ($icon in $icons) {
    if (Test-Path "wwwroot\$icon") {
        Copy-Item -Path "wwwroot\$icon" -Destination $distPath
    }
}

Write-Host "Build complete!" -ForegroundColor Green
Write-Host ""
Write-Host "To test in Edge:" -ForegroundColor Yellow
Write-Host "1. Open Edge and go to: edge://extensions/" -ForegroundColor White
Write-Host "2. Enable Developer mode" -ForegroundColor White
Write-Host "3. Click 'Load unpacked'" -ForegroundColor White
Write-Host "4. Select: $((Get-Location).Path)\$distPath" -ForegroundColor White
Write-Host ""

# Optionally open Edge
$response = Read-Host "Open Edge now? (y/n)"
if ($response -eq 'y') {
    Start-Process "msedge.exe" "edge://extensions/"
}