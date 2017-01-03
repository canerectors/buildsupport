docker-compose -f .\docker-compose.yaml pull

docker-compose -f .\docker-compose.yaml up -d

write-host

$postRun = .\post_run_commands.ps1

if($postRun | Test-Path)
{
    & $postRun
}

.\docker_support\Get-Services.ps1 | Format-Table Name, Url

write-host
write-host "You will need to restart Explorer and Visual Studio in order for Environment Variable changes to take effect." -foregroundcolor "yellow"