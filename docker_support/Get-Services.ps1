$arr = docker-compose.exe ps

For ($i=2; $i -le $arr.Length; $i++) {
    $line = $arr[$i] -split ' ' | Where-Object {$_}

    if(-not $line -or -not $line[0])
    {
        continue
    }

    $serviceName = $line[0]

    $port = (($line -like '*/tcp') -split '/')[0]
    $ip = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $serviceName

    $obj = new-object psobject
    $obj | add-member noteproperty Name $serviceName
    $obj | add-member noteproperty IPAddress $ip
    $obj | add-member noteproperty Port $port
    $obj | add-member noteproperty Url "http://${ip}:$port"
	$obj | add-member noteproperty ServiceName ($serviceName -split '_')[1]

    write-output $obj

}