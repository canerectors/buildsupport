function Download-File {
    $scriptName = $args[0]
	$destination = "$($args[1])\$scriptName"

    iwr "https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/$scriptName" -UseBasicParsing -OutFile "$destination"
}

if(!$args[0]){
	$dockerSupportFolder = '.\docker_support'
}

$dockerSupportFolder = $args[0]

md $dockerSupportFolder *> $null

pushd $dockerSupportFolder

Write-Host "Installing Docker Support files to: $(Get-Location)"

$scripts =  "docker_commands",
            "setup",
            "Launch-Containers",
            "Edit-HostsFile",
			"Clean-HostsFile",
            "View-Details",
            "images_remove_dangling"

foreach($script in $scripts){
    Download-File "$script.ps1" .
}

Download-File PreferredPorts.txt .


popd


#$zapPath = '.\docker_support\docker_zap'


#if (-not (Test-Path $zapPath)) {
#	md $zapPath *> $null
#	iwr "https://github.com/canerectors/buildsupport/raw/master/docker_support/docker_zap/docker-ci-zap.exe" -UseBasicParsing -OutFile ".\docker_support\docker_zap\docker-ci-zap.exe"
#}