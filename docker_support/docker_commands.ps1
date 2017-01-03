$done = $false

while(-not $done)
{     
    Write-Host "`nSelect An Action:`n"
    Write-Host "1) Run Development Environment Docker Containers"
    Write-Host "2) Pause Docker Containers"
    Write-Host "3) Remove Docker Containers"
    Write-Host "4) View Container IP Addresses"
	Write-Host "5) View Container Status"
    Write-Host "6) Launch Containers"
    Write-Host "7) Restart Explorer"

    Write-Host
    Write-Host "What would you like to do (hit enter to exit)?"

    $Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")    

    switch ($Action.Character.ToString()) 
    { 
        1 {& .\docker_support\setup.ps1 } 
        2 {& docker-compose stop } 
        3 {& docker-compose down } 
        4 {& .\docker_support\Get-IPAddresses.ps1 }
		5 {& docker-compose ps }
        6 {& .\docker_support\launch.ps1 } 
        7 {& cmd.exe /c "taskkill /IM explorer.exe /F"; & cmd.exe /c "explorer.exe"}  
        default {$done = $true}
    }
}