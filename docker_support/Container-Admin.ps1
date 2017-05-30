$projectName = $args[0]

function Display-SubMenu{
    $done = $false

    $displayMenu = $true

    $serviceName = $args[0]

    Write-Host $serviceName

    while(-not $done)
    {     
        if($displayMenu)    
	    {
            $service = Invoke-Expression "$PSScriptRoot\Get-Services.ps1 $serviceName"

            $commands = @()

            $color = 'DarkGreen'

            if($service.Status -ne "running"){
                $color = "DarkYellow"
            }

            Write-Host
            Write-Host "Container $($service.ServiceName)"
            Write-Host
            Write-Host "Status: $($service.Status)" -ForegroundColor $color
            Write-Host

            $commands += "docker-compose -p $projectName logs $($service.ServiceName)"
            Write-Host "$($commands.Length)) View Logs"

            if($service.Status -eq "running") {
                $commands += "docker exec -it $($service.Name) powershell"
                Write-Host "$($commands.Length)) Open Command Prompt"
            }

            if($service.Url){
                $commands += "start $($service.Url)"
                Write-Host "$($commands.Length)) Launch"
            }

            if($service.Status -eq "running") {
                $commands += "docker stop $($service.Name)"
                Write-Host "$($commands.Length)) Pause"                
            }
            else {
                $commands += "docker start $($service.Name)"
                Write-Host "$($commands.Length)) Resume"
            }            

            Write-Host 

            if($service.Status -eq "running") {
                $commands += "docker stop $($service.Name); docker start $($service.Name)"
                Write-Host "$($commands.Length)) Restart"
                Write-Host
            }            

            $commands += "docker rm -f $($service.Name); docker-compose -p $projectName up --no-deps -d $($service.ServiceName)"
            Write-Host "$($commands.Length)) Recreate (Deletes and recreates container. All data is erased.)"

            $commands += "`$done = `$true; docker rm -f $($service.Name)"
            Write-Host "$($commands.Length)) Remove"
            
            Write-Host
            Write-Host -NoNewline "What would you like to do? (hit enter to exit)"
            Write-Host
        }

        $displayMenu = $true

        $Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")    

        [int]$returnedInt = 0

        if( [int]::TryParse($Action.Character.ToString(), [ref]$returnedInt) -and $returnedInt -le $commands.Length -and $returnedInt -gt 0) {
            Invoke-Expression $($commands[$returnedInt - 1])
        }
        else {
            $done = $Action.Character -eq 13          
        }  
    }
}

function Display-Menu{

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
	    
            $index = 49

            $services = @(Invoke-Expression "$PSScriptRoot\Get-Services.ps1 `$(docker-compose -p $projectName ps -q)")

			if($services.Length -eq 1){
				Display-SubMenu $($services[0]).Name
				$done = $true
				continue
			}
			
		    foreach($service in $services){
                
                $color = 'DarkGreen'

                if($service.Status -ne "running"){
                    $color = "DarkYellow"
                }

                Write-Host "$([char]$index)) $($service.ServiceName)" -ForegroundColor $color
                        
                $index++
                
                if($index -eq 58){
                    $index = 65
                }
            }

            if(!$services) { Write-Host "No services running." }        
	   	
            Write-Host
            Write-Host -NoNewline "What would you like to do? (hit enter to exit)"
            Write-Host
        }

        $displayMenu = $true

        $Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")    

        $char = $Action.Character - 48

        if($char -gt 9){
            $char = $char - 39
        }

        if($char -le $services.Length -and $char -gt 0){
            Display-SubMenu $($services[$char - 1]).Name
        }
        else {
            $done = $Action.Character -eq 13
        }  
    }
}

Display-Menu