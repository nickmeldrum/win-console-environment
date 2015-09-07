function Start-ProcessIfNotRunning {
    param (
        $processName,
        $path
    )
    $process = Get-Process $processName -ErrorAction SilentlyContinue
    if($process -eq $null) {
        Start-Process -FilePath $path -WindowStyle Hidden
        Get-Process $processName | Format-Table
        echo $process
    }
    else {
        $process | Format-Table
        Write-Host "Process $processName already started"
    }
}

function Stop-ProcessIfStarted {
    param (
        $processName
    )

    $process = Get-Process $processName -ErrorAction SilentlyContinue
    if ($process -eq $null) {
        Write-Host "Process $processName already stopped"
    }
    else {
        Stop-Process -processname $process.Name -ErrorAction SilentlyContinue
        Wait-Process $process.id -ErrorAction:silentlycontinue
        Write-Host "Process $process.Name stopped"
    }
}

function Create-DummyFile {
    param (
        $fileName,
        $size
    )
    $file = [io.file]::Create($fileName)
    $file.SetLength($size) 
    $file.Close() 
}

function Get-PathVariable {
    $path = (gci env: | where name -eq path | select value).value
    $path.split(';') | sort
}

Set-Alias path Get-PathVariable

function Echo-SystemCommands {
    Write-Title "System Commands:"

    Write-Host "gsv | where {`$_.name -like 'x*'}   | get services with a name like x..."
    Write-Host "gsv | where {`$_.name -like 'x*'} | Stop-Service | stop all them services"
    Write-Host "Start-ProcessIfNotRunning x y           | starts a process with name x and path y if it isn't already running"
    Write-Host "Stop-ProcessIfStarted x y               | stops a process with name x if it is running"
    Write-Host "Create-DummyFile x y                    | create a dummy file with name x and size y (e.g. 1mb 100mb 1gb etc.)"
    Write-Host "path (Get-PathVariable) | get nice sorted formatted list of paths"
}

