# 3rd party application installs
choco install conemu -y
choco install autohotkey -y
choco install git -y -params '"/GitAndUnixToolsOnPath"' --force
choco install vim -y --force
choco install passwordsafe -y
choco install dropbox -y
choco install nodejs -y
choco install sublimetext2 -y

mkdir c:\work

# Install my fork of git credential store
cd c:\work
git clone https://nickmeldrum@git01.codeplex.com/forks/nickmeldrum/gitcredentialstore gitcredentialstore
cd gitcredentialstore
msbuild
.\InstallLocalBuild.cmd

# Get my environment settings and files and set them up
cd c:\work
git clone https://nickmeldrum@github.com/nickmeldrum/win-console-environment.git env
cd env
if (test-path $profile) {
	del $profile -force
}
new-item $profile -force -type file
copy copy-of-profile.ps1 $profile -force
copy .gitconfig ~/.gitconfig
copy .npmrc ~/.npmrc
copy .vimrc ~/.vimrc
copy localconfig.json ~/localconfig.json
copy autohotkey.ahk ~/Documents/autohotkey.ahk

# Setup autohotkey to run and always run on logon
autohotkey
$action = New-ScheduledTaskAction -Execute "C:\Program Files\AutoHotkey\AutoHotkey.exe" -Id "autohotkey"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AutoHotkey"

# Setup powershell environment - profile/ posh git etc. not being picked up?

# Setup vim
# check .vimrc is working?
# clone vundle
# do plugin install

# Setup conemu
# import conemu settings
# create cmd/ vim/ scribestar and npm shortcuts with icons on the taskbar

# Setup sublime text license

# Setup diff tool

