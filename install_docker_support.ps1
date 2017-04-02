function Download-File {
    $scriptName = $args[0]
	$destination = "$($args[1])\$scriptName"

    iwr "https://raw.githubusercontent.com/canerectors/buildsupport/master/docker_support/$scriptName" -UseBasicParsing -OutFile "$destination"
}

$dockerSupportFolder = $args[0]

if(!$dockerSupportFolder){
	$dockerSupportFolder = '.\docker_support'
}

md $dockerSupportFolder *> $null

pushd $dockerSupportFolder

Write-Host "Installing Docker Support files to: $(Get-Location)"

$scripts =  "Display-Menu",
            "setup",
            "Launch-Containers",
            "Edit-HostsFile",
			"Clean-HostsFile",
            "Get-Services",
            "images_remove_dangling",
			"Container-Admin"

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