if(-not $env:ChocolateyInstall | Test-Path )
{
    Write-Debug Installing Chocolatey...
    iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
}
else
{
    Write-Debug 'Chocolatey Already Installed.'
}

choco install -y docker
choco install -y docker-compose