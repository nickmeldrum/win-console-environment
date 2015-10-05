param ([bool]$updatepackages = $false)

$ErrorActionPreference = "Stop"

function idempotent-chocolatey {
    param ([string]$packagename, [string]$params)

    if ($updatepackages) {
        write-host "updating $packagename..."

        if ([string]::isnullorwhitespace($params)) {
            choco upgrade $packagename -y
        }
        else {
            choco upgrade $packagename -y -params $params
        }
    }
    else {
        write-host "installing $packagename..."

        if ((choco list -lo $packagename | where {$_.contains($packagename)}).count -eq 0) {
            if ([string]::isnullorwhitespace($params)) {
                choco install $packagename -y
            }
            else {
                choco install $packagename -y -params $params
            }
        }
    }
}

function idempotent-gitupdate {
    param ([string]$repo, [string]$localpath)

    if (-not (test-path $localpath)) {
        write-host "getting $localpath repository..."
        git clone $repo $localpath
        cd $localpath
    }
    else {
        write-host "updating $localpath repository..."
        cd $localpath
        git pull
    }
}

function refresh-path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
}

# test for required installs before continuing
write-host "checking for pre-reqs: chocolatey and msbuild..."
where.exe choco
if ($lastexitcode -eq 1) {
    write-host "chocolatey not found, please install. Exiting..."
    return
}
where.exe msbuild
if ($lastexitcode -eq 1) {
    write-host "msbuild not found, please install. Exiting..."
    return
}

if ((new-object system.io.driveinfo("d:\")).drivetype -eq "Fixed") {
    $installRootDir = "d:\"
}
else {
    $installRootDir = "c:\work"
}

#local env
write-host "install root dir is $installRootDir..."

if (-not (test-path $installRootDir)) {
    $null = mkdir $installRootDir
}

#git
idempotent-chocolatey git '"/GitAndUnixToolsOnPath"'
refresh-path

# Install my fork of git credential store
cd $installRootDir
idempotent-gitupdate https://nickmeldrum@git01.codeplex.com/forks/nickmeldrum/gitcredentialstore gitcredentialstore
$null = msbuild
.\InstallLocalBuild.cmd

# Get my environment settings and files and set them up
cd $installRootDir
idempotent-gitupdate https://nickmeldrum@github.com/nickmeldrum/win-console-environment.git env
copy .gitconfig ~/.gitconfig -force
copy localconfig.json ~/localconfig.json -force

# python
idempotent-chocolatey "python2-x86_32"
refresh-path

# nodejs
idempotent-chocolatey nodejs
copy .npmrc ~/.npmrc -force

# autohotkey
idempotent-chocolatey autohotkey
copy autohotkey.ahk ~/Documents/autohotkey.ahk -force
refresh-path

# Setup autohotkey to run and always run on logon
if ((Get-Process autohotkey -ErrorAction SilentlyContinue) -eq $null) {
    autohotkey
}
if ((get-scheduledtask -taskname "autohotkey" -erroraction silentlycontinue) -ne $null) {
    unregister-scheduledtask -taskname "autohotkey" -confirm:$false
}
$action = New-ScheduledTaskAction -Execute "C:\Program Files\AutoHotkey\AutoHotkey.exe" -Id "autohotkey"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AutoHotkey"

# Setup powershell environment - profile/ posh git etc. not being picked up?
if (test-path $profile) {
	del $profile -force
}
new-item $profile -force -type file
copy copy-of-profile.ps1 $profile -force
cd 3rdparty
idempotent-gitupdate "https://github.com/dahlbyk/posh-git.git" "posh-git"

# Setup vim
if (test-path "C:\Program Files\Git\usr\bin\vim.exe") {
    del "C:\Program Files\Git\usr\bin\vim.exe.bak" -erroraction silentlycontinue -force
    ren "C:\Program Files\Git\usr\bin\vim.exe" "C:\Program Files\Git\usr\bin\vim.exe.bak" -force
}
idempotent-chocolatey vim
cd $installRootDir\env
copy .vimrc ~/.vimrc -force
if (-not (test-path "~/.vim/bundle")) {
    mkdir ~/.vim/bundle
}
cd ~/.vim/bundle
idempotent-gitupdate https://github.com/gmarik/Vundle.vim.git Vundle.vim
vim +PluginInstall +qall
vim +PluginClean +qall

# Setup conemu
idempotent-chocolatey conemu
# import conemu settings
# create cmd/ vim/ scribestar and npm shortcuts with icons on the taskbar

# Setup sublime text license
idempotent-chocolatey sublimetext2

# Setup diff tool

# 3rd party application installs
idempotent-chocolatey passwordsafe
idempotent-chocolatey dropbox

# shortcut creations
cd $installRootDir
.\env\shortcuts.ps1 $installRootDir

