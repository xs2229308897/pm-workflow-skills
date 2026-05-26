# PM Multi-Agent Workflow - One-line Install
# Usage: cd YOUR_PROJECT; irm https://raw.githubusercontent.com/xs2229308897/pm-workflow-skills/main/scripts/install-remote.ps1 | iex

$ErrorActionPreference = "Stop"
$repo = "https://github.com/xs2229308897/pm-workflow-skills/archive/refs/heads/main.zip"
$tempDir = Join-Path $env:TEMP "pm-workflow-install-$(Get-Random)"

Write-Host "PM Multi-Agent Workflow - Installing..." -ForegroundColor Cyan
Write-Host ""

# Check project root
if (-not (Test-Path "src") -and -not (Test-Path "app") -and -not (Test-Path "lib")) {
    Write-Host "Warning: no src/app/lib found. Run from your project root." -ForegroundColor Yellow
    $c = Read-Host "Continue? (y/N)"
    if ($c -ne "y" -and $c -ne "Y") { exit 0 }
}

try {
    # Download
    Write-Host "Downloading..." -ForegroundColor Gray
    $zip = Join-Path $env:TEMP "pm-workflow-skills.zip"
    Invoke-WebRequest -Uri $repo -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $tempDir -Force
    Remove-Item $zip -Force
    $src = Get-ChildItem $tempDir -Directory | Select-Object -First 1

    # Copy skills
    New-Item -ItemType Directory -Force -Path ".claude\skills" | Out-Null
    Get-ChildItem "$($src.FullName)" -Directory -Filter "pm-*" | ForEach-Object {
        $target = ".claude\skills\$($_.Name)"
        if (Test-Path $target) {
            Write-Host "  ~ $($_.Name) (exists)" -ForegroundColor Yellow
        } else {
            Copy-Item $_.FullName -Destination $target -Recurse
            Write-Host "  + $($_.Name)" -ForegroundColor Green
        }
    }

    # Copy global lessons
    New-Item -ItemType Directory -Force -Path ".claude\skills\pm-leader\lessons" | Out-Null
    if (-not (Test-Path ".claude\skills\pm-leader\lessons\global-lessons.md")) {
        Copy-Item "$($src.FullName)\lessons\global-lessons.md" -Destination ".claude\skills\pm-leader\lessons\"
        Write-Host "  + global-lessons.md" -ForegroundColor Green
    }

    # Copy templates
    New-Item -ItemType Directory -Force -Path "docs\superpowers\pm-output" | Out-Null
    if (-not (Test-Path "docs\superpowers\pm-workflow-state.md")) {
        Copy-Item "$($src.FullName)\docs\superpowers\pm-workflow-state.md" -Destination "docs\superpowers\"
        Write-Host "  + pm-workflow-state.md" -ForegroundColor Green
    }
    if (-not (Test-Path "docs\superpowers\pm-lessons-learned.md")) {
        Copy-Item "$($src.FullName)\docs\superpowers\pm-lessons-learned.md" -Destination "docs\superpowers\"
        Write-Host "  + pm-lessons-learned.md" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Done! Run /pm-leader in Claude Code to start." -ForegroundColor Green
} finally {
    if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
    if (Test-Path "$env:TEMP\pm-workflow-skills.zip") { Remove-Item "$env:TEMP\pm-workflow-skills.zip" -Force }
}
