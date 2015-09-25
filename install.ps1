#local env
mkdir c:\work

#git
choco install git -y -params '"/GitAndUnixToolsOnPath"' --force

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
copy .gitconfig ~/.gitconfig
copy localconfig.json ~/localconfig.json

# nodejs
choco install nodejs -y
copy .npmrc ~/.npmrc

# autohotkey
choco install autohotkey -y
copy autohotkey.ahk ~/Documents/autohotkey.ahk

# Setup autohotkey to run and always run on logon
autohotkey
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
git clone https://github.com/dahlbyk/posh-git.git
cd ..

# Setup vim
ren "C:\Program Files\Git\usr\bin\vim.exe" "C:\Program Files\Git\usr\bin\vim.exe.bak"
choco install vim -y --force
copy .vimrc ~/.vimrc
mkdir ~/.vim/bundle
cd ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git
cd c:\work\env
vim +PluginInstall +qall

# Setup conemu
choco install conemu -y
# import conemu settings
# create cmd/ vim/ scribestar and npm shortcuts with icons on the taskbar

# Setup sublime text license
choco install sublimetext2 -y

# Setup diff tool

# 3rd party application installs
choco install passwordsafe -y
choco install dropbox -y
