docker-compose -f .\docker-compose.yaml pull

docker-compose -f .\docker-compose.yaml up -d

.\docker_support\status.ps1

$idsrvIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_idsrv_1

$ravenIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_ravendb_1

$webloggerIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_weblogger_1

$ravenUrl = "http://" + $ravenIp + ":8080"
$idsrvUrl = "http://" + $idsrvIp
$webloggerUrl = "http://" + $webloggerIp

setx "RavenDb:ServerUrl" $ravenUrl >$null
setx "IDServerAuthority" $idsrvUrl >$null

write-host
write-host "You will need to restart visual studio."