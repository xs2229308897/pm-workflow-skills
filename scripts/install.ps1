# PM 多 Agent 工作流安装脚本 (PowerShell)
# 用法：在目标项目根目录下执行 powershell -File X:\path\to\pm-workflow-skills\scripts\install.ps1

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillDir = Split-Path -Parent $scriptDir

Write-Host "PM 多 Agent 工作流安装脚本" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""
Write-Host "源目录：$skillDir"
Write-Host "目标目录：$(Get-Location)"
Write-Host ""

# 检查是否在项目根目录
if (-not (Test-Path "src") -and -not (Test-Path "app") -and -not (Test-Path "lib")) {
    Write-Host "警告：当前目录可能不是项目根目录（未找到 src/app/lib 目录）" -ForegroundColor Yellow
    $confirm = Read-Host "是否继续？(y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "已取消"
        exit 0
    }
}

# 创建 .claude/skills 目录
New-Item -ItemType Directory -Force -Path ".claude\skills" | Out-Null

# 复制技能文件
Write-Host "正在复制技能文件..." -ForegroundColor Green
$skillDirs = Get-ChildItem "$skillDir" -Directory -Filter "pm-*"
foreach ($dir in $skillDirs) {
    $target = ".claude\skills\$($dir.Name)"
    if (Test-Path $target) {
        Write-Host "  跳过 $($dir.Name)（已存在）" -ForegroundColor Yellow
    } else {
        Copy-Item $dir.FullName -Destination $target -Recurse
        Write-Host "  已安装 $($dir.Name)" -ForegroundColor Green
    }
}

# 复制全局经验教训
Write-Host ""
Write-Host "正在复制全局经验教训..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path ".claude\skills\pm-leader\lessons" | Out-Null
if (-not (Test-Path ".claude\skills\pm-leader\lessons\global-lessons.md")) {
    Copy-Item "$skillDir\lessons\global-lessons.md" -Destination ".claude\skills\pm-leader\lessons\"
    Write-Host "  已创建全局经验教训文件" -ForegroundColor Green
} else {
    Write-Host "  跳过全局经验教训（已存在）" -ForegroundColor Yellow
}

# 创建文档目录
Write-Host ""
Write-Host "正在创建文档目录..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "docs\superpowers\pm-output" | Out-Null

# 复制模板文件
if (-not (Test-Path "docs\superpowers\pm-workflow-state.md")) {
    Copy-Item "$skillDir\docs\superpowers\pm-workflow-state.md" -Destination "docs\superpowers\"
    Write-Host "  已创建 docs\superpowers\pm-workflow-state.md" -ForegroundColor Green
} else {
    Write-Host "  跳过 pm-workflow-state.md（已存在）" -ForegroundColor Yellow
}

if (-not (Test-Path "docs\superpowers\pm-lessons-learned.md")) {
    Copy-Item "$skillDir\docs\superpowers\pm-lessons-learned.md" -Destination "docs\superpowers\"
    Write-Host "  已创建 docs\superpowers\pm-lessons-learned.md" -ForegroundColor Green
} else {
    Write-Host "  跳过 pm-lessons-learned.md（已存在）" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================" -ForegroundColor Cyan
Write-Host "安装完成！" -ForegroundColor Green
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 编辑 .claude\skills\pm-prototype-builder\SKILL.md"
Write-Host "     将'项目规范'章节替换为你的项目技术栈"
Write-Host "     可用模板见 pm-prototype-builder\templates\ 目录"
Write-Host ""
Write-Host "  2. 在 Claude Code 中输入 /pm-leader 开始使用"
