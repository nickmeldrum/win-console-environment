$env:PSModulePath = $env:PSModulePath + ";C:\Users\Nick\src\ps\3rdparty"

$githubUsername = "nickmeldrum"
$githubToken = "mysecrettokenhere!"

Import-Module "PowerTab" -ArgumentList "C:\Users\Nick\Documents\WindowsPowerShell\PowerTabConfig.xml"

. 'C:\users\nick\src\current\powershell-productivity-scripts\posh-git\profile.example.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\shell-commands.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\git-commands.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\system-commands.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\dotnet-commands.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\scribestar-commands.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\launch-commands.ps1'

c:
cd \users\nick\src
ep # this command exists in launch-commands.ps1
