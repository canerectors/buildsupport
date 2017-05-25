docker pull portainer/portainer:windows-amd64-1.13.0

$ip=(Get-NetIPAddress -AddressFamily IPv4 | Where-Object -FilterScript { $_.InterfaceAlias -Eq "vEthernet (HNS Internal NIC)" }).IPAddress

$dockerHost = "tcp://" + $ip + ":2375"

docker run -d --name portainer portainer/portainer:windows-amd64-1.13.0 -H $dockerHost --no-auth >$null 2>&1
docker start portainer >$null 2>&1

$service = Invoke-Expression "$PSScriptRoot\Get-Services.ps1 portainer"

$url = "http://portainer:$($service.Port)"

start $url