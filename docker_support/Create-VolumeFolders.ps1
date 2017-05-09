function Space-Difference($str1, $str2){

    $numSpaces1 = 0
    $numSpaces2 = 0

    if($str1 -and ($str1.StartsWith(" "))){
        $numSpaces1 = ([regex]::Match($str1,'(\s+)')).Length
    }
     
    if($str2 -and ($str2.StartsWith(" "))){
        $numSpaces2 = ([regex]::Match($str2,'(\s+)')).Length
    }

    if(($numSpaces1 - $numSpaces2) -lt 0){
        return -1;
    }
    if(($numSpaces1 - $numSpaces2) -gt 0){
        return 1;
    }

    return 0;
}

$lines = Get-Content docker-compose.yml

if(Test-Path('docker-compose.override.yml')){
	$lines += Get-Content docker-compose.override.yml
}

$parentLevel = 0
$previousLine = $null

$currentParent = $null
$currentLevel = 0

$stack = New-Object System.Collections.Generic.Stack[System.Object]

foreach($line in $lines){

    #Write-Host Previous: $previousLine
    #Write-Host Current: $line

    if([string]::IsNullOrWhiteSpace($line)){
        #Write-Host Skipping white space
        continue;
    }
    
    #skip comments
    if($line.Trim().StartsWith('#')){
        #Write-Host skipping comment
        continue;
    }

    $newLevel = $currentLevel + $(Space-Difference $line $previousLine)

    #Write-Host NewLevel: $newLevel

    if($newLevel -gt $currentLevel){        
        $stack.Push($previousLine) | Out-Null
    } elseif($newLevel -lt $currentLevel){     
        $stack.Pop() | Out-Null
    } 

    $currentLevel = $newLevel

    if($stack.Count -gt 0){
        $currentParent = $stack.Peek()
    }

    #Write-Host CurrentParent: $currentParent
    #Write-Host CurrentLevel: $currentLevel

    if($currentParent -and $currentParent.Trim().StartsWith('volumes:') -and $line -like '*Docker_Volumes*'){
                       
        $volumePath = $line.Trim('- ')
        $toRemove = $volumePath.Substring($volumePath.IndexOf(":", 3))

        $volumePath = $volumePath.Replace($toRemove, "")

        if(!(Test-Path($volumePath))){
            Write-Host Creating $volumePath

            md $volumePath -Force | Out-Null
        }
    }

    $previousLine = $line
}