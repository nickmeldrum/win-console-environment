function SSScriptsDir {
    cd "$($localConfig.scribestarRepo)\src\ScribeStar.Web\scripts"
}

function SSWebDir {
    cd "$($localConfig.scribestarRepo)\src\ScribeStar.Web"
}

function SSDiffDir {
    cd "$($localConfig.scribestarRepo)\src\dita-compare-service"
}

function SSDiffTestsDir {
    cd "$($localConfig.scribestarRepo)\src\ScribeStar.SystemIntegrationTests\Diff"
}

function SSRootDir {
    cd $localConfig.scribestarRepo
}

function Start-ScribeStarServices {
    gsv | where {$_.name -like 'ScribeStar*'} | Start-Service
    gsv | where {$_.name -like 'ScribeStar*'}
}

function Stop-ScribeStarServices {
    gsv | where {$_.name -like 'ScribeStar*'} | Stop-Service
    gsv | where {$_.name -like 'ScribeStar*'}
}

function Start-ScribeStarConsoleServices {
    Start-ProcessIfNotRunning "ScribeStar.Notifications.Service" "$($localCOnfig.scribestarRepo)\src\ScribeStar.Notifications.Service\bin\Debug\ScribeStar.Notifications.Service.exe"
}

function Stop-ScribeStarConsoleServices {
    Stop-ProcessIfStarted "ScribeStar.Notifications.Service"
}

function List-ScribeStarServiceStatus {
    gsv | where {$_.name -like 'ScribeStar*'}
    Get-Process 'ScribeStar*' | Format-Table
}

function Build-ScribeStarSolution
{
    stopss
    & "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe" "$($localCOnfig.scribestarRepo)\ScribeStar.sln" /t:build
}

