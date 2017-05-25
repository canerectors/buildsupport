function Remove-All{
    $services = $args[0]

    if($services.Length -le 0){ return; }

    $hostsPath = "$env:windir\System32\drivers\etc\hosts"

    $hosts = (get-content $hostsPath).Trim();

    #Write-Host Removing old entries from host file...
    #Write-Host

    $count = 0

    #remove existing entries
    $hosts = $hosts | Foreach { 
        $hostLine = $_
        $addEntry = $true

        $lineTokens = $hostLine -split '\s+'

        $services | Foreach{
    
            $serviceName = $_.Name
       
            if($lineTokens -notcontains '#docker_service:'){ $addEntry = $true; }

            elseif ($hostLine -match "#docker_service: $serviceName\b") { $addEntry = $false; }    
        }

        if(-not $addEntry){$count++}

        if($addEntry){$hostLine}
    }


    #Write-Host "Removed $count entries."
    #Write-Host

    if($count -gt 0){
        $hosts | Out-File $hostsPath -enc ascii
    }
}

function Remove-Except{
    $services = $args[0]

    if($services.Length -le 0){ return; }

    $hostsPath = "$env:windir\System32\drivers\etc\hosts"

    $hosts = (get-content $hostsPath).Trim();

    #Write-Host Removing old entries from host file...
    #Write-Host

    $count = 0

    #remove existing entries
    $hosts = $hosts | Foreach { 
        $hostLine = $_
        $addEntry = $false

        $lineTokens = $hostLine -split '\s+'

        $services | Foreach{
    
            $serviceName = $_.Name
       
            if($lineTokens -notcontains '#docker_service:'){ $addEntry = $true; }

            elseif ($hostLine -match "#docker_service: $serviceName\b") { $addEntry = $true; }    
        }

        if(-not $addEntry){$count++}

        if($addEntry){$hostLine}
    }

    #Write-Host "Removed $count entries."
    #Write-Host

    if($count -gt 0){
        $hosts | Out-File $hostsPath -enc ascii
    }

}

if($args[0]){

    Remove-All($args[0])
}
else{
    $services = Invoke-Expression "$PSScriptRoot\Get-Services.ps1 all"
    Remove-Except($services)
}