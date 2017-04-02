$services = docker inspect $(docker-compose ps -q) | ConvertFrom-Json

$preferredPorts = $(Get-Content $PSScriptRoot\PreferredPorts.txt)

if($preferredPorts){
    $preferredPorts = $preferredPorts.Split(',')
}

foreach($service in $services){

    $serviceName = $service.Name.Replace("/", "")

    $ports = $null

    if($service.NetworkSettings.Ports){
        $ports = ($service.NetworkSettings.Ports | Get-Member -MemberType NoteProperty).Name | ? {$_} | Foreach { $_.ToString().Replace("/tcp","") }
    }
		    
	$port = $null
    
    if($ports){
        foreach($p in $ports){
            if($preferredPorts.Contains($p)){
                $port = $p                
                break;
            }
        }
    }

    $ip = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $serviceName

    $obj = new-object psobject
    $obj | add-member noteproperty Name $serviceName
    $obj | add-member noteproperty IPAddress $ip
    $obj | add-member noteproperty Port $port

    if($port){
        $obj | add-member noteproperty Url "http://${serviceName}:$port"
    }

	$obj | add-member noteproperty ServiceName ($serviceName -split '_')[1]
    $obj | add-member noteproperty Status $service.State.Status
    $obj | add-member noteproperty Mounts $service.Mounts

    write-output $obj
}