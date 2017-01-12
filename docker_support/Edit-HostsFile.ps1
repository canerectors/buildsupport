$services = .\docker_support\Get-Services.ps1

Write-Output $services


$hostsPath = "$env:windir\System32\drivers\etc\hosts"

$hosts = get-content $hostsPath

#remove existing entries
$hosts = $hosts | Foreach { 
    $hostLine = $_
    $addEntry = $false

    Write-Host $hostLine

    $services | Foreach{
    
            $serviceName = $_.Name
    
            if (!($hostLine -split '\s+' -contains ("#" + $serviceName))) { $addEntry = $true }
    
        }

        if($addEntry){$hostLine}
    }

#append docker services to hosts file
$services | Foreach { $hosts += $_.IPAddress + "`t" + $_.ServiceName  + "`t`t#" + $_.Name}

$hosts | Out-File $hostsPath -enc ascii