$services = .\docker_support\Get-Services.ps1

$hostsPath = "$env:windir\System32\drivers\etc\hosts"

$hostsPathOrig = $hostsPath + ".orig"

#backup original hosts file
if(!(Test-Path ($hostsPathOrig))){ copy $hostsPath $hostsPathOrig }

$hosts = get-content $hostsPath

#remove existing entries
$hosts = $hosts | Foreach { 
    $hostLine = $_
    $addEntry = $true

    $services | Foreach{
    
            $serviceName = $_.Name

            if ($hostLine -split '\s+' -contains ("#" + $serviceName)) { $addEntry = $false }
    
        }

        if($addEntry){$hostLine}
    }

#append docker services to hosts file
$services | Foreach { $hosts += $_.IPAddress + "`t" + $_.Name  + "`t`t#" + $_.Name}

$hosts | Out-File $hostsPath -enc ascii