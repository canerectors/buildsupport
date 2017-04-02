$services = & $PSScriptRoot\Get-Services.ps1

$hostsPath = "$env:windir\System32\drivers\etc\hosts"

$hostsPathOrig = $hostsPath + ".orig"

#backup original hosts file
if(!(Test-Path ($hostsPathOrig))){ Write-Host "Backing up $hostsPath to $hostsPathOrig`n";  copy $hostsPath $hostsPathOrig }

& $PSScriptRoot\Clean-HostsFile.ps1

Write-Host
Write-Host Adding services to hosts file...

$hosts = get-content $hostsPath

#append docker services to hosts file
$services | Foreach { $hosts += $_.IPAddress + "`t" + $_.Name  + "`t`t#" + $_.Name}

Write-Host "Added $($services.Length) entries to hosts file."

$hosts | Out-File $hostsPath -enc ascii