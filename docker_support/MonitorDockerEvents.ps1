$process = New-Object System.Diagnostics.Process
 $proInfo = New-Object System.Diagnostics.ProcessStartInfo
 $proInfo.CreateNoWindow = $false
 $proInfo.RedirectStandardOutput = $true
 $proInfo.RedirectStandardError = $true
 $proInfo.UseShellExecute = $false
 $proInfo.FileName = 'docker'
 $proInfo.Arguments = 'events --filter type=container --format ' + "`"{{json .}}`""

$process.StartInfo = $proInfo

Write-Host "Begin" -foregroundcolor DarkGreen

Register-ObjectEvent -InputObject $process -EventName ErrorDataReceived -action {
   if(-not [string]::IsNullOrEmpty($EventArgs.data))
   {
    Write-Host "Logging ERROR: $($EventArgs.data)" -ForegroundColor Red
  #Add-Content "ERROR: $($EventArgs.data)" -Path $ServerPrepAutoLog
   }
}

#Write-Host "Setup Register-ObjectEvent to Log Errors" -foregroundcolor DarkGreen

#Register an Action for Standard Output Data Received Event
Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -action {
 if(-not [string]::IsNullOrEmpty($EventArgs.data))
   {
  
  #Write-Host "Logging: $($EventArgs.data)" -ForegroundColor Blue
     $dockerEvent = $($EventArgs.data) | ConvertFrom-Json

    #Write-Host $dockerEvent

    $eventType = $dockerEvent.status
    
    switch($eventType){
        'start' {
            $service = Invoke-Expression "$PSScriptRoot\Get-Services.ps1 $dockerEvent.id"

            Write-Host Starting container $service.Name

            & .\docker_support\Edit-HostsFile.ps1 $service
        }
        'kill' {
            #$service = .\docker_support\Get-Services.ps1 $dockerEvent.id

            #Write-Host Stopping container $service.Name

            #& .\docker_support\Clean-HostsFile.ps1 $service
        }
    }

  }

}

$pidFileName = "$PSScriptRoot\monitor.pid"

if(Test-Path $pidFileName){

    $monitorPid = Get-Content $pidFileName

    taskkill /F /T /PID $monitorPid | Out-Null
}

Write-Host "Setup Register-ObjectEvent to Log StdOut" -foregroundcolor DarkGreen
Write-Host "Starting Process..." -foregroundcolor DarkGreen

$process.Start()
$process.BeginOutputReadLine()
$process.BeginErrorReadLine()
#$process.WaitForExit()

$process.Id > $pidFileName