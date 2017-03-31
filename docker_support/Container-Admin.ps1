$done = $false

$displayMenu = $true

while(-not $done)
{     
    if($displayMenu)    
	{

        $commands = @()

        Write-Host
        Write-Host "Container Administration"
        Write-Host
	    
        $index = 1
		foreach($service in .\Get-Services.ps1){
        
            $commands += "docker rm -f $($service.Name)"
            Write-Host "$index) Kill $($service.ServiceName)"
            $index++
        }
	   	
        Write-Host
        Write-Host -NoNewline "What would you like to do? (hit enter to exit)"
        Write-Host
    }

    $displayMenu = $true

    $Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")    

    [int]$returnedInt = 0

    if( [int]::TryParse($Action.Character.ToString(), [ref]$returnedInt) -and $returnedInt -le $commands.Length -and $returnedInt -gt 0) {
        Invoke-Expression $($commands[$returnedInt - 1]) | Out-Null
    }
    else {
        $done = $Action.Character -eq 13
        $displayMenu = $false
    }  
}