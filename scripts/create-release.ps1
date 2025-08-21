# PowerShell script to create a new release
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("major", "minor", "patch")]
    [string]$ReleaseType,
    
    [string]$Message = ""
)

Write-Host "Creating new $ReleaseType release..." -ForegroundColor Green

# Get current version from git tags
$currentVersion = git describe --tags --abbrev=0 2>$null
if (-not $currentVersion) {
    $currentVersion = "v0.0.0"
    Write-Host "No previous tags found, starting from v0.0.0" -ForegroundColor Yellow
}

Write-Host "Current version: $currentVersion" -ForegroundColor Cyan

# Parse version
$versionMatch = $currentVersion -match "v(\d+)\.(\d+)\.(\d+)"
if (-not $versionMatch) {
    Write-Error "Invalid version format: $currentVersion"
    exit 1
}

$major = [int]$matches[1]
$minor = [int]$matches[2]
$patch = [int]$matches[3]

# Increment version based on release type
switch ($ReleaseType) {
    "major" {
        $major++
        $minor = 0
        $patch = 0
    }
    "minor" {
        $minor++
        $patch = 0
    }
    "patch" {
        $patch++
    }
}

$newVersion = "v$major.$minor.$patch"
Write-Host "New version: $newVersion" -ForegroundColor Green

# Confirm with user
$confirm = Read-Host "Create release $newVersion? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Release cancelled" -ForegroundColor Yellow
    exit 0
}

# Update manifest.json files with new version
$manifestFiles = @(
    "TrMdManager/wwwroot/manifest.json",
    "TrJsonManager/wwwroot/manifest.json"
)

foreach ($manifestFile in $manifestFiles) {
    if (Test-Path $manifestFile) {
        Write-Host "Updating $manifestFile" -ForegroundColor Cyan
        $content = Get-Content $manifestFile -Raw
        $content = $content -replace '"version":\s*"[\d\.]+"', "`"version`": `"$major.$minor.$patch`""
        Set-Content $manifestFile $content -NoNewline
    }
}

# Build both extensions
Write-Host "Building extensions..." -ForegroundColor Cyan

Push-Location "TrMdManager"
& powershell -ExecutionPolicy Bypass -File package-extension.ps1
Pop-Location

Push-Location "TrJsonManager"  
& powershell -ExecutionPolicy Bypass -File package-extension.ps1
Pop-Location

# Commit changes
Write-Host "Committing version updates..." -ForegroundColor Cyan
git add .
git commit -m "Release $newVersion$(if($Message) { ": $Message" })"

# Create and push tag
Write-Host "Creating tag $newVersion..." -ForegroundColor Cyan
git tag $newVersion

Write-Host "Pushing to repository..." -ForegroundColor Cyan
git push origin main
git push origin $newVersion

Write-Host "Release $newVersion created successfully!" -ForegroundColor Green
Write-Host "GitHub Actions will automatically create the release with packages." -ForegroundColor Cyan
Write-Host ""
Write-Host "Monitor the release at:" -ForegroundColor Yellow
Write-Host "https://github.com/YOUR_USERNAME/TechieExtensions/releases" -ForegroundColor Blue