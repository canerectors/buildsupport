$projectName = $args[0]

write-host

$preRun = '.\Run-Before-Container-Setup.ps1'

if($preRun | Test-Path){
	Write-Host "Running Run-Before-Container-Setup.ps1... " -NoNewline
    & $preRun
	Write-Host Complete.
	Write-Host 
}

& $PSScriptRoot\Create-VolumeFolders.ps1

write-host

docker-compose -p $projectName up -d 

write-host

$postRun = '.\Run-After-Container-Setup.ps1'

if($postRun | Test-Path)
{
    & $postRun
}

& $PSScriptRoot\Get-Services.ps1 $(docker-compose -p $projectName ps -q) | Format-Table Name, Url, IPAddress