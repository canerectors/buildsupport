$services = @($args[0])

if($services.Length -le 0){ return; }

$hostsPath = "$env:windir\System32\drivers\etc\hosts"

$hostsPathOrig = $hostsPath + ".orig"

#backup original hosts file
if(!(Test-Path ($hostsPathOrig))){ Write-Host "Backing up $hostsPath to $hostsPathOrig`n";  copy $hostsPath $hostsPathOrig }

& $PSScriptRoot\Clean-HostsFile.ps1 $services

Write-Host
Write-Host Adding services to hosts file...
Write-Host

$hosts = get-content $hostsPath

#append docker services to hosts file
$services | ForEach-Object { $hosts += $_.IPAddress + "`t" + $_.Name  + "`t`t#docker_service: " + $_.Name; Write-Host Added Service: $_.Name at IP: $_.IPAddress}

Write-Host
Write-Host "Added $($services.Length) entries to hosts file."
Write-Host

$hosts | Out-File $hostsPath -enc ascii