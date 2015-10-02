param ([string]$installRootDir = "d:\")

$consoleDir = "C:\Program Files\ConEmu"
$consolePath = "$consoleDir\ConEmu64.exe"
$envDir = "$installRootDir\env"

function recreate-shortcut-and-pin-it {
    param ([string]$Source, [string]$Arguments, [string]$WorkingDir, [string]$IconPath, [string]$Destination, [string]$Hotkey, [string]$Description)

    if (test-path($Destination)) {del $Destination -force}

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($Destination)
    $Shortcut.TargetPath = $Source
    $Shortcut.Arguments = $Arguments
    $Shortcut.WorkingDirectory = $WorkingDir
    $Shortcut.IconLocation = $IconPath
    $Shortcut.WindowStyle = 3
    $Shortcut.Hotkey = $Hotkey
    $Shortcut.Description = $Description
    $Shortcut.Save()

    $destinationFilename = [System.IO.Path]::GetFileName($Destination)
    $destinationPath = [System.IO.Path]::GetDirectoryName($Destination)

    $shell = new-object -com "Shell.Application"  
    $folder = $shell.Namespace($destinationPath)    
    $item = $folder.Parsename($destinationFilename)

    $pn = $shell.namespace($destinationPath).parsename($destinationFilename)
    $pn.invokeverb('taskbarunpin')
    $pn.invokeverb('taskbarpin')
}

recreate-shortcut-and-pin-it -Source $consolePath -Arguments "/cmd {vim}" `
                -WorkingDir $consoleDir -IconPath "$envDir\vim.ico" `
                -Destination "$envDir\vim.lnk" -Hotkey "CTRL+ALT+V" -Description "Vim in conemu"

recreate-shortcut-and-pin-it -Source $consolePath -Arguments "/cmd {cmd}" `
                -WorkingDir $consoleDir -IconPath "$envDir\cmd.ico" `
                -Destination "$envDir\cmd.lnk" -Hotkey "CTRL+ALT+C" -Description "Powershell in conemu"

recreate-shortcut-and-pin-it -Source $consolePath -Arguments "/cmd {scribestar}" `
                -WorkingDir $consoleDir -IconPath "$envDir\scribestar.ico" `
                -Destination "$envDir\scribestar.lnk" -Hotkey "CTRL+ALT+S" -Description "Scribestar env in conemu"

recreate-shortcut-and-pin-it -Source $consolePath -Arguments "/cmd {npmapp}" `
                -WorkingDir "$installRootDir\nickmeldrum" -IconPath "$envDir\npm.ico" `
                -Destination "$envDir\npm.lnk" -Hotkey "CTRL+ALT+N" -Description "npm env in conemu"

