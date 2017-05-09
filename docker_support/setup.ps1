$serviceName = (Get-Item .).Name.split('.')[2]

write-host

$preRun = '.\Run-Before-Container-Setup.ps1'

if($preRun | Test-Path){
	Write-Host "Running Run-Before-Container-Setup.ps1... " -NoNewline
    & $preRun
	Write-Host Complete.
	Write-Host 
}

& $PSScriptRoot\Create-VolumeFolders.ps1

docker-compose up -d

write-host

$postRun = '.\Run-After-Container-Setup.ps1'

if($postRun | Test-Path)
{
    & $postRun
}

& $PSScriptRoot\Get-Services.ps1 | Format-Table Name, Url, IPAddress

& $PSScriptRoot\Edit-HostsFile.ps1