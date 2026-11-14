<#
.SYNOPSIS
    Live preview gate, steps 1 and 2: load the latest code, then check the
    Laravel Herd preview serves it. Run before any development work.

.DESCRIPTION
    1. Stops if tracked files have uncommitted changes. Fetches origin, fast-
       forwards the branch, and merges origin/main into it (a merge commit, never
       a rebase; a conflict is aborted and reported). Nothing is pushed.
    2. Runs composer install (through Herd) or npm ci when a lock file is newer
       than the installed dependencies.
    3. Checks Herd is running, the site is linked to this clone on the
       profile's PHP version (docs/herd/profile.json), /VERSION matches the
       VERSION file, and a missing page returns 404 (LocalValetDriver.php).
    4. Starts Browsersync in its own window if nothing listens on its port.

    Opening the page in Cursor's browser is the agent's step 3.

    Exit codes: 0 ready, 1 blocked (the message says why), 3 needs a decision.

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File scripts\preview.ps1
#>
[CmdletBinding()]
param(
    [switch]$NoSync,
    [switch]$NoMergeMain,
    [switch]$NoDevServer
)

$ErrorActionPreference = 'Stop'

function Write-Step([string]$Message) { Write-Host "==> $Message" -ForegroundColor Cyan }
function Write-Ok([string]$Message) { Write-Host "    $Message" -ForegroundColor Green }
function Write-Warn([string]$Message) { Write-Host "    WARNING: $Message" -ForegroundColor Yellow }
function Stop-Preview([int]$Code, [string]$Message) { Write-Host "    STOP: $Message" -ForegroundColor Red; exit $Code }

function Invoke-Native([scriptblock]$Command) {
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $output = & $Command 2>&1 } finally { $ErrorActionPreference = $previous }
    return [pscustomobject]@{ Code = $LASTEXITCODE; Output = ($output | Out-String).Trim() }
}

function Get-Page([string]$Url) {
    try {
        $content = (Invoke-WebRequest $Url -UseBasicParsing -TimeoutSec 60).Content
        if ($content -is [byte[]]) { $content = [Text.Encoding]::UTF8.GetString($content) }
        return $content
    } catch {
        $stream = $_.Exception.Response.GetResponseStream()
        if ($null -eq $stream) { return $null }
        return (New-Object IO.StreamReader $stream).ReadToEnd()
    }
}

$repo = Split-Path $PSScriptRoot -Parent
$profileJson = Get-Content (Join-Path $repo 'docs\herd\profile.json') -Raw | ConvertFrom-Json
$Config = @{
    Site       = $profileJson.site
    AppUrl     = $profileJson.appUrl
    Php        = $profileJson.php
    DevPort    = $profileJson.devServerPort
    HealthPath = '/VERSION'
    DevCommand = 'npm run dev'
}
$herdBin = Join-Path $env:USERPROFILE '.config\herd\bin'
$herd = Join-Path $herdBin 'herd.bat'
if (-not (Test-Path $herd)) { Stop-Preview 1 "Laravel Herd is not installed ($herd not found)." }
$env:Path = "$herdBin;$env:ProgramFiles\nodejs;" + $env:Path
if (-not $env:XDEBUG_MODE) { $env:XDEBUG_MODE = 'off' }

