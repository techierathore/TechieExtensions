# Cleanup script for TrResizer project
# Removes build artifacts and temporary files before committing to git

param(
    [switch]$DryRun = $false,
    [switch]$Verbose = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TrResizer Cleanup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "DRY RUN MODE - No files will be deleted" -ForegroundColor Yellow
    Write-Host ""
}

$totalSize = 0
$fileCount = 0

# Directories to remove completely
$dirsToRemove = @(
    "bin",
    "obj",
    "dist",
    "dist-simple",
    "dist-chrome-edge", 
    "dist-firefox",
    "release",
    "publish",
    ".vs",
    "TestResults",
    "packages"
)

# File patterns to remove
$filePatternsToRemove = @(
    "*.dll",
    "*.pdb",
    "*.cache",
    "*.log",
    "*.tmp",
    "*.temp",
    "*.bak",
    "*.backup",
    "*_backup*",
    "*_old*",
    "*.user",
    "*.suo",
    "*.br",  # Brotli compressed files
    "*.gz",  # Gzip compressed files
    ".DS_Store",
    "Thumbs.db"
)

# Files to keep (whitelist)
$filesToKeep = @(
    "wwwroot\*",
    "assets\*",
    "*.cs",
    "*.razor",
    "*.html",
    "*.css",
    "*.js",
    "*.json",
    "*.csproj",
    "*.sln",
    "*.ps1",
    "*.md",
    "*.yml",
    "*.yaml",
    "*.svg",
    "*.png",
    ".gitignore"
)

function Get-Size($path) {
    if (Test-Path $path) {
        if ((Get-Item $path).PSIsContainer) {
            $size = (Get-ChildItem $path -Recurse -File | Measure-Object -Property Length -Sum).Sum
        } else {
            $size = (Get-Item $path).Length
        }
        return [math]::Round($size / 1MB, 2)
    }
    return 0
}

# Remove directories
Write-Host "Cleaning directories..." -ForegroundColor Yellow
foreach ($dir in $dirsToRemove) {
    if (Test-Path $dir) {
        $size = Get-Size $dir
        $totalSize += $size
        
        if ($Verbose) {
            Write-Host "  Removing: $dir (${size}MB)" -ForegroundColor Gray
        }
        
        if (-not $DryRun) {
            Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
        }
        $fileCount++
    }
}

# Remove file patterns
Write-Host "Cleaning files by pattern..." -ForegroundColor Yellow
foreach ($pattern in $filePatternsToRemove) {
    $files = Get-ChildItem -Path . -Filter $pattern -Recurse -File -ErrorAction SilentlyContinue
    
    foreach ($file in $files) {
        # Check if file should be kept
        $shouldKeep = $false
        foreach ($keepPattern in $filesToKeep) {
            if ($file.FullName -like "*$keepPattern*") {
                $shouldKeep = $true
                break
            }
        }
        
        if (-not $shouldKeep) {
            $size = [math]::Round($file.Length / 1MB, 2)
            $totalSize += $size
            
            if ($Verbose) {
                Write-Host "  Removing: $($file.FullName) (${size}MB)" -ForegroundColor Gray
            }
            
            if (-not $DryRun) {
                Remove-Item -Path $file.FullName -Force -ErrorAction SilentlyContinue
            }
            $fileCount++
        }
    }
}

# Special handling for Blazor _framework directory
$frameworkPath = "wwwroot\_framework"
if (Test-Path $frameworkPath) {
    $size = Get-Size $frameworkPath
    Write-Host "  Found _framework directory (${size}MB)" -ForegroundColor Yellow
    Write-Host "  Note: This is needed for Blazor version but causes issues in extensions" -ForegroundColor Gray
    
    if (-not $DryRun) {
        # Don't delete, just warn
        Write-Host "  Keeping _framework for Blazor functionality" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cleanup Summary" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Files/Folders cleaned: $fileCount" -ForegroundColor White
Write-Host "Space freed: ${totalSize}MB" -ForegroundColor White

if ($DryRun) {
    Write-Host ""
    Write-Host "This was a DRY RUN - no files were actually deleted" -ForegroundColor Yellow
    Write-Host "Run without -DryRun flag to actually clean files" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Ready for git commit!" -ForegroundColor Green
Write-Host ""

# Show important files that will be committed
Write-Host "Key files for version control:" -ForegroundColor Cyan
Write-Host "  - Source code (*.cs, *.razor)" -ForegroundColor Gray
Write-Host "  - Web files (*.html, *.css, *.js)" -ForegroundColor Gray
Write-Host "  - Configuration (*.json, *.csproj)" -ForegroundColor Gray
Write-Host "  - Scripts (*.ps1)" -ForegroundColor Gray
Write-Host "  - Documentation (*.md)" -ForegroundColor Gray
Write-Host "  - Assets (wwwroot/*, assets/*)" -ForegroundColor Gray
Write-Host "  - CI/CD (.github/workflows/*)" -ForegroundColor Gray
Write-Host ""