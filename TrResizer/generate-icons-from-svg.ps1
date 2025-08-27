# Generate icons from SVG design with window and resize arrows
param(
    [string]$OutputDir = "wwwroot"
)

Write-Host "Generating Techie ReSizer Icons from SVG Design..." -ForegroundColor Cyan

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;

public class IconRenderer {
    public static void RenderIcon(int size, string outputPath) {
        using (Bitmap bitmap = new Bitmap(size, size))
        using (Graphics g = Graphics.FromImage(bitmap)) {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.InterpolationMode = InterpolationMode.HighQualityBicubic;
            
            // Calculate scaling
            float scale = size / 512.0f;
            
            // Create gradient background
            using (LinearGradientBrush gradientBrush = new LinearGradientBrush(
                new Point(0, 0),
                new Point(size, size),
                Color.FromArgb(102, 126, 234),  // #667eea
                Color.FromArgb(118, 75, 162)))  // #764ba2
            {
                // Draw rounded rectangle background
                int cornerRadius = (int)(64 * scale);
                if (cornerRadius < 4) cornerRadius = 4;
                
                GraphicsPath path = new GraphicsPath();
                Rectangle rect = new Rectangle(0, 0, size, size);
                
                if (size >= 32) {
                    // Add rounded rectangle
                    path.AddArc(rect.X, rect.Y, cornerRadius * 2, cornerRadius * 2, 180, 90);
                    path.AddArc(rect.Right - cornerRadius * 2, rect.Y, cornerRadius * 2, cornerRadius * 2, 270, 90);
                    path.AddArc(rect.Right - cornerRadius * 2, rect.Bottom - cornerRadius * 2, cornerRadius * 2, cornerRadius * 2, 0, 90);
                    path.AddArc(rect.X, rect.Bottom - cornerRadius * 2, cornerRadius * 2, cornerRadius * 2, 90, 90);
                    path.CloseFigure();
                    
                    g.FillPath(gradientBrush, path);
                } else {
                    g.FillRectangle(gradientBrush, 0, 0, size, size);
                }
            }
            
            // Draw window frame
            using (Pen whitePen = new Pen(Color.FromArgb(230, 255, 255, 255), Math.Max(1, 12 * scale))) {
                int windowX = (int)(80 * scale);
                int windowY = (int)(120 * scale);
                int windowWidth = (int)(352 * scale);
                int windowHeight = (int)(272 * scale);
                
                if (size >= 48) {
                    // Draw window outline
                    g.DrawRectangle(whitePen, windowX, windowY, windowWidth, windowHeight);
                    
                    // Draw title bar
                    using (SolidBrush titleBarBrush = new SolidBrush(Color.FromArgb(51, 255, 255, 255))) {
                        g.FillRectangle(titleBarBrush, windowX, windowY, windowWidth, (int)(48 * scale));
                    }
                    
                    // Draw resize arrows
                    int centerX = size / 2;
                    int centerY = size / 2;
                    
                    using (Pen arrowPen = new Pen(Color.White, Math.Max(2, 16 * scale))) {
                        arrowPen.StartCap = LineCap.Round;
                        arrowPen.EndCap = LineCap.Round;
                        
                        // Horizontal arrow
                        int arrowLength = (int)(120 * scale);
                        g.DrawLine(arrowPen, centerX - arrowLength, centerY, centerX + arrowLength, centerY);
                        
                        // Horizontal arrow heads
                        int headSize = (int)(20 * scale);
                        g.DrawLine(arrowPen, centerX - arrowLength, centerY, centerX - arrowLength + headSize, centerY - headSize);
                        g.DrawLine(arrowPen, centerX - arrowLength, centerY, centerX - arrowLength + headSize, centerY + headSize);
                        g.DrawLine(arrowPen, centerX + arrowLength, centerY, centerX + arrowLength - headSize, centerY - headSize);
                        g.DrawLine(arrowPen, centerX + arrowLength, centerY, centerX + arrowLength - headSize, centerY + headSize);
                        
                        // Vertical arrow
                        int vArrowLength = (int)(80 * scale);
                        g.DrawLine(arrowPen, centerX, centerY - vArrowLength, centerX, centerY + vArrowLength);
                        
                        // Vertical arrow heads
                        g.DrawLine(arrowPen, centerX, centerY - vArrowLength, centerX - headSize, centerY - vArrowLength + headSize);
                        g.DrawLine(arrowPen, centerX, centerY - vArrowLength, centerX + headSize, centerY - vArrowLength + headSize);
                        g.DrawLine(arrowPen, centerX, centerY + vArrowLength, centerX - headSize, centerY + vArrowLength - headSize);
                        g.DrawLine(arrowPen, centerX, centerY + vArrowLength, centerX + headSize, centerY + vArrowLength - headSize);
                    }
                    
                    // Corner resize dots
                    if (size >= 128) {
                        using (SolidBrush dotBrush = new SolidBrush(Color.FromArgb(204, 255, 255, 255))) {
                            int dotSize = (int)(8 * scale * 2);
                            g.FillEllipse(dotBrush, (int)(432 * scale) - dotSize/2, (int)(392 * scale) - dotSize/2, dotSize, dotSize);
                            g.FillEllipse(dotBrush, (int)(408 * scale) - dotSize/2, (int)(392 * scale) - dotSize/2, dotSize, dotSize);
                            g.FillEllipse(dotBrush, (int)(432 * scale) - dotSize/2, (int)(368 * scale) - dotSize/2, dotSize, dotSize);
                        }
                    }
                } else {
                    // For small icons, just show "TR" text
                    using (Font font = new Font("Segoe UI", size * 0.4f, FontStyle.Bold))
                    using (SolidBrush textBrush = new SolidBrush(Color.White)) {
                        string text = "TR";
                        SizeF textSize = g.MeasureString(text, font);
                        g.DrawString(text, font, textBrush, (size - textSize.Width) / 2, (size - textSize.Height) / 2);
                    }
                }
            }
            
            bitmap.Save(outputPath, System.Drawing.Imaging.ImageFormat.Png);
        }
    }
}
"@ -ReferencedAssemblies System.Drawing

