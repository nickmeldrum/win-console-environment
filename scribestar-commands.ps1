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

$projectFiles = @()
$ignore = @(".nuget", "target", "packages", "node_modules", "bin", "obj", ".teamcity", ".git", "docs", "lib")

Function ListProjectFilesRecurse {
    param ($dir)
    
    if ($script:ignore.contains($dir.name)) { return }

    ls -path $dir.fullname -directory -exclude $script:ignore | % { ListProjectFilesRecurse $_ }

    $script:projectFiles += ls -path $dir.fullname -file "*.csproj"
}

Function List-ProjectFiles {
    $script:projectFiles = @()
    pushd
    ssrootdir
    ListProjectFilesRecurse ".\"
    popd
    $script:projectFiles
}

Function String-ContainsCaseInsensitive {
    param ([string]$original, [string]$contains)

    return $original.indexof($contains, [System.StringComparison]::OrdinalIgnoreCase) -ge 0
}

function IfNull($a, $b, $c) { if ($a -eq $null) { $b } else { $c } }

Function List-TestProjectFiles {
    param ([string[]]$include, [string[]]$exclude)

    List-ProjectFiles | where {(String-ContainsCaseInsensitive $_.name "tests")} |
        where {
            foreach ($item in $include) { if (( String-ContainsCaseInsensitive $_.name $item )) { return $true } }
            return (IfNull $include $true $false)
        } | where {
            if ($exclude -eq $null) { return $true }
            foreach ($item in $exclude) { if ((String-ContainsCaseInsensitive $_.name $item)) { return $false } }
            return $true
        }
}

Function Get-AssemblyFromTestProjectFiles {
    param ([string[]]$include, [string[]]$exclude)

    [System.IO.FileInfo[]]$projectFiles = (List-TestProjectFiles -include $include -exclude $exclude)

    $assemblyNames = @()

    foreach($projectFile in $projectFiles) {
        [xml]$xml = Get-Content $projectFile.fullname
        $ns = @{ns="http://schemas.microsoft.com/developer/msbuild/2003"}
        $asmName = (Select-Xml -Xml $xml -XPath '/ns:Project/ns:PropertyGroup/ns:AssemblyName/text()' -Namespace $ns).node.value
        $outputPath = (Select-Xml -Xml $xml -XPath "/ns:Project/ns:PropertyGroup[contains(@Condition, 'Debug')]/ns:OutputPath/text()" -Namespace $ns).node.value 

        $fullAsmPath = join-path (join-path $projectFile.directory.fullname $outputpath) "$asmName.dll"

        $assemblyNames += $fullAsmPath
    }

    return $assemblyNames
}

function Test-WholeSuite {
    Run-Nunit (Get-AssemblyFromTestProjectFiles)
}

function Test-AllExceptBrowser {
    Run-Nunit (Get-AssemblyFromTestProjectFiles -exclude "Automated")
}

function Test-Browser {
    Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Automated")
}

function Test-Checklisting {
    Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Checklisting")
}

function Test-SystemIntegration {
    Run-Nunit (Get-AssemblyFromTestProjectFiles -include "SystemIntegration")
}

function Test-Bookmarking {
    Run-Nunit (Get-AssemblyFromTestProjectFiles -include "SystemIntegration") "ScribeStar.SystemIntegrationTests.Bookmarking"
}

function Test-Diff {
    Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Diff")
}

function Build-ScribeStarSolution
{
    stopss
    stopssc
    & "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe" "$($localConfig.scribestarRepo)\ScribeStar.sln" /t:build
}

function Build-SystemIntegrationTests
{
    stopss
    stopssc
    & "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe" (Get-TestCsProj "SystemIntegration") /t:build
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
    Write-host "List-TestProjectFiles -include strarry -exclude strarray        | List all test project files"
    Write-host "Get-AssemblyFromTestProjectFiles -include strarray -exclude strarray        | List all tests assemblies to pass into Run-Nunit"
    Write-host "Run-Nunit asmList ns                    | Run unit tests, e.g. Run-Nunit `$asmList `"ScribeStar.Document.Service.Tests.SystemIntegrationTests`""
    Write-host "Test-WholeSuite                         | nunit test everything including selenium stuff"
    Write-host "Test-AllExceptBrowser                   | nunit test everything except selenium stuff"
    Write-host "Test-Browser                            | nunit test only selenium stuff"
    Write-host "Test-Checklisting"
    Write-host "Test-SystemIntegration"
    Write-host "Test-Diff"
    Write-host "curl -Uri `"http://localhost:8080/static/?start=0&pagesize=128`" -Method GET  | list all attachments in local ravendb"
    Write-Host "gci D:\prod\web\scribestar.web\sass\styles -recurse | Select-String -Pattern `"pattern`" | look for pattern in sass files recursively"
}
 
