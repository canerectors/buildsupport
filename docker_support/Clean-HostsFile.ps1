$services = & $PSScriptRoot\View-Details.ps1

$hostsPath = "$env:windir\System32\drivers\etc\hosts"

$hosts = get-content $hostsPath

Write-Host Removing old entries from host file...

$count = 0

#remove existing entries
$hosts = $hosts | Foreach { 
    $hostLine = $_
    $addEntry = $true

    $services | Foreach{
    
        $serviceName = $_.Name

        if ($hostLine -split '\s+' -contains ("#" + $serviceName)) { $addEntry = $false; $count++ }
    
    }

    if($addEntry){$hostLine}
}

Write-Host "Removed $count entries."

$hosts | Out-File $hostsPath -enc ascii