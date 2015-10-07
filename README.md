# Windows Console environment setup

## What this installs

 * Chocolatey
 * Git (with unix tools) and my fork of the git credential store allowing multiple user logons
 * Vim (with vundle and a bunch of plugins)
 * Conemu console 
 * Nodejs
 * My powershell profile and posh-git
 * Autohotkey and capslock -> escape key (with run on login capability turned on)
 * Sublime text 2
 * Dropbox and Password safe

## Setup

 * Copy the following command from an administrator command prompt:
 `@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/nickmeldrum/win-console-environment/master/run.cmd'))"`
 * Then complete the following steps that are yet to be automated:

 1. Open credential manager and add the githubToken, githubPassword, bitbucketToken and dnsimpletoken usernames and passwords
 2. Edit the ~/localconfig.json file and set the values correctly
 3. Import the conemusettings.xml file found in this repo (now cloned locally)

