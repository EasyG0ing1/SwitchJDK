$action = $args[0]
$option = $args[1]

# Any path that is currently in your Path environment will be removed if any of them match the patterns in jdkIDArry.
# This is to ensure that no jdk paths exist before adding the new path that you choose. You can alter how the current path is cleared before
# adding in your new choice by changing these pattern strings, or adding new ones. To add new ones, simply follow the format that is in the
# final ( ) at the end of the next line. Whichever characters you need to match, surround them in quotes and asterisks with each new 
# matching string separated by commas so that the script can build a proper exclusion list when it builds the new Path environment variable.

$jdkIDArry = [System.Collections.ArrayList]@("*jdk*","*java*")

if ($action -eq $null) {
    $action = "list"
}

$sourceFilePath = $MyInvocation.MyCommand.Path
$me = [System.Io.Path]::GetFileNameWithoutExtension($sourceFilePath)

if ($action -like '`?') {
    $message = "`nIf you would like to make this script simply work from anywhere, then execute it with the init option:`n`n"
    $message += "`t$me init`n`n"
    $message += "and it will create a folder inisde of your Home folder called Scripts (if it does not already exist) and will copy itself over to that folder and add that folder your environment Path variable.`n`n"
    $message += "*** CORE USAGE **`n`n"
    $message += "The path that is relevant to this script, is the JDK path that contains the bin folder. So if, for example, you have a JDK installed and the path to the bin folder is here:`n`n"
    $message += "`tC:\Program Files\MyJDK\bin`n`nThen the path that you add will be: `n`n`tC:\Program Files\MyJDK`n`n"
    $message += "These are the options you will use the most (you must include the quote marks if your path has a space in it):`n`n"
    $message +="`t* Add:`t$me add `"C:\Program Files\MyJDK`"`n"
    $message += "`t* Del:`t$me del 2 <- number from the list`n"
    $message += "`t* List:`t$me`n`n"
    $message += "Running the script without any arguments will present a list with a number next to each JDK that you have added.`n`n"
    $message += "To switch between JDKs, use the number from the list:`n"
    $message += "`t$me 2`n`n"
    $message += "This will change the proper environment variables and will then run java -version so you can be sure that your environment is set up as desired.`n`nI hope this script is useful to you  :-)"

    echo $message | more
    exit
}

if ($action -like 'init') {
    $userHome = [Environment]::GetEnvironmentVariable("USERPROFILE")
    $scriptPath = $userHome + "\Scripts"
    $scriptPathExists = Test-Path -Path $scriptPath -PathType Container
    if (!$scriptPathExists) {
        New-Item -Path $scriptPath -ItemType Directory
    }
    $scriptFileName = Split-Path $sourceFilePath -Leaf
    $destinationFilePath = $scriptPath + "\" + $scriptFileName
    Copy-Item $sourceFilePath $destinationFilePath
    $newEnvPath = $destinationFilePath + ";" + [Environment]::GetEnvironmentVariable("Path")
    [Environment]::SetEnvironmentVariable("Path",$newEnvPath)
    Write-Host "This script has been copied into the Scripts folder in your Home directory and added to the Path environment variable.`nYou may delete the script from this location then simply use it from anywhere."
    exit
}

if ((($action -like 'add') -or ($action -like 'del')) -and ($option -eq $null)) {
    if ($action -like 'add') {
        Write-Host "`nYou must include the path that you would like to add."
    }

    if ($action -like 'del') {
        Write-Host "`nYou must include the number of the path you wish to delete. Run the script without any arguements to get a list."
    }
    exit
}

$appDataPath= [Environment]::GetEnvironmentVariable("APPDATA") + "\$me"
$appDataPathExists = Test-Path -Path $appDataPath -PathType Container
$filePath = $appDataPath+ "\paths.txt"
$fileExists = Test-Path -Path $filePath -PathType Leaf

if (!$appDataPathExists) {
    New-Item -Path $appDataPath -ItemType Directory
}

if (!$fileExists) {
    New-Item -Path $filePath -ItemType File
}

$jdkPaths = [System.Collections.ArrayList]@(Get-Content $filePath)

switch ($action) {
    "add" {
        if(!(Test-Path -Path $option -PathType Container)) {
            Write-Host "`nThe jdk Path that you specified $option does not exist - Nothing to do."
            exit
        }
        $jdkPaths += $option
        $jdkPaths | Out-File -FilePath $filePath
        Write-Host "`nThe JDK Path $option has been added to the list. Run this script without any arguments to see the final list ... $me <enter>"
        exit
    }

    "del" {
        if (($jdkPaths -eq $null) -or ($jdkPaths.Count -eq 0)) {
            Write-Host "`nNo JDK paths have been added to the list. Use $me add <jdk path> to add a path. See $me ? for more information."
            exit
        }
        if (!($option -match "^\d+$")) {
            Write-Host "`nYou must include the number of the path that you wish to delete. run $me ? to see an example."
            exit
        }
        [Int32]$pathIndex = $option
        if (($pathIndex -lt 0) -or ($pathIndex -ge $jdkPaths.Count)) {
            Write-Host "The path number you specified is outside the range of path options in the list. Run the script without any arguments to see a list of valid numbers: $me <enter>"
            exit
        }
        $chosenPath = $jdkPaths[$pathIndex]
        $jdkPathSwitchs = $jdkPaths | Where-Object {$_ -ne $chosenPath}
        $jdkPathSwitchs | Out-File -FilePath $filePath
        Write-Host "The path $chosenPath has been removed from the list. Verify by running script without arguments: $me <enter>"
        exit
    }

    "list" {
        if (($jdkPaths -eq $null) -or ($jdkPaths.Count -eq 0)) {
            Write-Host "`nNo JDK paths have been added to the list. Use $me add <jdk path> to add a path. See $me ? for more information."
            exit
        }
        [Int32]$index = 0;
        $finalList = "";
        foreach ($p in $jdkPaths){
        $indexString 
            $finalList += [string]$index + " - " + $p + "`n"
            $index++
        }
        Write-Host "`n$finalList"
        exit
    }

    default {
        $isInt = [bool]($action -as [Int32])
        $isZero = $action -like '0'
        if (!$isInt -and !$isZero) {
            Write-Host "No valid arguments passed into script. Nothing to do, exiting..."
            exit
        }
        [Int32]$pathIndex = $action
        if (($pathIndex -lt 0) -or ($pathIndex -ge $jdkPaths.Count)) {
            Write-Host "The path number you specified is outside the range of path options in the list. Run the script without any arguments to see a list of valid numbers: $me <enter>"
            exit
        }
        $jdkPathSwitch = $jdkPaths[$pathIndex]
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPathSwitch)
        $oldEnvPathArry = $env:Path.Split(';')
        $excludePaths = [System.Collections.ArrayList]@()
        foreach ($id in $jdkIDArry) {
            foreach($path in $oldEnvPathArry){
                if (($path -like $id) -and ($excludePaths -notcontains $path)) {
                    $excludePaths += $path
                }
            }
        }
        $newEnvPathArry = [System.Collections.ArrayList]@()
        $newEnvPathArry += $jdkPathSwitch +"\bin;"
        foreach($path in $oldEnvPathArry){
            if(($excludePaths -notcontains $path) -and ($newEnvPathArry -notcontains $path)) {
                $newEnvPathArry += $path
            }
        }
        $finalPath = ""
        foreach ($newPath in $newEnvPathArry) {
            $finalPath += $newPath + ";"
        }
        [Environment]::SetEnvironmentVariable("Path", $finalPath)
        java -version
        echo " "
    }
}
