docker-compose -f .\docker-compose.yaml pull

docker-compose -f .\docker-compose.yaml up -d

write-host

.\post_run_commands.ps1

.\docker_support\Get-IPAddresses.ps1

write-host
write-host "You will need to restart Explorer and Visual Studio in order for Environment Variable changes to take effect." -foregroundcolor "yellow"