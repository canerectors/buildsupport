$services = .\docker_support\Get-Service-Urls.ps1

Write-Host

$services | % { $line = $_ -split ' '; Write-Host $line[0] is available at: $line[1] `n }