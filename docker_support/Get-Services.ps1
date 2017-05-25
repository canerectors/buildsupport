$services = $null

if($args[0]){
	if($args[0] -eq 'all'){
		$services = docker inspect $(docker ps -q) | ConvertFrom-Json
	}else{
		$services = (Invoke-Expression "docker inspect $($args[0])" | ConvertFrom-Json)[0]
	}
}
else {
	$services = docker inspect $(docker-compose ps -q) | ConvertFrom-Json
}

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

    $ip = $service.NetworkSettings.Networks.nat.IPAddress

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