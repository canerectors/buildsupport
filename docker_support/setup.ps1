docker-compose -f .\docker-compose.yaml pull

docker-compose -f .\docker-compose.yaml up -d

write-host

$postRun = '.\post_run_commands.ps1'

if($postRun | Test-Path)
{
    & $postRun
}

.\docker_support\Get-Services.ps1 | Format-Table Name, Url

Write-Host Adding services to hosts file...

.\docker_support\Edit-HostsFile.ps1