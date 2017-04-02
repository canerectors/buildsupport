$serviceName = (Get-Item .).Name.split('.')[2]

write-host

$preRun = '.\pre_container_setup.ps1'

if($preRun | Test-Path)
{
    & $preRun
}

docker-compose -f .\docker-compose.yaml up -d

write-host

$postRun = '.\post_container_setup.ps1'

if($postRun | Test-Path)
{
    & $postRun
}

& $PSScriptRoot\Get-Services.ps1 | Format-Table Name, Url, IPAddress

& $PSScriptRoot\Edit-HostsFile.ps1