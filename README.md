powershell-productivity-scripts
===============================

How to setup the apps needed for a nice windows/git/powershell experience:

1. Install git from here: http://git-scm.com/download/win with the 3rd option to "Use Git and optional Unix tools from the Windows Command Prompt"
2. Install the "Windows Credential Store for Git" from here: https://gitcredentialstore.codeplex.com/ (no more hassle with passwords/ ssh keys yay)
3. Install your console from here: https://code.google.com/p/conemu-maximus5/ (DON'T YOU DARE USE THE DEFAULT CONSOLE - IT SUCKS!)

The minimal setup for ConEmu:

1. Startup | Tasks: Bump {PowerShell (Admin)} to no. 1 in the list
2. Startup: Set the "Specified named task" to be "{Powershell (Admin)}"
3. Main: Set the Main console font size to 16 and the font to "Consolas"
4. Main | Appearance: Check "Hide caption when maximized"
5. Main | Confirm: Uncheck everything!
6. Features | Colors: Set Standard colors no. 7. to 0, 255, 0 (green)
7. Set ConEmu shortcut to "pin to taskbar", right click | properties | advanced... and check "Run as administrator"
8. Main Tabs: Tabs: Auto show

Setting up your git config:

1. Copy the following into your %userprofile%/.gitconfig (changing the username/ email values to your own)
        [user] 
         name = Nick Meldrum
         email = nick@nickmeldrum.com
        [alias]
         st = status
         cm = commit -v -m
         ad = add -A
         br = branch
         unstage = reset HEAD --
         last = log -1 HEAD
 [branch]
         autosetuprebase = always         
        [pull]
         rebase = true
[diff]
	tool = bc3
[difftool "bc3"]
	path = c:/Program Files (x86)/Beyond Compare 3/bcomp.exe
[merge]
	tool = bc3
[mergetool "bc3"]
	path = c:/Program Files (x86)/Beyond Compare 3/bcomp.exe
[push]
	default = simple

How to configure these productivity scripts for your environment:

1. Clone this repo locally into [DIR]
2. edit "copy-of-profile.ps1" and replace "C:\users\nick\src\current\powershell-productivity-scripts\" with [DIR]
3. copy your new "copy-of-profile.ps1" file to: %userprofile%\Documents\WindowsPowerShell\profile.ps1
4. Clone the posh-git repository "git clone https://github.com/dahlbyk/posh-git.git" into [DIR]\3rdparty



TODO: 
beyond compare and git hookup
sublime text powershell and vintage stuff


