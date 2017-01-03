Write-Host "Installing Docker Support files to: $(Get-Location)\docker_support..."

#install dependencies
iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/install_dependencies.ps1 -UseBasicParsing | iex

md .\docker_support *> $null

iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/docker_commands.ps1 -UseBasicParsing -OutFile .\docker_support\docker_commands.ps1
iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/Get-IPAddresses.ps1 -UseBasicParsing -OutFile .\docker_support\Get-IPAddresses.ps1
iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/setup.ps1 -UseBasicParsing -OutFile .\docker_support\setup.ps1
iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/launch.ps1 -UseBasicParsing -OutFile .\docker_support\launch.ps1
iwr https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/Get-Service-Urls.ps1 -UseBasicParsing -OutFile .\docker_support\Get-Service-Urls.ps1