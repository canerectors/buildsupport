$dockerd = 'C:\ProgramData\chocolatey\lib\docker\tools\docker\dockerd.exe'

if(-not (Test-Path $dockerd)){
    $restartRequired = (Enable-WindowsOptionalFeature -Online -FeatureName containers -All).RestartNeeded -or (Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All).RestartNeeded

    if($restartRequired)
    {
        #Restart-Computer -Force
    }

    choco install -y docker -pre
    
    & $dockerd --register-service

    Start-Service Docker
	
	choco install -y docker-compose
}