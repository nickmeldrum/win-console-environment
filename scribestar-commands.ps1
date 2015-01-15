function Start-ScribeStarServices {
    gsv | where {$_.name -like 'ScribeStar*'} | Start-Service
    gsv | where {$_.name -like 'ScribeStar*'}
}

function Stop-ScribeStarServices {
    gsv | where {$_.name -like 'ScribeStar*'} | Stop-Service
    gsv | where {$_.name -like 'ScribeStar*'}
}

function Start-ScribeStarConsoleServices {
    Start-ProcessIfNotRunning "ScribeStar.Notifications.Service" "D:\Work\Product\instance\ScribeStar.Notifications.Service\bin\Debug\ScribeStar.Notifications.Service.exe"
    Start-ProcessIfNotRunning "ScribeStar.Document.Service" "D:\Work\Product\instance\ScribeStar.Document.Service\bin\Debug\ScribeStar.Document.Service.exe"
    #Start-ProcessIfNotRunning "ScribeStar.Transaction.Service" "D:\Work\Product\instance\ScribeStar.Transaction.Service\bin\Debug\ScribeStar.Transaction.Service.exe"
}

function Stop-ScribeStarConsoleServices {
    Stop-ProcessIfStarted "ScribeStar.Notifications.Service"
    Stop-ProcessIfStarted "ScribeStar.Document.Service"
    #Stop-ProcessIfStarted "ScribeStar.Transaction.Service"
}

function List-ScribeStarServiceStatus {
    gsv | where {$_.name -like 'ScribeStar*'}
    Get-Process 'ScribeStar*' | Format-Table
}

function Build-ScribeStarSolution
{
    stopss
    & "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe" "C:\Work\Product\ScribeStar.Instance.sln" /t:build
}

function Run-Nunit {
    param (
        $assemblies,
        [string]$spec
    )

    $nunitPath = "C:\Program Files (x86)\NUnit 2.6.3\bin\nunit-console.exe"

    if ($assemblies -eq $null -or $assemblies.Count -eq 0) {
        Throw "you must include an assembly!"
    }

    if ($assemblies.Count -eq 1) {
        $argList = @($assemblies.Value)
    }
    else {
        $argList = $assemblies.Values        
    }

    if (![string]::IsNullOrWhitespace($spec)) {
        $argList = $argList += "/run=$spec"
    }

    $argList = $argList += "/output=Off"

    echo "Nunit arguments:"
    echo $argList
    echo "============================================"

    &$nunitPath $argList
}

function Get-NunitAsmList {
    param (
        [Array]$asmKeys
    )

    $rootPath = "c:\Work\Product\"
    $asmConfigPath = "bin\Debug\"

    $testAssemblies = @{
        "Central" = $rootPath + "central\ScribeStar.Central.Tests\" + $asmConfigPath + "ScribeStar.Central.Tests.dll";
        "Changeset" = $rootPath + "instance\ScribeStar.Document.Changeset.Tests\" + $asmConfigPath + "ScribeStar.Document.Changeset.Tests.dll";
        "Document" = $rootPath + "Instance\ScribeStar.Document.Tests\" + $asmConfigPath + "ScribeStar.Document.Tests.dll";
        "Core" = $rootPath + "shared\ScribeStar.Core.Tests\" + $asmConfigPath + "ScribeStar.Core.Tests.dll";
        "Messages" = $rootPath + "shared\ScribeStar.Messages.Tests\" + $asmConfigPath + "ScribeStar.Messages.Tests.dll";
        "Instance" = $rootPath + "instance\UnitTests\" + $asmConfigPath + "ScribeStar.Instance.Tests.dll";
        "Web" = $rootPath + "instance\ScribeStar.Web.Tests\" + $asmConfigPath + "ScribeStar.Instance.Web.Tests.dll";
    }

    if ($asmKeys -eq $null -or $asmKeys.Count -eq 0) {
        return $testAssemblies
    }
    else {
        return $testAssemblies.getEnumerator() | where Name -in $asmKeys
    }
}

function Test-WholeSuite {
    Run-Nunit (Get-NunitAsmList)
}

function Test-DocumentAndChangeset {
    $asmList = Get-NunitAsmList @("Changeset", "Document")
    Run-Nunit $asmList
}

function Test-CentralAndCore {
    $asmList = Get-NunitAsmList @("Central", "Core")
    Run-Nunit $asmList
}

function Test-Messages {
    $asmList = Get-NunitAsmList @("Messages")
    Run-Nunit $asmList
}

function Test-InstanceAndWeb {
    $asmList = Get-NunitAsmList @("Instance", "Web")
    Run-Nunit $asmList
}

function Test-Instance {
    $asmList = Get-NunitAsmList @("Instance")
    Run-Nunit $asmList
}

function Test-Importer {
    $asmList = Get-NunitAsmList @("Instance")
    Run-Nunit $asmList "ScribeStar.Instance.Tests.Document.WordImporter" 
}

function Rebuild-ScribeStarSolution()
{
    stopss
    stopssc
    & "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe" compile.msbuild /p:Configuration=Debug /t:Rebuild /v:m /m
    startss
}

function Debug-Instance
{
    vsjitdebugger -p (gwmi win32_process | where {$_.Name -eq "w3wp.exe" -and $_.getowner().user -eq "Scribestar.Instance"}).ProcessId
}

function Debug-CentralService
{
    vsjitdebugger -p (gwmi win32_process | where {$_.Name -eq "w3wp.exe" -and $_.getowner().user -eq "Scribestar.CentralService"}).ProcessId
}

