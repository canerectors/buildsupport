$idsrvIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_idsrv_1

$ravenIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_ravendb_1

$webloggerIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_weblogger_1

$ravenUrl = "http://" + $ravenIp + ":8080"
$idsrvUrl = "http://" + $idsrvIp
$webloggerUrl = "http://" + $webloggerIp

start "$ravenUrl"
start "$webloggerUrl"
start "$idsrvUrl"