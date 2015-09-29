$ErrorActionPreference = "Stop"

# Setup a file in your home directory called localconfig.json like this:
# {
#     "userRoot": "C:/Users/nick.meldrum",
#     "envRepo": "D:/env",
#     "scribestarRepo": "D:/prod",
#     "defaultChromeProfile": "Profile 3"
# }

if (-not (test-path ~/localconfig.json)) {
    throw "localconfig.json file not found!"
}

$localConfig = get-content ~/localconfig.json -raw | convertfrom-json

import-module "$($localConfig.envrepo)\passwordvault.psm1" -force

$githubToken = (Get-PasswordVaultCredentials 'githubToken').password

$githubUsername = (Get-PasswordVaultCredentials 'githubPassword').username
$githubPassword = (Get-PasswordVaultCredentials 'githubPassword').password

$bitbucketUsername = (Get-PasswordVaultCredentials 'bitbucketToken').username
$bitbucketToken = (Get-PasswordVaultCredentials 'bitbucketToken').password

$dnsimpleEmail = (Get-PasswordVaultCredentials 'dnsimpletoken').username
$dnsimpleToken = (Get-PasswordVaultCredentials 'dnsimpletoken').password

$env:PSModulePath = $env:PSModulePath + ";$($localConfig.envrepo)\3rdparty"
# Import-Module "PowerTab" -ArgumentList "$userRoot\Documents\WindowsPowerShell\PowerTabConfig.xml"
echo "setting up posh-git..."
. "$($localConfig.envrepo)\3rdparty\posh-git\profile.example.ps1"
echo "setting up shell commands..."
. "$($localConfig.envrepo)\shell-commands.ps1"
echo "setting up system commands..."
. "$($localConfig.envrepo)\system-commands.ps1"
echo "setting up git commands..."
. "$($localConfig.envrepo)\git-commands.ps1"
echo "setting up dotnet commands..."
. "$($localConfig.envrepo)\dotnet-commands.ps1"
echo "setting up scribestar commands..."
. "$($localConfig.envrepo)\scribestar-commands.ps1"
echo "setting up launch commands..."
. "$($localConfig.envrepo)\launch-commands.ps1"
# ep # this command exists in launch-commands.ps1

