$done = $false

$projectName = (Get-ChildItem *.sln).Name -replace ".sln", ""

$displayMenu = $true

while(-not $done)
{     
    if($displayMenu)
    {
        Write-Host "`nProject: $projectName`n"

        Write-Host "Select An Action:`n"
        Write-Host "1) Run Development Environment Docker Containers"
        Write-Host "2) Pause Docker Containers"
        Write-Host "3) Remove Docker Containers (This will destroy all data located inside the containers)" -ForegroundColor Red
        Write-Host "4) View Container Urls"
	    Write-Host "5) View Container Status"
        Write-Host "6) Launch Containers"
	    Write-Host "7) Docker Zap" -ForegroundColor Red
        #Write-Host "7) Restart Explorer"

        Write-Host
        Write-Host -NoNewline "What would you like to do (hit enter to exit)? "
    }

    $displayMenu = $true

    $Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")    

    switch ($Action.Character.ToString()) 
    { 
        1 {& .\docker_support\setup.ps1 } 
        2 {& docker-compose stop } 
        3 {& docker-compose down } 
        4 {& .\docker_support\Get-Services.ps1 | Format-Table Name, Url, IPAddress }
		5 {& docker-compose ps }
        6 {& .\docker_support\launch.ps1 }
		7 {& net stop docker; .\docker_support\docker_zap\docker-ci-zap -folder C:\ProgramData\Docker }
		#7 {& .\docker_support\launch-consolelogger.ps1 } 
        #7 {& cmd.exe /c "taskkill /IM explorer.exe /F"; & cmd.exe /c "explorer.exe"}  
        default
        {
            $done = $Action.Character -eq 13
            $displayMenu = $false
        }
    }
}