function Run-Nunit {
    param (
        [string[]]$assemblies,
        [string]$spec
    )

    $nunitPath = "`"C:\Program Files (x86)\NUnit 2.6.4\bin\nunit-console.exe`""

    if ($assemblies -eq $null -or $assemblies.Count -eq 0) {
        Throw "you must include an assembly!"
    }

    $argList = $assemblies -join " "

    if (![string]::IsNullOrWhitespace($spec)) {
        $argList = $argList += " /run=$spec"
    }

#$argList = $argList += " /output=test-output.xml"

    echo "============================================"
    echo "Nunit command:"
    echo $argList
    echo "============================================"

    $command = $nunitPath + $argList
    iex "& $command"

    [xml]$testresults = cat .\TestResult.xml

    echo "TODO: growl this!"
    echo ("Total tests: " + $testresults."test-results".total)
    echo ("Tests ignored: " + $testresults."test-results".ignored)
    echo ("Test errors: " + $testresults."test-results".errors)
    echo ("Test failures: " + $testresults."test-results".failures)

    if ($testresults."test-results".failures -ne "0") {
        echo "test assemblies that didn't succeed (possibly ignored or failed):"
        select-xml "//test-suite[@result!='Success' and @type='Assembly']/@name" $testresults | % {$_.Node.'#text'}
        echo "test cases that FAILED:"
        select-xml "//test-case[@result='Failure']/@name" $testresults | % {$_.Node.'#text'}
    }
}

Function List-TestProjects {
    pushd
    ssrootdir
    ls "*.csproj" -recurse | grep "csproj" | grep "Tests" | gawk '{print $5}' | % {$_.replace(".csproj", "")}
    popd
}

Function List-TestProjectsPath {
    pushd
    ssrootdir
    ls *.csproj -recurse | where {$_.extension -eq ".csproj" -and $_.name.contains("Tests")} | % { write-output $_.directoryname}
    popd
}

function Get-NunitAsmList {
    param (
        [Array]$asmKeys
    )

    $rootPath = "$($localConfig.scribestarRepo)\"
    $asmConfigPath = "bin\Debug\"

    $testAssemblies = @{
        "DocService" = $rootPath + "instance\ScribeStar.Document.Service.Tests\" + $asmConfigPath + "ScribeStar.Document.Service.Tests.dll";
        "Doc" = $rootPath + "instance\ScribeStar.Document.Tests\" + $asmConfigPath + "ScribeStar.Document.Tests.dll";
        "Browser" = $rootPath + "src\Scribestar.AutomatedTests\bin\ScribeStar.AutomatedTests.dll";
        "Client" = $rootPath + "src\ScribeStar.Client\" + $asmConfigPath + "ScribeStar.Client.dll";
        "Shared" = $rootPath + "src\ScribeStar.Shared.Tests\" + $asmConfigPath + "ScribeStar.Core.Tests.dll";
        "Tests" = $rootPath + "src\ScribeStar.Tests\" + $asmConfigPath + "ScribeStar.Tests.dll";
        "Web" = $rootPath + "src\ScribeStar.Web.Tests\" + $asmConfigPath + "ScribeStar.Web.Tests.dll";
    }

    $outputArray = @()

    if ($asmKeys -eq $null -or $asmKeys.Count -eq 0) {
        $testAssemblies.getEnumerator() | % { $outputArray += $_.Value }
    }
    else {
        $testAssemblies.getEnumerator() | where Name -in $asmKeys | % { $outputArray += $_.Value }
    }

    return $outputArray
}

function Test-WholeSuite {
    Run-Nunit (Get-NunitAsmList)
}

function Test-AllExceptBrowser {
    $asmList = Get-NunitAsmList @("DocService", "Doc", "Client", "Shared", "Tests", "Web")
    Run-Nunit $asmList
}

function Test-DocStuff {
    $asmList = Get-NunitAsmList @("DocService", "Doc")
    Run-Nunit $asmList
}

function Test-SystemIntegration {
    $asmList = Get-NunitAsmList @("DocService")
    Run-Nunit $asmList "ScribeStar.Document.Service.Tests.SystemIntegrationTests"
}

function Test-Importers {
    $asmList = Get-NunitAsmList @("DocService")
    Run-Nunit $asmList "ScribeStar.Document.Service.Tests.WordImporter.Importers"
}

function Rebuild-ScribeStarSolution()
{
    stopss
    stopssc
    & "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe" compile.msbuild /p:Configuration=Debug /t:Rebuild /v:m /m
    startss
}

function Debug-Web
{
    vsjitdebugger -p (gwmi win32_process | where {$_.Name -eq "w3wp.exe" -and $_.getowner().user -eq "Scribestar"}).ProcessId
}

function Debug-WebApi
{
    vsjitdebugger -p (gwmi win32_process | where {$_.Name -eq "w3wp.exe" -and $_.getowner().user -eq "Scribestar.WebApi"}).ProcessId
}

function Debug-NotificationsService
{
    vsjitdebugger -p (gwmi win32_process | where {$_.Name -eq "ScribeStar.Notifications.Service.exe"}).ProcessId
}

function Make-DevCert
{
    makecert.exe -n "CN=Nicks Fake Root CA,O=Fake Company, OU=Development" -pe -ss Root -sr LocalMachine -sky exchange -m 120 -a sha1 -len 2048 -r
    makecert.exe -n "CN=development.scribestar.internal" -pe -ss My -sr LocalMachine -sky exchange -m 120 -in "Nicks Fake Root CA" -is Root -ir LocalMachine -a sha1 -eku 1.3.6.1.5.5.7.3.1
}

#function Update-ActualSiteCss {
#    $folder = 'D:\prod\src\scribestar.web\sass'
#    $filter = 'site.css'
#     
#    $fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{IncludeSubdirectories = $false;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

#    Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action { 
#        $name = $Event.SourceEventArgs.Name 
#        $changeType = $Event.SourceEventArgs.ChangeType 
#        $timeStamp = $Event.TimeGenerated 

#        #Out-File -FilePath d:\work\scratch\UpdateActualSiteCss.log -Append -InputObject "The file '$name' was $changeType at $timeStamp"

#        copy D:\prod\src\scribestar.web\sass\site.css D:\prod\src\ScribeStar.Web\content\site.css
#        del D:\prod\src\scribestar.web\sass\site.css
#    }  


#    Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -Action { 
#        $name = $Event.SourceEventArgs.Name 
#        $changeType = $Event.SourceEventArgs.ChangeType 
#        $timeStamp = $Event.TimeGenerated 
#        
#        #Out-File -FilePath d:\work\scratch\UpdateActualSiteCss.log -Append -InputObject "The file '$name' was $changeType at $timeStamp"

#        copy D:\prod\src\scribestar.web\sass\site.css D:\prod\src\ScribeStar.Web\content\site.css
#        del D:\prod\src\scribestar.web\sass\site.css

#    } 

#    write-host "compass watch --css-dir src\scribestar.web\sass --sass-dir src\scribestar.web\sass\styles --output-style expanded"
#}

Set-Alias startss Start-ScribeStarServices
Set-Alias stopss Stop-ScribeStarServices
Set-Alias startssc Start-ScribeStarConsoleServices
Set-Alias stopssc Stop-ScribeStarConsoleServices
Set-Alias listss List-ScribeStarServiceStatus
Set-Alias build Build-ScribeStarSolution
Set-Alias rebuild Rebuild-ScribeStarSolution

function Echo-ScribestarCommands {
    Write-Title "Scribestar Commands:"

    Write-Host "stopss                                  | Stop ScribeStar Services as service (Notification, Document and Transaction)"
    Write-Host "startss                                 | Start ScribeStar Services as service (Notification, Document and Transaction)"
    Write-Host "stopssc                                 | Stop ScribeStar Services as console host (Notification, Document and Transaction)"
    Write-Host "startssc                                | Start ScribeStar Services as console host (Notification, Document and Transaction)"
    Write-Host "listss                                  | List ScribeStar Services to see if they are running as services or console (Notification, Document and Transaction)"
    Write-host "build                                   | Build ScribeStar Solutions"
    Write-host "rebuild                                 | Rebuild ScribeStar Solutions"
    Write-host "debug-web or debug-webapi               | Debug ScribeStar Web or web api"
    Write-host "Debug-NotificationsService              | Debug notifications service or console"
    Write-host "SSScriptsDir SSWebDir SSDiffDir SSDiffTestsDir SSRootDir                   | move to directories in solution"
    Write-host "Get-NunitAsmList                        | List all tests assemblies to pass into Run-Nunit"
    Write-host "Run-Nunit asmList ns                    | Run unit tests, e.g. Run-Nunit (Get-NunitAsmList @(`"DocService`", `"Doc`")) `"ScribeStar.Document.Service.Tests.SystemIntegrationTests`""
    Write-host "Test-WholeSuite                         | nunit test everything including selenium stuff"
    Write-host "Test-AllExceptBrowser                   | nunit test everything except selenium stuff"
    Write-host "Test-DocStuff                           | nunit test DocumentService and Document"
    Write-host "Test-SystemIntegration                  | nunit test ScribeStar.Document.Service.Tests.SystemIntegrationTests namespace in DocService"
    Write-host "Test-Importers                          | nunit test ScribeStar.Document.Service.Tests.WordImporter.Importers namespace in DocService"
    Write-host "curl -Uri `"http://localhost:8080/static/?start=0&pagesize=128`" -Method GET  | list all attachments in local ravendb"
    Write-Host "gci D:\prod\web\scribestar.web\sass\styles -recurse | Select-String -Pattern `"pattern`" | look for pattern in sass files recursively"
    Write-Host "List-TestProjects - recursively search for all csprojs with the word test in them"
}
 
