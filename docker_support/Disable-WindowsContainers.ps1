$dockerd = 'C:\ProgramData\chocolatey\lib\docker\tools\docker\dockerd.exe'

if($dockerd | Test-Path){    

    Stop-Service Docker

    & $dockerd --unregister-service

    choco uninstall -y docker -pre    
}