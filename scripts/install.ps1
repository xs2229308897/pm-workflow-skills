# PM Multi-Agent Workflow Install Script (PowerShell)
# Usage: Run in target project root: powershell -File X:\path\to\pm-workflow-skills\scripts\install.ps1

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillDir = Split-Path -Parent $scriptDir

Write-Host "PM Multi-Agent Workflow Install Script" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Source: $skillDir"
Write-Host "Target: $(Get-Location)"
Write-Host ""

if (-not (Test-Path "src") -and -not (Test-Path "app") -and -not (Test-Path "lib")) {
    Write-Host "Warning: Current directory may not be a project root (no src/app/lib found)" -ForegroundColor Yellow
    $confirm = Read-Host "Continue? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Cancelled"
        exit 0
    }
}

New-Item -ItemType Directory -Force -Path ".claude\skills" | Out-Null

Write-Host "Copying skill files..." -ForegroundColor Green
$skillDirs = Get-ChildItem "$skillDir" -Directory -Filter "pm-*"
foreach ($dir in $skillDirs) {
    $target = ".claude\skills\$($dir.Name)"
    if (Test-Path $target) {
        Write-Host "  Skip $($dir.Name) (already exists)" -ForegroundColor Yellow
    } else {
        Copy-Item $dir.FullName -Destination $target -Recurse
        Write-Host "  Installed $($dir.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "B-mode skills (pm-process-modeler, pm-permission-designer) are included above." -ForegroundColor Green
Write-Host "  These skills are only active when B-mode is enabled in pm-leader." -ForegroundColor Gray

Write-Host ""
Write-Host "Copying global lessons..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path ".claude\skills\pm-leader\lessons" | Out-Null
if (-not (Test-Path ".claude\skills\pm-leader\lessons\global-lessons.md")) {
    Copy-Item "$skillDir\lessons\global-lessons.md" -Destination ".claude\skills\pm-leader\lessons\"
    Write-Host "  Created global lessons file" -ForegroundColor Green
} else {
    Write-Host "  Skip global lessons (already exists)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Copying hooks scripts..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path ".claude\skills\pm-leader\scripts\hooks" | Out-Null
if (Test-Path "$skillDir\scripts\hooks") {
    Copy-Item "$skillDir\scripts\hooks\*" -Destination ".claude\skills\pm-leader\scripts\hooks\" -Force
    Write-Host "  Installed hooks scripts" -ForegroundColor Green
} else {
    Write-Host "  Skip hooks (source not found)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Copying MCP config example..." -ForegroundColor Green
if (-not (Test-Path "mcp-config.example.json")) {
    Copy-Item "$skillDir\mcp-config.example.json" -Destination "."
    Write-Host "  Created mcp-config.example.json" -ForegroundColor Green
} else {
    Write-Host "  Skip mcp-config.example.json (already exists)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Copying PM tools..." -ForegroundColor Green
if (-not (Test-Path "tools\pm-mcp-server")) {
    Copy-Item "$skillDir\tools" -Destination "tools" -Recurse
    Write-Host "  Installed tools directory" -ForegroundColor Green
    Write-Host ""
    Write-Host "To build PM MCP tools, run:" -ForegroundColor Yellow
    Write-Host "  cd tools\pm-mcp-server; npm install; npm run build" -ForegroundColor Yellow
} else {
    Write-Host "  Skip tools (already exists)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Creating docs directory..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "docs\superpowers\pm-output" | Out-Null

if (-not (Test-Path "docs\superpowers\pm-workflow-state.md")) {
    Copy-Item "$skillDir\docs\superpowers\pm-workflow-state.md" -Destination "docs\superpowers\"
    Write-Host "  Created docs\superpowers\pm-workflow-state.md" -ForegroundColor Green
} else {
    Write-Host "  Skip pm-workflow-state.md (already exists)" -ForegroundColor Yellow
}

if (-not (Test-Path "docs\superpowers\pm-lessons-learned.md")) {
    Copy-Item "$skillDir\docs\superpowers\pm-lessons-learned.md" -Destination "docs\superpowers\"
    Write-Host "  Created docs\superpowers\pm-lessons-learned.md" -ForegroundColor Green
} else {
    Write-Host "  Skip pm-lessons-learned.md (already exists)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================" -ForegroundColor Cyan
Write-Host "Install complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Edit .claude\skills\pm-prototype-builder\SKILL.md"
Write-Host "     Replace the Project Spec section with your tech stack"
Write-Host "     Templates: pm-prototype-builder\templates\"
Write-Host ""
Write-Host "  2. Run /pm-leader in Claude Code to start"
