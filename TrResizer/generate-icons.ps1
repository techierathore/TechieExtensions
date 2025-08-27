# Icon generation script for TrResizer
# Generates all required icon sizes for browser extension stores

param(
    [string]$InputSvg = "assets\icon.svg",
    [string]$OutputDir = "wwwroot",
    [switch]$CleanOld = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TrResizer Icon Generation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if ImageMagick is installed
$magickPath = Get-Command magick -ErrorAction SilentlyContinue
if (-not $magickPath) {
    Write-Host "ImageMagick is not installed or not in PATH!" -ForegroundColor Red
    Write-Host "Please install ImageMagick from: https://imagemagick.org/script/download.php#windows" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Or install via winget:" -ForegroundColor Yellow
    Write-Host "  winget install ImageMagick.ImageMagick" -ForegroundColor White
    
    # Alternative: Use .NET for basic PNG generation
    Write-Host ""
    Write-Host "Attempting fallback method using .NET..." -ForegroundColor Yellow
    
    Add-Type -AssemblyName System.Drawing
    
    function Convert-SvgToPng {
        param(
            [string]$svgPath,
            [string]$pngPath,
            [int]$size
        )
        
        # Create a simple colored square as fallback
        $bitmap = New-Object System.Drawing.Bitmap $size, $size
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        
        # Create gradient background (purple to pink)
        $rect = New-Object System.Drawing.Rectangle 0, 0, $size, $size
        $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, 
            [System.Drawing.Color]::FromArgb(102, 126, 234),
            [System.Drawing.Color]::FromArgb(118, 75, 162),
            [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
        
        $graphics.FillRectangle($brush, $rect)
        
        # Add "TR" text
        $font = New-Object System.Drawing.Font "Arial", ($size * 0.3), [System.Drawing.FontStyle]::Bold
        $textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $stringFormat = New-Object System.Drawing.StringFormat
        $stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
        $stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
        
        $graphics.DrawString("TR", $font, $textBrush, ($size/2), ($size/2), $stringFormat)
        
        # Save as PNG
        $bitmap.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Cleanup
        $graphics.Dispose()
        $bitmap.Dispose()
        $brush.Dispose()
        $font.Dispose()
        $textBrush.Dispose()
        
        Write-Host "  Created $pngPath (${size}x${size})" -ForegroundColor Green
    }
    
    # Generate icons using .NET fallback
    $sizes = @(16, 32, 48, 128, 256, 512)
    foreach ($size in $sizes) {
        $outputPath = Join-Path $OutputDir "icon$size.png"
        Convert-SvgToPng -svgPath $InputSvg -pngPath $outputPath -size $size
    }
    
    # Create store assets
    if (-not (Test-Path "store-assets")) {
        New-Item -ItemType Directory -Path "store-assets" -Force | Out-Null
    }
    
    # Copy larger sizes to store-assets
    Copy-Item (Join-Path $OutputDir "icon128.png") -Destination "store-assets\icon-128.png" -Force
    Copy-Item (Join-Path $OutputDir "icon512.png") -Destination "store-assets\icon-512.png" -Force
    
    # Create promotional images (just copies for now)
    Copy-Item (Join-Path $OutputDir "icon512.png") -Destination "store-assets\promo-small-440x280.png" -Force
    Copy-Item (Join-Path $OutputDir "icon512.png") -Destination "store-assets\promo-large-920x680.png" -Force
    Copy-Item (Join-Path $OutputDir "icon512.png") -Destination "store-assets\promo-marquee-1400x560.png" -Force
    
} else {
    Write-Host "ImageMagick found. Generating high-quality icons..." -ForegroundColor Green
    
    # Icon sizes required for extensions
    $iconSizes = @{
        "icon16.png" = 16
        "icon32.png" = 32
        "icon48.png" = 48
        "icon128.png" = 128
        "icon256.png" = 256
        "icon512.png" = 512
    }
    
    # Store asset sizes
    $storeAssets = @{
        "icon-128.png" = @(128, 128)
        "icon-512.png" = @(512, 512)
        "screenshot-1280x800.png" = @(1280, 800)
        "screenshot-640x400.png" = @(640, 400)
        "promo-small-440x280.png" = @(440, 280)
        "promo-large-920x680.png" = @(920, 680)
        "promo-marquee-1400x560.png" = @(1400, 560)
    }
    
    # Clean old icons if requested
    if ($CleanOld) {
        Write-Host "Cleaning old icons..." -ForegroundColor Yellow
        Remove-Item "$OutputDir\icon*.png" -Force -ErrorAction SilentlyContinue
        Remove-Item "store-assets\*.png" -Force -ErrorAction SilentlyContinue
    }
    
    # Check if input SVG exists
    if (-not (Test-Path $InputSvg)) {
        Write-Host "Input SVG not found: $InputSvg" -ForegroundColor Red
        exit 1
    }
    
    # Generate extension icons
    Write-Host "Generating extension icons..." -ForegroundColor Yellow
    foreach ($icon in $iconSizes.GetEnumerator()) {
        $outputPath = Join-Path $OutputDir $icon.Key
        $size = $icon.Value
        
        $cmd = "magick convert -background none -density 300 -resize ${size}x${size} `"$InputSvg`" `"$outputPath`""
        Invoke-Expression $cmd
        
        if (Test-Path $outputPath) {
            Write-Host "  Created $($icon.Key) (${size}x${size})" -ForegroundColor Green
        } else {
            Write-Host "  Failed to create $($icon.Key)" -ForegroundColor Red
        }
    }
    
    # Create store-assets directory
    if (-not (Test-Path "store-assets")) {
        New-Item -ItemType Directory -Path "store-assets" -Force | Out-Null
    }
    
    # Generate store assets
    Write-Host ""
    Write-Host "Generating store assets..." -ForegroundColor Yellow
    foreach ($asset in $storeAssets.GetEnumerator()) {
        $outputPath = Join-Path "store-assets" $asset.Key
        $width = $asset.Value[0]
        $height = $asset.Value[1]
        
        if ($asset.Key -like "screenshot*") {
            # For screenshots, create a canvas with the icon centered
            $cmd = "magick convert -size ${width}x${height} xc:'#667eea' -gravity center `"$InputSvg`" -composite `"$outputPath`""
        } elseif ($asset.Key -like "promo*") {
            # For promotional images, create a gradient background with icon
            $cmd = "magick convert -size ${width}x${height} gradient:'#667eea-#764ba2' -gravity center -background none -density 300 -resize 200x200 `"$InputSvg`" -composite `"$outputPath`""
        } else {
            # Regular icon generation
            $cmd = "magick convert -background none -density 300 -resize ${width}x${height} `"$InputSvg`" `"$outputPath`""
        }
        
        Invoke-Expression $cmd
        
        if (Test-Path $outputPath) {
            Write-Host "  Created $($asset.Key) (${width}x${height})" -ForegroundColor Green
        } else {
            Write-Host "  Failed to create $($asset.Key)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Icon Generation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Extension icons: $OutputDir\icon*.png" -ForegroundColor Yellow
Write-Host "Store assets: store-assets\*.png" -ForegroundColor Yellow
Write-Host ""