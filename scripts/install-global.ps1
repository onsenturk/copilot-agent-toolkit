#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Installs copilot-agent-toolkit instructions, agents, and skills as user level
    customizations so they apply to every workspace and across tools.

.DESCRIPTION
    Copies into the documented GA user profile locations:
      - .github/instructions/*.instructions.md  ->  ~/.copilot/instructions/
      - .github/agents/*.agent.md               ->  ~/.copilot/agents/
      - .github/skills/*/                       ->  ~/.copilot/skills/
                                                ->  ~/.claude/skills/
                                                ->  ~/.agents/skills/

    ~/.copilot is read by VS Code and GitHub Copilot CLI. ~/.claude is read by
    Claude Code. ~/.agents is an additional skills location some tools honor.

    Instructions keep their applyTo globs and apply across every workspace.
    Enable Settings Sync (Prompts and Instructions) to propagate user
    instructions across your machines.

    MCP servers are not installed by this script. Install the toolkit as an
    agent plugin (see README) to get its MCP servers, or merge .vscode/mcp.json
    into your user settings manually.

.PARAMETER Force
    Overwrite existing files and folders without prompting.

.PARAMETER DryRun
    Show what would be copied without writing anything.
#>
[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------- paths ----------
# $PSScriptRoot is the scripts/ folder; the repo root is one level up.
$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $repoRoot '.github'))) {
    throw "Could not locate .github folder relative to script (expected at $repoRoot\.github)."
}

$copilotInstructionsFolder = Join-Path $HOME '.copilot\instructions'
$copilotAgentsFolder       = Join-Path $HOME '.copilot\agents'

# Skills are an open standard; mirror them to every tool's personal location.
$skillTargets = @(
    (Join-Path $HOME '.copilot\skills'),
    (Join-Path $HOME '.claude\skills'),
    (Join-Path $HOME '.agents\skills')
)

$srcInstructions = Join-Path $repoRoot '.github\instructions'
$srcAgents       = Join-Path $repoRoot '.github\agents'
$srcSkills       = Join-Path $repoRoot '.github\skills'

# ---------- helpers ----------
function Copy-FileSafe {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )
    if ($DryRun) {
        Write-Host "  [dry-run] would copy  ->  $Destination"
        return
    }
    $destDir = Split-Path -Parent $Destination
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    if ((Test-Path $Destination) -and -not $Force) {
        Write-Warning "Skipping (exists): $Destination  (use -Force to overwrite)"
        return
    }
    Copy-Item -Path $Source -Destination $Destination -Force
    Write-Host "  copied  ->  $Destination"
}

function Copy-DirectorySafe {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )
    if ($DryRun) {
        Write-Host "  [dry-run] would copy  ->  $Destination"
        return
    }
    if ((Test-Path $Destination) -and -not $Force) {
        Write-Warning "Skipping (exists): $Destination  (use -Force to overwrite)"
        return
    }
    # Remove existing target before recursive copy to avoid Copy-Item nesting
    # the source folder INSIDE an existing destination of the same name.
    if (Test-Path $Destination) {
        Remove-Item -Path $Destination -Recurse -Force
    }
    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -Path $Source -Destination $Destination -Recurse -Force
    Write-Host "  copied  ->  $Destination"
}

# ---------- 1. Instructions -> ~/.copilot/instructions ----------
Write-Host "`n=== Installing instruction files ===" -ForegroundColor Cyan
if (Test-Path $srcInstructions) {
    foreach ($file in Get-ChildItem -Path $srcInstructions -Filter '*.instructions.md') {
        Copy-FileSafe -Source $file.FullName -Destination (Join-Path $copilotInstructionsFolder $file.Name)
    }
}
else {
    Write-Warning "No instructions folder found at $srcInstructions"
}

# ---------- 2. Agents -> ~/.copilot/agents ----------
Write-Host "`n=== Installing agent files ===" -ForegroundColor Cyan
if (Test-Path $srcAgents) {
    foreach ($file in Get-ChildItem -Path $srcAgents -Filter '*.agent.md') {
        Copy-FileSafe -Source $file.FullName -Destination (Join-Path $copilotAgentsFolder $file.Name)
    }
}
else {
    Write-Warning "No agents folder found at $srcAgents"
}

# ---------- 3. Skills -> ~/.copilot, ~/.claude, ~/.agents ----------
Write-Host "`n=== Installing skill folders ===" -ForegroundColor Cyan
if (Test-Path $srcSkills) {
    foreach ($skillDir in Get-ChildItem -Path $srcSkills -Directory) {
        foreach ($target in $skillTargets) {
            Copy-DirectorySafe -Source $skillDir.FullName -Destination (Join-Path $target $skillDir.Name)
        }
    }
}
else {
    Write-Warning "No skills folder found at $srcSkills"
}

# ---------- 4. Summary ----------
Write-Host "`n=== Installation complete ===" -ForegroundColor Green
Write-Host "  Instructions: $copilotInstructionsFolder"
Write-Host "  Agents:       $copilotAgentsFolder"
Write-Host "  Skills:       $($skillTargets -join ', ')"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Restart VS Code (or your agent) to pick up the new files."
Write-Host "  2. Enable Settings Sync (Prompts and Instructions) to sync user"
Write-Host "     instructions across your machines."
Write-Host "  3. For MCP servers, install the toolkit as an agent plugin (README)."
Write-Host ""
