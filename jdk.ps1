clear
$p1 = $args[0]

$jdk1 = "C:\Program Files\Java\jdk1.8.0_291\bin"
$jdk2 = "C:\Program Files\OpenJDK\jdk-17.0.1\bin"

$jdks = [System.Collections.ArrayList]@()

$jdks += $jdk1
$jdks += $jdk2

$envpath = $env:Path.Split(';')

if ($p1 -like '*list*') {
    write-host '1 - 1.8.0_291'
    write-host '2 - 17.0.1'
    echo " "
    exit
}

$newPathArry = [System.Collections.ArrayList]@()

 switch ($p1) {
    "1" {
            $newPathArry += $jdks[0]
            [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdks[0])
        }
    "2" {
            $newPathArry += $jdks[1]
            [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdks[1])
        }
    default {exit}
 }

foreach ($e in $envpath) {
    if (($e -notlike '*jdk*') -and ($e -notlike '*java*')) {
        if ($newPathArry -notcontains $e) {
            $newPathArry += $e
        }
    }
 }

$finalPath = ""

foreach ($p in $newPathArry) {
    $finalPath += $p + ";"
}

[Environment]::SetEnvironmentVariable("Path", $finalPath)
java -version
