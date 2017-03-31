$serviceName = (Get-Item .).Name.split('.')[2]

docker-compose -f .\docker-compose.yaml up -d

write-host

$postRun = '.\post_run_commands.ps1'

if($postRun | Test-Path)
{
    & $postRun
}

& $PSScriptRoot\Get-Services.ps1 | Format-Table Name, Url, IPAddress

& $PSScriptRoot\Edit-HostsFile.ps1