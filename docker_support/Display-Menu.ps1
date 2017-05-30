Start-Process powershell -ArgumentList "-noexit -noprofile $PSScriptRoot\MonitorDockerEvents.ps1" -WindowStyle Hidden

if(Test-Path './Project.ps1'){
    . ./Project.ps1
}

if(!$ProjectName){
    $projectName = (get-item $pwd).Name.Replace(".", "").ToLower()
}

$done = $false

$displayMenu = $true

$menu = @"
[
    {
        Text : "Start Containers",
        Command : "$PSScriptRoot\Run-Containers.ps1 $projectName"
    },
    {
        Text : "Pull New Images",
        Command : "docker-compose pull"
    },
    {
        Text : "Launch Portainer",
        Command : "$PSScriptRoot\Launch-Portainer.ps1"
    },
    {
        Text : "Container Admin",
        Command : "$PSScriptRoot\Container-Admin.ps1 $projectName"
    },
    {
        Text : "View Container Details",
        Command : "$PSScriptRoot\Get-Services.ps1 `$(docker-compose -p $projectName ps -q) | Format-Table Name, Url, IPAddress, Status"
    },
    {
        Text : "View Container Stats",
        Command :  "start \"docker\" \" stats `$(docker ps --format '{{.Names}}')\""
    },
    {
        Text : "Launch Containers",
        Command : "$PSScriptRoot\Launch-Containers.ps1 $projectName"
    },
    {
        Text : "Stop Containers",
        Command : "docker-compose -p $projectName stop"
    },
    {
        Text : "View Logs",
        Command : "start \"docker-compose\" \"-p $projectName logs -f\""
    },
    {
        Text : "Remove Docker Containers (This will destroy all data located inside the containers)",
        Command : "docker-compose -p $projectName down --remove-orphans",
        Skip : "true",
        Color : "Red"
    } 
]
"@.Replace("\", "\\").Replace('\\"', '\"') | ConvertFrom-Json

while(-not $done)
{     
    if($displayMenu)
    {
        Write-Host "`nProject: $projectName`n"

        Write-Host "Select An Action:`n"

        $index = 49

		ForEach($item in $menu){        

            if($item.Skip -eq "true"){
                Write-Host; 
            }

            $color = 'White'

            if($item.Color){
                $color = $item.Color
            }
            
            Write-Host "$([char]$index)) $($item.Text)" -ForegroundColor $color

            $index++
                        
            if($index -eq 58){
                $index = 65
            }
        }

        Write-Host
        Write-Host -NoNewline "What would you like to do (hit enter to exit)? "
    }

    $displayMenu = $true

    $Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")    

    $char = $Action.Character - 48

    if($char -gt 9){
        $char = $char - 39
    }

    if($char -le $menu.Length -and $char -gt 0){
        Write-Host
        Invoke-Expression $($menu[$char - 1]).Command
    }
    else {
        $done = $Action.Character -eq 13
    }   

    if($done){
        Write-Host Cleaning up... -NoNewline
        & $PSScriptRoot\Clean-HostsFile.ps1
        & docker volume prune -f
        & $PSScriptRoot\images_remove_dangling.ps1 >$null 2>&1
        Write-Host Done.
    }
}