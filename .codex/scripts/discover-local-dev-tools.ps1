[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

function Get-ToolVersion {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string[]]$Arguments = @('--version')
    )

    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $command) {
        return [pscustomobject]@{
            Tool    = $Name
            Found   = $false
            Path    = ''
            Version = 'MISSING'
        }
    }

    $version = ''
    try {
        $output = & $command.Source @Arguments 2>&1
        $version = ($output | Select-Object -First 1 | Out-String).Trim()
    }
    catch {
        $version = "found; version check failed: $($_.Exception.Message)"
    }

    [pscustomobject]@{
        Tool    = $Name
        Found   = $true
        Path    = $command.Source
        Version = $version
    }
}

$tools = @(
    @{ Name = 'git'; Arguments = @('--version') },
    @{ Name = 'gh'; Arguments = @('--version') },
    @{ Name = 'rg'; Arguments = @('--version') },
    @{ Name = 'node'; Arguments = @('--version') },
    @{ Name = 'npm'; Arguments = @('--version') },
    @{ Name = 'python'; Arguments = @('--version') },
    @{ Name = 'php'; Arguments = @('-v') },
    @{ Name = 'composer'; Arguments = @('--version') },
    @{ Name = 'mysql'; Arguments = @('--version') },
    @{ Name = 'mariadb'; Arguments = @('--version') },
    @{ Name = 'pwsh'; Arguments = @('--version') },
    @{ Name = 'powershell'; Arguments = @('-NoProfile', '-Command', '$PSVersionTable.PSVersion.ToString()') }
)

Write-Host 'APES CIC local development tool discovery'
Write-Host "Repository: $(Get-Location)"
Write-Host "Timestamp: $(Get-Date -Format o)"
Write-Host ''

$results = foreach ($tool in $tools) {
    Get-ToolVersion -Name $tool.Name -Arguments $tool.Arguments
}

$results | Format-Table -AutoSize

$laragonPaths = @('C:\laragon', 'C:\Laragon') | Where-Object { Test-Path -LiteralPath $_ }

Write-Host ''
Write-Host 'Local environment hints'
[pscustomobject]@{
    Laragon = if ($laragonPaths) { $laragonPaths -join '; ' } else { 'not found at common Windows paths' }
} | Format-List

Write-Host 'Discovery is read-only. Missing tools are blockers unless the user approves installation.'
