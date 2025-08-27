# Build script for TrResizer Browser Extension
# Supports Chrome, Edge, and Firefox packaging

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("chrome", "edge", "firefox", "all")]
    [string]$Browser = "edge",
    
    [Parameter(Mandatory=$false)]
    [switch]$OpenBrowser,
    
    [Parameter(Mandatory=$false)]
    [switch]$Package
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TrResizer Extension Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
if (Test-Path "bin\Release\net9.0\publish") {
    Remove-Item -Path "bin\Release\net9.0\publish" -Recurse -Force
}
if (Test-Path "dist") {
    Remove-Item -Path "dist" -Recurse -Force
}

# Build the Blazor app
Write-Host "Building Blazor WebAssembly app..." -ForegroundColor Yellow
dotnet publish -c Release --nologo

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build completed successfully!" -ForegroundColor Green

# Create distribution folders
$distPath = "dist"
New-Item -ItemType Directory -Force -Path $distPath | Out-Null

function Build-ChromeEdge {
    Write-Host "`nBuilding Chrome/Edge extension..." -ForegroundColor Yellow
    
    $chromePath = "$distPath\chrome-edge"
    New-Item -ItemType Directory -Force -Path $chromePath | Out-Null
    
    # Copy all files from wwwroot
    Copy-Item -Path "bin\Release\net9.0\publish\wwwroot\*" -Destination $chromePath -Recurse -Force
    
    # Rename _framework to blazor-framework to avoid underscore issue
    if (Test-Path "$chromePath\_framework") {
        Write-Host "Renaming _framework to blazor-framework..." -ForegroundColor Yellow
        Rename-Item -Path "$chromePath\_framework" -NewName "blazor-framework" -Force
        
        # Update references in index.html
        $indexPath = "$chromePath\index.html"
        if (Test-Path $indexPath) {
            $content = Get-Content $indexPath -Raw
            # Update script src  
            $content = $content -replace 'src="blazor-framework/blazor\.webassembly\.js"', 'src="blazor-framework/blazor.webassembly.js"'
            # Ensure paths are correct
            $content = $content -replace '/_framework/', '/blazor-framework/'
            Set-Content -Path $indexPath -Value $content -Encoding UTF8
        }
        
        # Update blazor-init.js if it exists
        $blazorInitPath = "$chromePath\js\blazor-init.js"
        if (Test-Path $blazorInitPath) {
            $content = Get-Content $blazorInitPath -Raw
            # Ensure paths are correct in the init script
            $content = $content -replace '/_framework/', '/blazor-framework/'
            Set-Content -Path $blazorInitPath -Value $content -Encoding UTF8
        }
        
        # Update references in blazor.webassembly.js
        $blazorJsPath = "$chromePath\blazor-framework\blazor.webassembly.js"
        if (Test-Path $blazorJsPath) {
            $content = Get-Content $blazorJsPath -Raw
            $content = $content -replace '_framework/', 'blazor-framework/'
            $content = $content -replace '"_framework', '"blazor-framework'
            Set-Content -Path $blazorJsPath -Value $content
        }
        
        # Update blazor.boot.json
        $bootJsonPath = "$chromePath\blazor-framework\blazor.boot.json"
        if (Test-Path $bootJsonPath) {
            $content = Get-Content $bootJsonPath -Raw
            $content = $content -replace '_framework/', 'blazor-framework/'
            $content = $content -replace '"_framework', '"blazor-framework'
            Set-Content -Path $bootJsonPath -Value $content
        }
    }
    
    Write-Host "Chrome/Edge extension built at: $chromePath" -ForegroundColor Green
    
    if ($Package) {
        Write-Host "Creating Chrome/Edge package..." -ForegroundColor Yellow
        Compress-Archive -Path "$chromePath\*" -DestinationPath "$distPath\TrResizer-ChromeEdge.zip" -Force
        Write-Host "Package created: $distPath\TrResizer-ChromeEdge.zip" -ForegroundColor Green
    }
}

