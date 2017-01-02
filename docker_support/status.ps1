$idsrvIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_idsrv_1

$ravenIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_ravendb_1

$webloggerIp = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' canerectorswebapi_weblogger_1

$ravenUrl = "http://" + $ravenIp + ":8080"
$idsrvUrl = "http://" + $idsrvIp
$webloggerUrl = "http://" + $webloggerIp

write-host
write-host Raven Db is accessable at: $ravenUrl
write-host
write-host Identity Server is accessable at: $idsrvUrl
write-host
write-host WebLogger is accessable at: $webloggerUrl

pause