Push-Location $repo
try {
    # 1. Latest code ------------------------------------------------------------
    Write-Step 'Latest code'
    $before = (git rev-parse HEAD).Trim()
    $branch = (git branch --show-current).Trim()
    if ($NoSync) {
        Write-Warn 'Skipped the sync (-NoSync)'
    } else {
        $dirty = @(git status --porcelain --untracked-files=no)
        if ($dirty.Count -gt 0) { Stop-Preview 3 "$($dirty.Count) tracked files have uncommitted changes. Commit them or decide what to do before syncing." }
        $fetch = Invoke-Native { git fetch origin --prune --tags }
        if ($fetch.Code -ne 0) { Stop-Preview 1 "git fetch failed: $($fetch.Output)" }
        $upstream = Invoke-Native { git rev-parse --abbrev-ref '@{u}' }
        if ($upstream.Code -eq 0) {
            $ff = Invoke-Native { git merge --ff-only '@{u}' }
            if ($ff.Code -ne 0) { Stop-Preview 3 "$branch and $($upstream.Output) have both moved on. Merge them (no rebase), then run this again." }
        }
        if ($branch -ne 'main' -and -not $NoMergeMain) {
            $behind = [int](git rev-list --count 'HEAD..origin/main').Trim()
            if ($behind -gt 0) {
                $merge = Invoke-Native { git merge --no-edit origin/main }
                if ($merge.Code -ne 0) {
                    Invoke-Native { git merge --abort } | Out-Null
                    Stop-Preview 3 "Merging origin/main into $branch conflicts. The merge was aborted; resolve it before starting work."
                }
                Write-Ok "Merged $behind commits from origin/main into $branch (not pushed)"
            }
        }
    }
    $head = (git rev-parse HEAD).Trim()
    $short = $head.Substring(0, 12)
    Write-Ok "$branch at $short"

    # 2. Dependencies -----------------------------------------------------------
    Write-Step 'Dependencies'
    if (Test-Path 'composer.lock') {
        $installed = Join-Path $repo 'vendor\composer\installed.json'
        if (-not (Test-Path $installed) -or (Get-Item 'composer.lock').LastWriteTime -gt (Get-Item $installed).LastWriteTime) {
            $run = Invoke-Native { & $herd composer install --no-interaction --no-progress }
            if ($run.Code -ne 0) { Stop-Preview 1 "composer install failed: $($run.Output)" }
            Write-Ok 'Ran composer install'
        } else { Write-Ok 'Composer dependencies are current' }
    }
    if (Test-Path 'package-lock.json') {
        $npmMarker = Join-Path $repo 'node_modules\.package-lock.json'
        if (-not (Test-Path $npmMarker) -or (Get-Item 'package-lock.json').LastWriteTime -gt (Get-Item $npmMarker).LastWriteTime) {
            $run = Invoke-Native { npm ci --no-audit --no-fund }
            if ($run.Code -ne 0) { Stop-Preview 1 "npm ci failed: $($run.Output)" }
            Write-Ok 'Ran npm ci (restart the dev server if it was running)'
        } else { Write-Ok 'npm dependencies are current' }
    }
    # 3. Herd and the preview ----------------------------------------------------
    Write-Step "Herd preview $($Config.AppUrl)"
    if (-not (Get-Process Herd -ErrorAction SilentlyContinue)) { Stop-Preview 1 'Herd is not running. Open Laravel Herd.' }
    $info = Invoke-Native { & $herd site:info $Config.Site --json }
    $site = $null
    try { $site = $info.Output | ConvertFrom-Json } catch { }
    if ($null -eq $site -or -not $site.path) { Stop-Preview 1 "$($Config.Site) is not linked in Herd. Run scripts\herd-setup.ps1." }
    if ($site.path.TrimEnd('\') -ine $repo.TrimEnd('\')) { Stop-Preview 1 "$($Config.Site) is linked to $($site.path), not this clone. Run scripts\herd-setup.ps1." }
    if ($site.isolatedPhpVersion -ne $Config.Php) { Write-Warn "The site runs PHP $($site.phpVersion), not the profile's $($Config.Php). Run scripts\herd-setup.ps1." }
    $served = "$(Get-Page "$($Config.AppUrl)$($Config.HealthPath)")".Trim()
    $expected = (Get-Content (Join-Path $repo 'public\VERSION') -Raw).Trim()
    if (-not $served) { Stop-Preview 1 "$($Config.AppUrl)$($Config.HealthPath) did not answer. Check herd status." }
    if ($served -ne $expected) { Stop-Preview 1 "The preview serves VERSION $served, not $expected from this checkout. Run scripts\herd-setup.ps1." }
    $missing = "$(curl.exe -s -o NUL -w '%{http_code}' --max-time 15 "$($Config.AppUrl)/preview-check-$([guid]::NewGuid().ToString('N'))")"
    if ($missing -ne '404') { Stop-Preview 1 "A missing page returned $missing, not 404. Check LocalValetDriver.php is at the repo root (herd which)." }
    Write-Ok "Serves this checkout (VERSION $served) on PHP $($site.phpVersion); a missing page returns 404"

    # 4. Dev server ------------------------------------------------------------
    Write-Step "Dev server on port $($Config.DevPort)"
    if (Get-NetTCPConnection -State Listen -LocalPort $Config.DevPort -ErrorAction SilentlyContinue) {
        Write-Ok 'Already running'
    } elseif ($NoDevServer) {
        Write-Warn "Not running (-NoDevServer). Start it with $($Config.DevCommand)."
    } else {
        Start-Process -FilePath 'cmd.exe' -ArgumentList '/c', $Config.DevCommand -WorkingDirectory $repo -WindowStyle Minimized
        Write-Ok "Started $($Config.DevCommand) in its own window"
    }

    Write-Step 'Ready'
    Write-Ok "Open http://localhost:$($Config.DevPort) in Cursor's browser (Browsersync proxying $($Config.AppUrl), reloads on save)."
    if ($before -ne $head) { Write-Ok "Code moved from $($before.Substring(0, 12)) to $short during the sync." }
} finally {
    Pop-Location
}
