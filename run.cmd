@echo off
choco > nul 2> nul
if %errorlevel% EQU 1 (
    echo "choco already installed"
) else if %errorlevel% EQU 9009 (
    echo "choco not installed, installing..."
    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" 
    SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
) else (
    echo "error checking choco install: %errorlevel%"
)
echo "running powershell install script..."
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/nickmeldrum/win-console-environment/master/install.ps1'))"
