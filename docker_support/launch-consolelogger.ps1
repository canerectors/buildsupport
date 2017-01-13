$services = .\docker_support\Get-Services.ps1

$loggerServiceName = ($services | Where-Object {$_.Name -like '*consolelogger*'}).Name

docker exec -it $loggerServiceName consolelogger