# Fix these vars per machine:
$userRoot = "C:\Users\nick.meldrum"
$envRepo = "D:\env"
$scribestarRepo = "D:\prod"

$githubToken = (& "$envrepo\3rdparty\credman.ps1" -getcred -target 'nicks:githubToken').password

$githubUsername = (& "$envrepo\3rdparty\credman.ps1" -getcred -target 'nicks:githubPassword').username
$githubPassword = (& "$envrepo\3rdparty\credman.ps1" -getcred -target 'nicks:githubPassword').password

$bitbucketUsername = (& "$envrepo\3rdparty\credman.ps1" -getcred -target 'nicks:bitbucketToken').username
$bitbucketToken = (& "$envrepo\3rdparty\credman.ps1" -getcred -target 'nicks:bitbucketToken').password

$dnsimpleEmail = (& "$envrepo\3rdparty\credman.ps1" -getcred -target 'nicks:dnsimpleToken').username
$dnsimpleToken = (& "$envrepo\3rdparty\credman.ps1" -getcred -target 'nicks:dnsimpleToken').password

$env:PSModulePath = $env:PSModulePath + ";$envRepo\3rdparty"
# Import-Module "PowerTab" -ArgumentList "$userRoot\Documents\WindowsPowerShell\PowerTabConfig.xml"
echo "setting up posh-git..."
. "$envRepo\3rdparty\posh-git\profile.example.ps1"
echo "setting up shell commands..."
. "$envRepo\shell-commands.ps1"
echo "setting up system commands..."
. "$envRepo\system-commands.ps1"
echo "setting up git commands..."
. "$envRepo\git-commands.ps1"
echo "setting up dotnet commands..."
. "$envRepo\dotnet-commands.ps1"
echo "setting up scribestar commands..."
. "$envRepo\scribestar-commands.ps1"
echo "setting up launch commands..."
. "$envRepo\launch-commands.ps1"
ep # this command exists in launch-commands.ps1