function Debug-DocumentService
{
    vsjitdebugger -p (gwmi win32_process | where {$_.Name -eq "ScribeStar.Document.Service.exe"}).ProcessId
}

function Make-DevCert
{
    makecert.exe -n "CN=Nicks Fake Root CA,O=Fake Company, OU=Development" -pe -ss Root -sr LocalMachine -sky exchange -m 120 -a sha1 -len 2048 -r
    makecert.exe -n "CN=development.scribestar.internal" -pe -ss My -sr LocalMachine -sky exchange -m 120 -in "Nicks Fake Root CA" -is Root -ir LocalMachine -a sha1 -eku 1.3.6.1.5.5.7.3.1
}

function Compass-Compile
{
    del c:\Work\Product\Instance\ScribeStar.Web\Content\site.css -force
    compass compile --css-dir "c:\Work\Product\Instance\ScribeStar.Web\Content" --sass-dir "c:\Work\Product\Instance\ScribeStar.Web\sass" --sourcemap --output-style expanded
}


function SSEditorDir {
    cd "C:\work\product\instance\ScribeStar.Web\scripts\editor"
}

function SSRootDir {
    cd "C:\work\product\instance"
}

function EditorKarma {
    sseditordir
    karma start
}

#function Update-ActualSiteCss {
#    $folder = 'D:\Work\Product\instance\scribestar.web\sass'
#    $filter = 'site.css'
#     
#    $fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{IncludeSubdirectories = $false;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

#    Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action { 
#        $name = $Event.SourceEventArgs.Name 
#        $changeType = $Event.SourceEventArgs.ChangeType 
#        $timeStamp = $Event.TimeGenerated 

#        #Out-File -FilePath d:\work\scratch\UpdateActualSiteCss.log -Append -InputObject "The file '$name' was $changeType at $timeStamp"

#        copy D:\Work\Product\instance\scribestar.web\sass\site.css D:\Work\Product\instance\ScribeStar.Web\content\site.css
#        del D:\Work\Product\instance\scribestar.web\sass\site.css
#    }  


#    Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -Action { 
#        $name = $Event.SourceEventArgs.Name 
#        $changeType = $Event.SourceEventArgs.ChangeType 
#        $timeStamp = $Event.TimeGenerated 
#        
#        #Out-File -FilePath d:\work\scratch\UpdateActualSiteCss.log -Append -InputObject "The file '$name' was $changeType at $timeStamp"

#        copy D:\Work\Product\instance\scribestar.web\sass\site.css D:\Work\Product\instance\ScribeStar.Web\content\site.css
#        del D:\Work\Product\instance\scribestar.web\sass\site.css

#    } 

#    write-host "compass watch --css-dir instance\scribestar.web\sass --sass-dir instance\scribestar.web\sass\styles --output-style expanded"
#}


Set-Alias startss Start-ScribeStarServices
Set-Alias stopss Stop-ScribeStarServices
Set-Alias startssc Start-ScribeStarConsoleServices
Set-Alias stopssc Stop-ScribeStarConsoleServices
Set-Alias listss List-ScribeStarServiceStatus
Set-Alias rebuild Rebuild-ScribeStarSolution
Set-Alias debugweb Debug-Instance
Set-Alias debugcentral Debug-CentralService
Set-Alias debugdoc Debug-DocumentService

function Echo-ScribestarCommands {
    Write-Title "Scribestar Commands:"

    Write-Host "stopss                                  | Stop ScribeStar Services as service (Notification, Document and Transaction)"
    Write-Host "startss                                 | Start ScribeStar Services as service (Notification, Document and Transaction)"
    Write-Host "stopssc                                 | Stop ScribeStar Services as console host (Notification, Document and Transaction)"
    Write-Host "startssc                                | Start ScribeStar Services as console host (Notification, Document and Transaction)"
    Write-Host "listss                                  | List ScribeStar Services to see if they are running as services or console (Notification, Document and Transaction)"
    Write-host "rebuild                                 | Rebuild ScribeStar Solutions"
    Write-host "debugweb                                | Debug ScribeStar Instance"
    Write-host "debugdoc                                | Debug ScribeStar Document Service"
    Write-host "Compass-Compile                         | o 0"
    Write-host "Build-ScribeStarSolution                | Just do a debug guild of instance.sln"
    Write-host "Test-Instance                           | nunit test all of ScribeStar.Instance.Tests"
    Write-host "Test-InstanceAndWeb                     | nunit test ScribeStar.Instance.Tests and ScribeStar.Instance.Web.Tests"
    Write-host "Test-Importer                           | nunit test just Word Importer namespace"
    Write-host "Test-Messages                           | nunit test ScribeStar.Messages.Tests"
    Write-host "Test-WholeSuite                         | nunit test the kitchen sink"
    Write-host "Test-DocumentAndChangeset               | nunit test ScribeStar.Document.Tests and ScribeStar.Document.Changeset.Tests"
    Write-host "Test-CentralAndCore                     | nunit test ScribeStar.Central.Tests and ScribeStar.Core.Tests"
    Write-host "curl -Uri `"http://localhost:8080/static/?start=0&pagesize=128`" -Method GET  | list all attachments in local ravendb"
    Write-Host "gci D:\Work\Product\instance\scribestar.web\sass\styles -recurse | Select-String -Pattern `"pattern`" | look for pattern in sass files recursively"
}
