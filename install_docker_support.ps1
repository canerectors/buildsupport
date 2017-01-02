Write-Host Installing Docker Support files to: $(Get-Location)...

md .\docker_support

#install dependencies
iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/install_dependencies.ps1 -UseBasicParsing | iex

iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/docker_commands.ps1 -UseBasicParsing -OutFile .\docker_support\docker_commands.ps1
iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/status.ps1 -UseBasicParsing -OutFile .\docker_support\status.ps1