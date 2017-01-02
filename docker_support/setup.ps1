docker-compose -f .\docker-compose.dev.yaml pull

docker-compose -f .\docker-compose.dev.yaml up -d

.\docker_support\status.ps1

$idsrvIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_idsrv_1

$ravenIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_ravendb_1

$webloggerIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_weblogger_1

$ravenUrl = "http://" + $ravenIp + ":8080"
$idsrvUrl = "http://" + $idsrvIp
$webloggerUrl = "http://" + $webloggerIp

setx "RavenDb:ServerUrl" $ravenUrl
setx "IDServerAuthority" $idsrvUrl

#cmd.exe /c "taskkill /IM explorer.exe /F"
#cmd.exe /c "explorer.exe"

write-host
write-host "You will need to restart visual studio."