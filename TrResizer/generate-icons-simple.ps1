# Simple icon generation script that actually works
param(
    [string]$OutputDir = "wwwroot"
)

Write-Host "Generating TrResizer Icons..." -ForegroundColor Cyan

Add-Type -AssemblyName System.Drawing

function Create-Icon {
    param(
        [int]$Size,
        [string]$OutputPath
    )
    
    # Create bitmap
    $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    # Create gradient background - Purple gradient (#667eea to #764ba2)
    $rect = New-Object System.Drawing.Rectangle(0, 0, $Size, $Size)
    $color1 = [System.Drawing.Color]::FromArgb(255, 102, 126, 234)  # #667eea
    $color2 = [System.Drawing.Color]::FromArgb(255, 118, 75, 162)   # #764ba2
    
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.Point]::new(0, 0),
        [System.Drawing.Point]::new($Size, $Size),
        $color1,
        $color2
    )
    
    # Fill background with gradient
    $graphics.FillRectangle($brush, 0, 0, $Size, $Size)
    
    # Add rounded corners effect (draw a rounded rectangle)
    if ($Size -ge 48) {
        $cornerRadius = [int]($Size * 0.125)  # 12.5% corner radius
        $path = New-Object System.Drawing.Drawing2D.GraphicsPath
        
        # Create rounded rectangle path
        $path.AddArc(0, 0, $cornerRadius * 2, $cornerRadius * 2, 180, 90)
        $path.AddArc($Size - $cornerRadius * 2, 0, $cornerRadius * 2, $cornerRadius * 2, 270, 90)
        $path.AddArc($Size - $cornerRadius * 2, $Size - $cornerRadius * 2, $cornerRadius * 2, $cornerRadius * 2, 0, 90)
        $path.AddArc(0, $Size - $cornerRadius * 2, $cornerRadius * 2, $cornerRadius * 2, 90, 90)
        $path.CloseFigure()
        
        # Create new bitmap with rounded corners
        $roundedBitmap = New-Object System.Drawing.Bitmap($Size, $Size)
        $roundedGraphics = [System.Drawing.Graphics]::FromImage($roundedBitmap)
        $roundedGraphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        
        # Fill with transparent background first
        $roundedGraphics.Clear([System.Drawing.Color]::Transparent)
        
        # Set clipping region to rounded rectangle
        $roundedGraphics.SetClip($path)
        
        # Draw the gradient bitmap onto the rounded bitmap
        $roundedGraphics.DrawImage($bitmap, 0, 0)
        
        # Clean up and use rounded bitmap
        $graphics.Dispose()
        $bitmap.Dispose()
        $bitmap = $roundedBitmap
        $graphics = $roundedGraphics
    }
    
    # Draw "TR" text
    $fontSize = [int]($Size * 0.35)
    if ($fontSize -lt 10) { $fontSize = 10 }
    
    $font = New-Object System.Drawing.Font("Segoe UI", $fontSize, [System.Drawing.FontStyle]::Bold)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    
    # Measure text to center it
    $text = "TR"
    $textSize = $graphics.MeasureString($text, $font)
    $x = ($Size - $textSize.Width) / 2
    $y = ($Size - $textSize.Height) / 2
    
    # Add shadow for better visibility
    if ($Size -ge 32) {
        $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 0, 0, 0))
        $graphics.DrawString($text, $font, $shadowBrush, $x + 2, $y + 2)
        $shadowBrush.Dispose()
    }
    
    # Draw main text
    $graphics.DrawString($text, $font, $textBrush, $x, $y)
    
    # Save the image
    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Clean up
    $font.Dispose()
    $textBrush.Dispose()
    $brush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    
    Write-Host "  Created: $OutputPath (${Size}x${Size})" -ForegroundColor Green
}

# Create output directories if they don't exist
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

if (-not (Test-Path "store-assets")) {
    New-Item -ItemType Directory -Path "store-assets" -Force | Out-Null
}

# Generate extension icons
$iconSizes = @(16, 32, 48, 128, 256, 512)
foreach ($size in $iconSizes) {
    $outputPath = Join-Path $OutputDir "icon$size.png"
    Create-Icon -Size $size -OutputPath $outputPath
}

# Also create specific store assets
Write-Host "`nGenerating store assets..." -ForegroundColor Yellow

# Standard store icons
Create-Icon -Size 128 -OutputPath "store-assets\icon-128.png"
Create-Icon -Size 512 -OutputPath "store-assets\icon-512.png"

# Create promotional images with icon in center
function Create-PromoImage {
    param(
        [int]$Width,
        [int]$Height,
        [string]$OutputPath
    )
    
    # Create bitmap
    $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    
    # Create gradient background
    $rect = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
    $color1 = [System.Drawing.Color]::FromArgb(255, 102, 126, 234)  # #667eea
    $color2 = [System.Drawing.Color]::FromArgb(255, 118, 75, 162)   # #764ba2
    
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.Point]::new(0, 0),
        [System.Drawing.Point]::new($Width, $Height),
        $color1,
        $color2
    )
    
    # Fill background
    $graphics.FillRectangle($brush, 0, 0, $Width, $Height)
    
    # Draw centered "TrResizer" text
    $fontSize = [int]([Math]::Min($Width, $Height) * 0.1)
    $font = New-Object System.Drawing.Font("Segoe UI", $fontSize, [System.Drawing.FontStyle]::Bold)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    
    $text = "TrResizer"
    $textSize = $graphics.MeasureString($text, $font)
    $x = ($Width - $textSize.Width) / 2
    $y = ($Height - $textSize.Height) / 2
    
    # Add shadow
    $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 0, 0, 0))
    $graphics.DrawString($text, $font, $shadowBrush, $x + 3, $y + 3)
    
    # Draw main text
    $graphics.DrawString($text, $font, $textBrush, $x, $y)
    
    # Add subtitle
    $subtitleFont = New-Object System.Drawing.Font("Segoe UI", ($fontSize * 0.4), [System.Drawing.FontStyle]::Regular)
    $subtitle = "Window Resizer Extension"
    $subtitleSize = $graphics.MeasureString($subtitle, $subtitleFont)
    $subX = ($Width - $subtitleSize.Width) / 2
    $subY = $y + $textSize.Height + 10
    
    $graphics.DrawString($subtitle, $subtitleFont, $textBrush, $subX, $subY)
    
    # Save the image
    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Clean up
    $font.Dispose()
    $subtitleFont.Dispose()
    $textBrush.Dispose()
    $shadowBrush.Dispose()
    $brush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    
    Write-Host "  Created: $OutputPath (${Width}x${Height})" -ForegroundColor Green
}

# Create promotional images
Create-PromoImage -Width 440 -Height 280 -OutputPath "store-assets\promo-small-440x280.png"
Create-PromoImage -Width 920 -Height 680 -OutputPath "store-assets\promo-large-920x680.png"
Create-PromoImage -Width 1400 -Height 560 -OutputPath "store-assets\promo-marquee-1400x560.png"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Icon Generation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Extension icons: $OutputDir\icon*.png" -ForegroundColor Yellow
Write-Host "Store assets: store-assets\*.png" -ForegroundColor Yellow