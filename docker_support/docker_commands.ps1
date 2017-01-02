Write-Host "`nSelect An Action:`n"
Write-Host "1) Run Docker"
Write-Host "2) Stop Docker"
Write-Host "3) Remove Docker"
Write-Host "4) View Status"
Write-Host "5) Launch Containers"

Write-Host

$Action = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

switch ($Action.Character.ToString()) 
{ 
    1 {& .\docker_support\setup.ps1} 
    2 {& .\docker_support\stop.ps1} 
    3 {& .\docker_support\down.ps1} 
    4 {& .\docker_support\status.ps1} 
    5 {& .\docker_support\launch.ps1}
}