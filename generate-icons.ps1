# PowerShell script to help generate PNG icons from SVG
# Requires Inkscape or ImageMagick to be installed

Write-Host "Icon Generation Helper Script" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green

# Create icons directory
$iconsPath = ".\icons"
if (!(Test-Path $iconsPath)) {
    New-Item -ItemType Directory -Path $iconsPath
    New-Item -ItemType Directory -Path "$iconsPath\json-manager"
    New-Item -ItemType Directory -Path "$iconsPath\markdown-manager"
}

Write-Host "`nManual Icon Creation Steps:" -ForegroundColor Yellow
Write-Host "1. Open generate-icons.html in Chrome" -ForegroundColor White
Write-Host "2. For each icon:" -ForegroundColor White
Write-Host "   a. Right-click on the icon" -ForegroundColor Gray
Write-Host "   b. Select 'Open image in new tab'" -ForegroundColor Gray
Write-Host "   c. Right-click and 'Save image as...'" -ForegroundColor Gray
Write-Host "   d. Save to the appropriate folder:" -ForegroundColor Gray
Write-Host "      - icons\json-manager\ for JSON Manager icons" -ForegroundColor Cyan
Write-Host "      - icons\markdown-manager\ for Markdown Manager icons" -ForegroundColor Cyan

Write-Host "`n3. Name the files as follows:" -ForegroundColor White
Write-Host "   - icon-16.png (16x16)" -ForegroundColor Gray
Write-Host "   - icon-48.png (48x48)" -ForegroundColor Gray
Write-Host "   - icon-96.png (96x96 for Firefox)" -ForegroundColor Gray
Write-Host "   - icon-128.png (128x128 main icon)" -ForegroundColor Gray

Write-Host "`n4. After saving all icons, copy them to extension folders:" -ForegroundColor White
Write-Host "   - Copy json-manager icons to: TrJsonManager\wwwroot\" -ForegroundColor Cyan
Write-Host "   - Copy markdown-manager icons to: TrMdManager\wwwroot\" -ForegroundColor Cyan

Write-Host "`nAlternative: Using Online Tools" -ForegroundColor Yellow
Write-Host "1. Use svg2png.com to convert SVG to PNG" -ForegroundColor White
Write-Host "2. Use remove.bg to remove backgrounds if needed" -ForegroundColor White
Write-Host "3. Use squoosh.app to optimize PNG files" -ForegroundColor White

Write-Host "`nUpdating Manifests..." -ForegroundColor Green

# Function to update manifest with icon paths
function Update-ManifestIcons {
    param (
        [string]$ManifestPath
    )
    
    if (Test-Path $ManifestPath) {
        $manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
        
        # Update icon paths
        $manifest.icons = @{
            "16" = "icon-16.png"
            "48" = "icon-48.png"
            "128" = "icon-128.png"
        }
        
        $manifest | ConvertTo-Json -Depth 10 | Set-Content $ManifestPath
        Write-Host "Updated: $ManifestPath" -ForegroundColor Green
    }
}

# Update both manifests
Update-ManifestIcons -ManifestPath ".\TrJsonManager\wwwroot\manifest.json"
Update-ManifestIcons -ManifestPath ".\TrMdManager\wwwroot\manifest.json"

Write-Host "`nCreating placeholder icons..." -ForegroundColor Yellow

# Create simple placeholder PNG files using .NET
Add-Type -AssemblyName System.Drawing

function Create-PlaceholderIcon {
    param (
        [string]$Path,
        [int]$Size,
        [string]$Text,
        [string]$Color
    )
    
    $bitmap = New-Object System.Drawing.Bitmap $Size, $Size
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Fill background
    $brush = [System.Drawing.Brushes]::$Color
    $graphics.FillRectangle($brush, 0, 0, $Size, $Size)
    
    # Add text
    $font = New-Object System.Drawing.Font("Arial", ($Size / 4), [System.Drawing.FontStyle]::Bold)
    $textBrush = [System.Drawing.Brushes]::White
    $stringFormat = New-Object System.Drawing.StringFormat
    $stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
    $stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF(0, 0, $Size, $Size)
    
    $graphics.DrawString($Text, $font, $textBrush, $rect, $stringFormat)
    
    $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    
    Write-Host "Created placeholder: $Path" -ForegroundColor Gray
}

# Create placeholder icons for JSON Manager
Create-PlaceholderIcon -Path ".\TrJsonManager\wwwroot\icon-16.png" -Size 16 -Text "J" -Color "Blue"
Create-PlaceholderIcon -Path ".\TrJsonManager\wwwroot\icon-48.png" -Size 48 -Text "JS" -Color "Blue"
Create-PlaceholderIcon -Path ".\TrJsonManager\wwwroot\icon-128.png" -Size 128 -Text "JSON" -Color "Blue"

# Create placeholder icons for Markdown Manager
Create-PlaceholderIcon -Path ".\TrMdManager\wwwroot\icon-16.png" -Size 16 -Text "M" -Color "Red"
Create-PlaceholderIcon -Path ".\TrMdManager\wwwroot\icon-48.png" -Size 48 -Text "MD" -Color "Red"
Create-PlaceholderIcon -Path ".\TrMdManager\wwwroot\icon-128.png" -Size 128 -Text "MD" -Color "Red"

Write-Host "`nPlaceholder icons created!" -ForegroundColor Green
Write-Host "Replace these with the proper icons from generate-icons.html" -ForegroundColor Yellow

Write-Host "`nDone!" -ForegroundColor Green