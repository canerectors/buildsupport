$scriptsFolder = $args[0]

if(!$scriptsFolder){
    $scriptsFolder = '.\docker_support'
}

$done = $false

$projectName = (Get-ChildItem *.sln).Name -replace ".sln", ""

$displayMenu = $true

$menu = @"
[
    {
        Text : "Run Development Environment Docker Containers",
        Command : "$PSScriptRoot\setup.ps1"
    },
    {
        Text : "Pull New Images",
        Command : "docker-compose pull; $PSScriptRoot\images_remove_dangling.ps1"
    },
    {
        Text : "Container Admin",
        Command : "$PSScriptRoot\Container-Admin.ps1"
    },
    {
        Text : "Launch Containers",
        Command : "$PSScriptRoot\launch.ps1"
    },
    {
        Text : "View Container Urls",
        Command : "$PSScriptRoot\Get-Services.ps1 | Format-Table Name, Url, IPAddress"
    },
    {
        Text : "View Container Status",
        Command : "docker-compose ps"
    },
    {
        Text : "Pause Containers",
        Command : "docker-compose stop"
    },
    {
        Text : "View Logs",
        Command : "start \"docker-compose\" \"logs -f\""
    },
    {
        Text : "Remove Docker Containers (This will destroy all data located inside the containers)",
        Command : "docker-compose down",
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

        $index = 1
		ForEach($item in $menu){        

            if($item.Skip -eq "true"){
                Write-Host; 
            }

            $color = 'White'

            if($item.Color){
                $color = $item.Color
            }
            
            Write-Host "$index) $($item.Text)" -ForegroundColor $color
            $index++
                        
        }

        Write-Host
        Write-Host -NoNewline "What would you like to do (hit enter to exit)? "
    }

    $displayMenu = $true

    $Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")    

    [int]$returnedInt = 0

    if( [int]::TryParse($Action.Character.ToString(), [ref]$returnedInt) -and $returnedInt -le $menu.Count -and $returnedInt -gt 0) {
        Write-Host
        Invoke-Expression $($menu[$returnedInt - 1]).Command | Out-Null
    }
    else {
        $done = $Action.Character -eq 13
        $displayMenu = $false
    }  
}