# Create directories
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

if (-not (Test-Path "store-assets")) {
    New-Item -ItemType Directory -Path "store-assets" -Force | Out-Null
}

# Generate icons
$sizes = @(16, 32, 48, 128, 256, 512)
foreach ($size in $sizes) {
    $outputPath = Join-Path $OutputDir "icon$size.png"
    [IconRenderer]::RenderIcon($size, $outputPath)
    Write-Host "  Created: icon$size.png (${size}x${size})" -ForegroundColor Green
}

# Generate store assets
[IconRenderer]::RenderIcon(128, "store-assets\icon-128.png")
[IconRenderer]::RenderIcon(512, "store-assets\icon-512.png")
Write-Host "  Created: store-assets\icon-128.png" -ForegroundColor Green
Write-Host "  Created: store-assets\icon-512.png" -ForegroundColor Green

# Create promotional images
function Create-PromoImage {
    param([int]$Width, [int]$Height, [string]$OutputPath)
    
    $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    
    # Gradient background
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.Point]::new(0, 0),
        [System.Drawing.Point]::new($Width, $Height),
        [System.Drawing.Color]::FromArgb(255, 102, 126, 234),
        [System.Drawing.Color]::FromArgb(255, 118, 75, 162)
    )
    
    $graphics.FillRectangle($brush, 0, 0, $Width, $Height)
    
    # Draw text
    $fontSize = [int]([Math]::Min($Width, $Height) * 0.08)
    $font = New-Object System.Drawing.Font("Segoe UI", $fontSize, [System.Drawing.FontStyle]::Bold)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    
    $text = "Techie ReSizer"
    $textSize = $graphics.MeasureString($text, $font)
    $x = ($Width - $textSize.Width) / 2
    $y = ($Height - $textSize.Height) / 2
    
    # Shadow
    $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 0, 0, 0))
    $graphics.DrawString($text, $font, $shadowBrush, $x + 3, $y + 3)
    
    # Main text
    $graphics.DrawString($text, $font, $textBrush, $x, $y)
    
    # Subtitle
    $subtitleFont = New-Object System.Drawing.Font("Segoe UI", ($fontSize * 0.4), [System.Drawing.FontStyle]::Regular)
    $subtitle = "Window Resizer Extension"
    $subtitleSize = $graphics.MeasureString($subtitle, $subtitleFont)
    $subX = ($Width - $subtitleSize.Width) / 2
    $subY = $y + $textSize.Height + 10
    
    $graphics.DrawString($subtitle, $subtitleFont, $textBrush, $subX, $subY)
    
    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Cleanup
    $font.Dispose()
    $subtitleFont.Dispose()
    $textBrush.Dispose()
    $shadowBrush.Dispose()
    $brush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    
    Write-Host "  Created: $OutputPath" -ForegroundColor Green
}

Create-PromoImage -Width 440 -Height 280 -OutputPath "store-assets\promo-small-440x280.png"
Create-PromoImage -Width 920 -Height 680 -OutputPath "store-assets\promo-large-920x680.png"
Create-PromoImage -Width 1400 -Height 560 -OutputPath "store-assets\promo-marquee-1400x560.png"

Write-Host "`nIcon generation complete!" -ForegroundColor Green