param([string]$Directory = $PSScriptRoot)
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath($Directory).TrimEnd([IO.Path]::DirectorySeparatorChar)
$prefix = $root + [IO.Path]::DirectorySeparatorChar
$manifest = Get-Content -LiteralPath (Join-Path $root 'SHA256SUMS.json') -Raw | ConvertFrom-Json
$count = 0
foreach ($entry in $manifest) {
    $file = [IO.Path]::GetFullPath((Join-Path $root $entry.path))
    if (-not $file.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)) { throw "Invalid manifest path: $($entry.path)" }
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "Missing: $($entry.path)" }
    $info = Get-Item -LiteralPath $file
    if ($info.Length -ne [long]$entry.bytes) { throw "Size mismatch: $($entry.path)" }
    if ((Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash -ne $entry.sha256) { throw "SHA-256 mismatch: $($entry.path)" }
    $count++
}
$actual = @(Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object { $_.Name -ne 'SHA256SUMS.json' })
if ($actual.Count -ne $count) { throw "Unexpected file count: actual=$($actual.Count), manifest=$count" }
Write-Output "HANDOFF_INTEGRITY_PASS files=$count"
