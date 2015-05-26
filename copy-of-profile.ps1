# Fix these vars per machine:
$userRoot = "C:\Users\nick.meldrum"
$envRepo = "D:\env"
$scribestarRepo = "D:\prod"

# Enter these values:
$githubUsername= "nickmeldrum"
$githubToken = "apptoken"
$bitbucketUsername= "nickmeldrum"
$bitbucketToken = "apptoken"

$env:PSModulePath = $env:PSModulePath + ";$envRepo\3rdparty"
Import-Module "PowerTab" -ArgumentList "$userRoot\Documents\WindowsPowerShell\PowerTabConfig.xml"
. "$envRepo\3rdparty\posh-git\profile.example.ps1"
. "$envRepo\shell-commands.ps1"
. "$envRepo\system-commands.ps1"
. "$envRepo\git-commands.ps1"
. "$envRepo\dotnet-commands.ps1"
. "$envRepo\scribestar-commands.ps1"
. "$envRepo\launch-commands.ps1"
. "$scribestarRepo\tools\install-modules.ps1"
ep # this command exists in launch-commands.ps1

