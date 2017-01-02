$done = $false

while(-not $done)
     {
     
     
    Write-Host "`nSelect An Action:`n"
    Write-Host "1) Run Docker"
    Write-Host "2) Stop Docker"
    Write-Host "3) Remove Docker"
    Write-Host "4) View Status"
    Write-Host "5) Launch Containers"
    Write-Host "6) Restart Explorer"

    Write-Host
    Write-Host "What would you like to do (hit enter to exit)?"

    $Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")    

    switch ($Action.Character.ToString()) 
    { 
        1 {& .\docker_support\setup.ps1 } 
        2 {& docker-compose stop } 
        3 {& docker-compose down } 
        4 {& .\docker_support\status.ps1 }
        5 {& .\docker_support\launch.ps1 } 
        6 {& cmd.exe /c "taskkill /IM explorer.exe /F"; & cmd.exe /c "explorer.exe"}  
        default {$done = $true}
    }
}