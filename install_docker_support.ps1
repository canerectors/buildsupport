function Get-Script {
    $scriptName = $args[0] + '.ps1'
    iwr "https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/$scriptName" -UseBasicParsing -OutFile ".\docker_support\$scriptName"
}

Write-Host "Installing Docker Support files to: $(Get-Location)\docker_support..."

md .\docker_support *> $null

Get-Script Disable-WindowsContainers
Get-Script Enable-WindowsContainers
Get-Script install_dependencies
Get-Script docker_commands
Get-Script setup
Get-Script launch
Get-Script Edit-HostsFile
Get-Script Get-Services