function Build-Firefox {
    Write-Host "`nBuilding Firefox extension..." -ForegroundColor Yellow
    
    $firefoxPath = "$distPath\firefox"
    New-Item -ItemType Directory -Force -Path $firefoxPath | Out-Null
    
    # Copy all files from wwwroot
    Copy-Item -Path "bin\Release\net9.0\publish\wwwroot\*" -Destination $firefoxPath -Recurse -Force
    
    # Rename _framework to blazor-framework for Firefox too
    if (Test-Path "$firefoxPath\_framework") {
        Write-Host "Renaming _framework to blazor-framework..." -ForegroundColor Yellow
        Rename-Item -Path "$firefoxPath\_framework" -NewName "blazor-framework" -Force
        
        # Update references in index.html
        $indexPath = "$firefoxPath\index.html"
        if (Test-Path $indexPath) {
            $content = Get-Content $indexPath -Raw
            # Update script src  
            $content = $content -replace 'src="blazor-framework/blazor\.webassembly\.js"', 'src="blazor-framework/blazor.webassembly.js"'
            # Ensure paths are correct
            $content = $content -replace '/_framework/', '/blazor-framework/'
            Set-Content -Path $indexPath -Value $content -Encoding UTF8
        }
        
        # Update blazor-init.js if it exists
        $blazorInitPath = "$firefoxPath\js\blazor-init.js"
        if (Test-Path $blazorInitPath) {
            $content = Get-Content $blazorInitPath -Raw
            # Ensure paths are correct in the init script
            $content = $content -replace '/_framework/', '/blazor-framework/'
            Set-Content -Path $blazorInitPath -Value $content -Encoding UTF8
        }
        
        # Update references in blazor.webassembly.js
        $blazorJsPath = "$firefoxPath\blazor-framework\blazor.webassembly.js"
        if (Test-Path $blazorJsPath) {
            $content = Get-Content $blazorJsPath -Raw
            $content = $content -replace '_framework/', 'blazor-framework/'
            $content = $content -replace '"_framework', '"blazor-framework'
            Set-Content -Path $blazorJsPath -Value $content
        }
        
        # Update blazor.boot.json
        $bootJsonPath = "$firefoxPath\blazor-framework\blazor.boot.json"
        if (Test-Path $bootJsonPath) {
            $content = Get-Content $bootJsonPath -Raw
            $content = $content -replace '_framework/', 'blazor-framework/'
            $content = $content -replace '"_framework', '"blazor-framework'
            Set-Content -Path $bootJsonPath -Value $content
        }
    }
    
    # Modify manifest for Firefox (Manifest V2 if needed)
    $manifest = Get-Content "$firefoxPath\manifest.json" | ConvertFrom-Json
    
    # Firefox-specific modifications can go here
    # For now, the manifest v3 should work with Firefox 109+
    
    $manifest | ConvertTo-Json -Depth 10 | Set-Content "$firefoxPath\manifest.json"
    
    Write-Host "Firefox extension built at: $firefoxPath" -ForegroundColor Green
    
    if ($Package) {
        Write-Host "Creating Firefox package..." -ForegroundColor Yellow
        Compress-Archive -Path "$firefoxPath\*" -DestinationPath "$distPath\TrResizer-Firefox.zip" -Force
        Write-Host "Package created: $distPath\TrResizer-Firefox.zip" -ForegroundColor Green
    }
}

# Build based on selected browser
switch ($Browser) {
    "chrome" { Build-ChromeEdge }
    "edge" { Build-ChromeEdge }
    "firefox" { Build-Firefox }
    "all" {
        Build-ChromeEdge
        Build-Firefox
    }
}

# Open browser for testing
if ($OpenBrowser) {
    switch ($Browser) {
        "edge" {
            Write-Host "`nOpening Microsoft Edge for testing..." -ForegroundColor Yellow
            Write-Host "1. Navigate to: edge://extensions/" -ForegroundColor Cyan
            Write-Host "2. Enable 'Developer mode'" -ForegroundColor Cyan
            Write-Host "3. Click 'Load unpacked'" -ForegroundColor Cyan
            Write-Host "4. Select folder: $((Get-Location).Path)\$distPath\chrome-edge" -ForegroundColor Cyan
            
            Start-Process "msedge.exe" "edge://extensions/"
        }
        "chrome" {
            Write-Host "`nOpening Google Chrome for testing..." -ForegroundColor Yellow
            Write-Host "1. Navigate to: chrome://extensions/" -ForegroundColor Cyan
            Write-Host "2. Enable 'Developer mode'" -ForegroundColor Cyan
            Write-Host "3. Click 'Load unpacked'" -ForegroundColor Cyan
            Write-Host "4. Select folder: $((Get-Location).Path)\$distPath\chrome-edge" -ForegroundColor Cyan
            
            Start-Process "chrome.exe" "chrome://extensions/"
        }
        "firefox" {
            Write-Host "`nOpening Firefox for testing..." -ForegroundColor Yellow
            Write-Host "1. Navigate to: about:debugging" -ForegroundColor Cyan
            Write-Host "2. Click 'This Firefox'" -ForegroundColor Cyan
            Write-Host "3. Click 'Load Temporary Add-on'" -ForegroundColor Cyan
            Write-Host "4. Select file: $((Get-Location).Path)\$distPath\firefox\manifest.json" -ForegroundColor Cyan
            
            Start-Process "firefox.exe" "about:debugging"
        }
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Build Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Extension location:" -ForegroundColor Yellow
Write-Host "  $((Get-Location).Path)\$distPath" -ForegroundColor White
Write-Host ""
Write-Host "To test in Edge:" -ForegroundColor Yellow
Write-Host "  .\build-extension.ps1 -Browser edge -OpenBrowser" -ForegroundColor White
Write-Host ""
Write-Host "To create store packages:" -ForegroundColor Yellow
Write-Host "  .\build-extension.ps1 -Browser all -Package" -ForegroundColor White
Write-Host ""