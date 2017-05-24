$services = @($args[0])

if($services.Length -le 0){ return; }

$hostsPath = "$env:windir\System32\drivers\etc\hosts"

$hosts = get-content $hostsPath

Write-Host
Write-Host Removing old entries from host file...
Write-Host

$count = 0

#remove existing entries
$hosts = $hosts | Foreach { 
    $hostLine = $_
    $addEntry = $true

    $services | Foreach{
    
        $serviceName = $_.Name

        if ($hostLine -split '\s+' -contains ("#" + $serviceName)) { $addEntry = $false; $count++; Write-Host Removed Service: $serviceName }
    
    }

    if($addEntry){$hostLine}
}

Write-Host
Write-Host "Removed $count entries."
Write-Host

$hosts | Out-File $hostsPath -enc ascii