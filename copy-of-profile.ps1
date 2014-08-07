$env:PSModulePath = $env:PSModulePath + ";C:\Users\Nick\src\current\powershell-productivity-scripts\3rdparty"

$githubUsername = "nickmeldrum"
$githubToken = "mysecrettokenhere!"

Import-Module "PowerTab" -ArgumentList "C:\Users\Nick\Documents\WindowsPowerShell\PowerTabConfig.xml"

. 'C:\Users\Nick\src\others\posh-git\posh-git\profile.example.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\shell-commands.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\git-commands.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\dotnet-commands.ps1'
. 'C:\users\nick\src\current\powershell-productivity-scripts\launch-commands.ps1'

c:
cd \users\nick\src\current
ep # this command exists in launch-commands.ps1
