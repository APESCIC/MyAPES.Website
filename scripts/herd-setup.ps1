<#
.SYNOPSIS
    Sets up or repairs this website's Laravel Herd site. Safe to run twice; touches only this site.

.DESCRIPTION
    Reads docs/herd/profile.json, links this clone in Herd as <site>.test if it is not linked,
    isolates it to the profile's PHP version, runs npm ci when node_modules is missing, and checks
    the site serves this clone through LocalValetDriver.php (VERSION matches, a missing page is 404).

    Exit codes: 0 ready, 1 blocked, 3 a decision or a click in Herd is needed.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$profile = Get-Content (Join-Path $repo 'docs\herd\profile.json') -Raw | ConvertFrom-Json
$herdBin = Join-Path $env:USERPROFILE '.config\herd\bin'
$herd = Join-Path $herdBin 'herd.bat'

function Write-Ok([string] $Message) { Write-Host "  ok   $Message" -ForegroundColor Green }
function Write-Warn([string] $Message) { Write-Host "  warn $Message" -ForegroundColor Yellow }
function Stop-Setup([int] $Code, [string] $Message) {
    Write-Host "  stop $Message" -ForegroundColor Red
    exit $Code
}
function Invoke-Herd([string[]] $Arguments) {
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    Push-Location $repo
    try { $output = & $herd @Arguments 2>$null | Out-String } finally { Pop-Location; $ErrorActionPreference = $previous }
    return [pscustomobject]@{ Code = $LASTEXITCODE; Output = $output.Trim() }
}
function Get-HerdJson([string[]] $Arguments) {
    $run = Invoke-Herd ($Arguments + '--json')
    if (-not $run.Output) { return $null }
    try { return $run.Output | ConvertFrom-Json } catch { return $null }
}
function Get-Status([string] $Url) { return "$(curl.exe -s -o NUL -w '%{http_code}' --max-time 15 $Url)" }

Write-Host "Herd set-up for $($profile.appUrl)"

if (-not (Test-Path $herd)) { Stop-Setup 1 "Laravel Herd is not installed ($herd not found). Install it from https://herd.laravel.com/windows." }
if (-not (Get-Process Herd -ErrorAction SilentlyContinue)) { Stop-Setup 3 'Herd is not running. Open Laravel Herd, then run this again.' }
Write-Ok 'Herd is running'

$repoPath = (Resolve-Path $repo).Path.TrimEnd('\')
$sites = @(Get-HerdJson @('sites') | ForEach-Object { $_ })
$site = $sites | Where-Object { $_.site -ieq $profile.site } | Select-Object -First 1
if ($site -and ($site.path.TrimEnd('\') -ine $repoPath)) {
    Stop-Setup 1 "$($profile.host) is already linked to $($site.path), not this clone. Unlink it yourself (herd unlink $($profile.site)); this script does not replace it."
}
if (-not $site) {
    $link = Invoke-Herd @('link', $profile.site, "--isolate=$($profile.php)", '--no-interaction')
    if ($link.Code -ne 0) { Stop-Setup 1 "herd link $($profile.site) failed: $($link.Output)" }
    Write-Ok "Linked $repoPath as $($profile.host)"
} else {
    Write-Ok "Linked: $($profile.host) -> $repoPath"
}

$info = Get-HerdJson @('site:info', $profile.site)
if ($null -eq $info) { Stop-Setup 1 "herd site:info $($profile.site) did not answer." }
if ($info.isolatedPhpVersion -ne $profile.php) {
    $isolate = Invoke-Herd @('isolate', $profile.php, '--no-interaction')
    if ($isolate.Code -ne 0) { Stop-Setup 1 "herd isolate $($profile.php) failed: $($isolate.Output). Ask Bambie before running herd php:install $($profile.php)." }
    Write-Ok "Isolated to PHP $($profile.php)"
} else {
    Write-Ok "PHP $($profile.php) (isolated)"
}
if ($info.secured) { Write-Warn "$($profile.host) is served over HTTPS; Browsersync proxies $($profile.appUrl). Run herd unsecure $($profile.site) to match." }

if (-not (Test-Path (Join-Path $repo 'node_modules'))) {
    $env:Path = "$herdBin;$env:ProgramFiles\nodejs;$env:Path"
    Push-Location $repo
    try { npm ci --no-audit --no-fund; if ($LASTEXITCODE) { Stop-Setup 1 'npm ci failed.' } }
    finally { Pop-Location }
    Write-Ok 'npm ci'
} else {
    Write-Ok 'node_modules present'
}

$served = "$(curl.exe -s --max-time 15 "$($profile.appUrl)/VERSION")".Trim()
$expected = (Get-Content (Join-Path $repo 'public\VERSION') -Raw).Trim()
if (-not $served) { Stop-Setup 3 "$($profile.appUrl) did not answer. Check Herd's services are running (herd status), then run this again." }
if ($served -ne $expected) { Stop-Setup 1 "$($profile.appUrl)/VERSION is $served, not $expected from this clone." }
Write-Ok "$($profile.appUrl) serves this clone (VERSION $served)"

$missing = Get-Status "$($profile.appUrl)/herd-setup-check-$([guid]::NewGuid().ToString('N'))"
if ($missing -ne '404') { Stop-Setup 1 "A missing page returned $missing, not 404. Check $($profile.driver) is at the repo root (herd which)." }
Write-Ok "A missing page returns 404 ($($profile.driver))"

Write-Host 'Ready. Run scripts\preview.ps1 for the live preview.'
exit 0
