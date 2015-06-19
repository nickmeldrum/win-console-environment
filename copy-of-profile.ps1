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

