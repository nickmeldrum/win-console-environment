$env:PSModulePath = $env:PSModulePath + ";D:\Work\env\3rdparty"

Import-Module "PowerTab" -ArgumentList "C:\Users\nick.meldrum\Documents\WindowsPowerShell\PowerTabConfig.xml"

. 'D:\Work\env\posh-git\profile.example.ps1'
. 'D:\Work\env\shell-commands.ps1'
. 'D:\Work\env\git-commands.ps1'
. 'D:\Work\env\system-commands.ps1'
. 'D:\Work\env\dotnet-commands.ps1'
. 'D:\Work\env\scribestar-commands.ps1'
. 'D:\Work\env\launch-commands.ps1'

c:
cd \Work
ep # this command exists in launch-commands.ps1

