Setting up my windows machine
==============================

How to setup your environment in Windows for a lovely console powershell/git/vim development environment:

1. Install tools from the interwebs:
	1. Install git from here: http://git-scm.com/download/win with the 3rd option to "Use Git and optional Unix tools from the Windows Command Prompt"
	2. Install the "Windows Credential Store for Git" from here: https://gitcredentialstore.codeplex.com/ (no more hassle with passwords/ ssh keys yay)
	3. Install your console from here: https://code.google.com/p/conemu-maximus5/ (DON'T YOU DARE USE THE DEFAULT CONSOLE - IT SUCKS!)
	4. Install AutoHotKey from here: http://www.autohotkey.com/
	5. Install Beyond Compare from: http://www.scootersoftware.com/download.php?zz=dl3_en

2. Setup AutoHotKey: (from http://vim.wikia.com/wiki/Map_caps_lock_to_escape_in_Windows)
	1. Add Capslock::Esc as a line in the AutoHotKey settings file
	
3. Setup ConEmu:
	3. Import the conemu-settings.xml file in this repo, which will do the following:
		1. Startup | Tasks: Bump {PowerShell (Admin)} to no. 1 in the list
		2. Startup: Set the "Specified named task" to be "{Powershell (Admin)}"
		3. Main: Set the Main console font size to 16 and the font to "Consolas"
		4. Main | Appearance: Check "Hide caption when maximized"
		5. Main | Confirm: Uncheck everything!
		6. Features | Colors: Set Standard colors no. 7. to 0, 255, 0 (green)
		7. Set ConEmu shortcut to "pin to taskbar", right click | properties | advanced... and check "Run as administrator"
		8. Main Tabs: Tabs: Auto show

4. Setup Vim:
	1. Copy the .vimrc file from this repo into your %HOMEDIR%/ ~/ $HOME (e.g. C:\users\username on Windows 7 etc.)
	2. Create a .vim folder in your %HOMEDIR%/ ~/ $HOME
	3. Git clone https://github.com/gmarik/Vundle.vim.git in the .vim/bundle folder
	4. Ensure Vim is in the path (from the git install, typically: C:\Program Files (x86)\Git\share\vim\vim74)
	4. Load up vim and load the plugins by :PluginInstall

5. Setup Git config:
	1. Copy the .gitconfig from this repo to %userprofile%/.gitconfig
	2. changing the username/ email values to your own

6. Setup Powershell scripts:
	1. Clone this repo locally into [DIR]
	2. edit "copy-of-profile.ps1" and replace "C:\users\nick\src\current\powershell-productivity-scripts\" with [DIR]
	3. copy your new "copy-of-profile.ps1" file to: %userprofile%\Documents\WindowsPowerShell\profile.ps1
	4. Clone the posh-git repository "git clone https://github.com/dahlbyk/posh-git.git" into [DIR]\3rdparty

7. Setup Beyond Compare:
	1. The .gitconfig file above should have diff and 3 way merge setup correctly already just so long as the install paths are correct
	
