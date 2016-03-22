######
## Notes:
## Usually I write the functions I expect to be publicly used in a shorthand "non-powershelly" way and the private functions in the "powershell" horrible verb-noun style
##
## Pre-reqs:
## If your git repo is in a non-standard place (i.e. not "D:\Work\Product"): A global PS object called "localConfig" which has a property called "scribestarRepo" pointing to the root of your Git repo
## Standalone nunit 3.2.0 to be installed
## VS2015 to be installed in default place for msbuild
## To get the growl test integrations working you have to have Growl for Windows installed.
##
#####

function IfNull($a, $b, $c) { if ($a -eq $null) { $b } else { $c } }

$repoRoot = (IfNull $localConfig.scribestarRepo "D:\Work\Product" $localConfig.scribestarRepo)

#################################
### Directory traversal
#################################

function SsRootDir { cd $repoRoot }
function SsWebDir { cd "$($repoRoot)\src\Web" }
function SsScriptsDir { cd "$($repoRoot)\src\Web\scripts\scribestar" }
function SsCSSDir { cd "$($repoRoot)\src\Web\sass" }
function SsCollabDir { cd "$($repoRoot)\src\Collaboration" }
function SsCollabTestsDir { cd "$($repoRoot)\src\Collaboration.Tests" }
function SsCommentingDir { cd "$($repoRoot)\src\Commenting" }
function SsCommentingTestsDir { cd "$($repoRoot)\src\Commenting.Tests" }
function SsChecklistingDir { cd "$($repoRoot)\src\Checklisting" }
function SsChecklistingTestsDir { cd "$($repoRoot)\src\Checklisting.Tests" }
function SsVerificationDir { cd "$($repoRoot)\src\Verification" }
function SsVerificationTestsDir { cd "$($repoRoot)\src\Verification.Tests" }
function SsDiffDir { cd "$($repoRoot)\src\diff.service" }
function SsDiffTestsDir { cd "$($repoRoot)\src\Diff.Service.Tests" }

#################################
### Services
#################################

function StartSS { gsv | where {$_.name -like 'ScribeStar*'} | Start-Service; gsv | where {$_.name -like 'ScribeStar*'} }
function StopSS { gsv | where {$_.name -like 'ScribeStar*'} | Stop-Service; gsv | where {$_.name -like 'ScribeStar*'} }
function ListSS { gsv | where {$_.name -like 'ScribeStar*'}; Get-Process 'ScribeStar*' | Format-Table }

#################################
### Building
#################################

function Run-MsBuild
{
    param ($proj, $buildtype="build")
    & "C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild.exe" "$($repoRoot)\$proj" /t:$buildtype /p:SolutionDir="$($repoRoot)"
}

function build { stopss; Run-MsBuild "Scribestar.sln" }
function rebuild { stopss; Run-MsBuild "Scribestar.sln" "Rebuild" }
function buildweb { Run-MsBuild "src\Web\Web.csproj" }
function buildcollab { Run-MsBuild "src\Collaboration\Collaboration.csproj" }
function buildcollabtests { Run-MsBuild "src\Collaboration.Tests\Collaboration.Tests.csproj" }
function buildcomment { Run-MsBuild "src\Commenting\Commenting.csproj" }
function buildcommenttests { Run-MsBuild "src\Commenting.Tests\Commenting.Tests.csproj" }
function buildcheck { Run-MsBuild "src\Checklisting\Checklisting.csproj" }
function buildchecktests { Run-MsBuild "src\Checklisting.Tests\Checklisting.Tests.csproj" }
function buildver { Run-MsBuild "src\Verification\Verification.csproj" }
function buildvertests { Run-MsBuild "src\Verification.Tests\Verification.Tests.csproj" }

#################################
### Debugging
#################################

function Debug-WebProcessByOwner
{
    param ([string]$owner)
    add-type -AssemblyName microsoft.VisualBasic; add-type -AssemblyName System.Windows.Forms
    vsjitdebugger -p (gwmi win32_process | where {$_.Name -eq "w3wp.exe" -and $_.getowner().user -eq $owner}).ProcessId
    start-sleep -Milliseconds 500
    [Microsoft.VisualBasic.Interaction]::AppActivate("Visual Studio Just-In-Time Debugger")
    [System.Windows.Forms.SendKeys]::SendWait("(%P){END}(%M) ")
}

function debugweb { Debug-WebProcessByOwner "Scribestar" }
function debugcollab { Debug-WebProcessByOwner "Collaboration" }
function debugcomment { Debug-WebProcessByOwner "Commenting" }
function debugcheck { Debug-WebProcessByOwner "Checklisting" }
function debugver { Debug-WebProcessByOwner "Verification" }

#################################
### Testing
#################################

import-module $psscriptroot\send-growl.psm1
Register-GrowlType "Scribestar Server Tests" "Succeeded" "$psscriptroot\scribestar-tick.ico"
start-sleep -m 100
Register-GrowlType "Scribestar Server Tests" "Failed" "$psscriptroot\scribestar-cross.ico"

function Clean-AsmName {
    param ([string]$asmName)

    return [System.IO.Path]::GetFileNameWithoutExtension($asmName) -replace "(ScribeStar\.|\.Tests|\.Service|Proxy\.)*", ""
}

function Run-Nunit {
    param ([string[]]$assemblies, [string]$spec)
    $nunitPath = "`"C:\Program Files (x86)\NUnit.org\nunit-console\nunit3-console.exe`""

    if ($assemblies -eq $null -or $assemblies.Count -eq 0) {
        Throw "you must include an assembly!"
    }

    $argList = $assemblies -join " "

    if (![string]::IsNullOrWhitespace($spec)) {
        $argList = $argList += " /run=$spec"
    }

    echo "============================================"
    echo "Nunit command:"
    echo $argList
    echo "============================================"

    $command = $nunitPath + $argList
    iex "& $command"

    [xml]$testresults = cat .\TestResult.xml

    $succeeded = (select-xml "//test-run/@result" $testresults).Node."#text" -eq "Passed"
    $total = (select-xml "//test-run/@total" $testresults).Node."#text"
    $failedNumber = (select-xml "//test-case[@result='Failed']" $testresults).Length
    $passedNumber = (select-xml "//test-case[@result='Passed']" $testresults).Length
    $ignoredNumber = (select-xml "//test-case[@result='Skipped']" $testresults).Length

    $failedAssemblies = (select-xml "//test-suite[@result!='Passedd' and @type='Assembly']/@name" $testresults | % {clean-asmname $_.Node.'#text'}) -join ", "
    $failedTestNames = ((select-xml "//test-case[@result='Failed']" $testresults).Node.name) -join ", "
    $assertionFailures = ((select-xml "//test-case[@result='Failed']/failure/message/text()" $testresults).Node.Value) -join ", "

#    echo "succeeded $succeeded"
#    echo "total $total"
#    echo "failedNumber $failedNumber"
#    echo "passedNumber $passedNumber"
#    echo "ignoredNumber $ignoredNumber"
#    echo "failedAssemblies $failedAssemblies"
#    echo "failedTestNames $failedTestNames"
#    echo "assertionFailures $assertionFailures"

    if ($succeeded) {
        $type = "Succeeded"
        $caption = "Tests passed!"
        $msg = "$passedNumber/$total passed. $ignoredNumber ignored. Give yerself a pat on the back."
    }
    else {
        $type = "Failed"
        $caption = "Tests failed!"
        $msg = "$failedNumber/$total failed. Tests: $failedTestNames. Assertions: $assertionFailures"
    }

    Send-Growl "Scribestar Server Tests" $type $caption $msg
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

function testall { Run-Nunit (Get-AssemblyFromTestProjectFiles) }
function testall-execptseleniumorperf { Run-Nunit (Get-AssemblyFromTestProjectFiles -exclude "Automated") }
function testselenium { Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Automated") }
function testcollab { Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Collaboration") }
function testcheck { Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Checklisting") }
function testcomment { Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Commenting") }
function testver { Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Verification") }
function testdiff { Run-Nunit (Get-AssemblyFromTestProjectFiles -include "Diff") }

#################################
### Miscellaneous
#################################

function Make-DevCert
{
    makecert.exe -n "CN=Nicks Fake Root CA,O=Fake Company, OU=Development" -pe -ss Root -sr LocalMachine -sky exchange -m 120 -a sha1 -len 2048 -r
    makecert.exe -n "CN=development.scribestar.internal" -pe -ss My -sr LocalMachine -sky exchange -m 120 -in "Nicks Fake Root CA" -is Root -ir LocalMachine -a sha1 -eku 1.3.6.1.5.5.7.3.1
}

function Write-Title { param ([string]$message) write-host $message -ForegroundColor cyan }
function Write-SubTitle { param ([string]$message) write-host $message -ForegroundColor darkcyan }

function Echo-ScribestarCommands {
    Write-Title "Scribestar Commands:"

    Write-SubTitle "Change Directory Commands:"
    Write-Host "SsRootDir, SsWebDir, SsScriptsDir, SsCSSDir"
    Write-Host "SsCollabDir, SsCommentingDir, SsChecklistingDir, SsVerificationDir, SsDiffDir"
    Write-Host "SsCollabTestsDir, SsCommentingTestsDir, SsChecklistingTestsDir, SsVerificationTestsDir, SsDiffTestsDir"

    Write-SubTitle "Service Commands:"
    Write-Host "stopss, startss, listss"

    Write-SubTitle "Build Commands:"
    Write-Host "build, rebuild, buildweb, buildcollab, buildcollabtests, buildcomment, buildcommenttests, buildcheck, buildchecktests, buildver, buildvertests"

    Write-SubTitle "Debug Commands:"
    Write-Host "debugweb, debugcollab, debugcomment, debugcheck, debugver"

    Write-SubTitle "Test Commands:"
    Write-Host "testall, testall-exceptselenium, testselenium, testcollab, testcheck, testcomment, testver, testdiff"
    Write-Host "List-TestProjectFiles -include strarry -exclude strarray                    | List all test project files"
    Write-Host "Get-AssemblyFromTestProjectFiles -include strarray -exclude strarray        | List all tests assemblies to pass into Run-Nunit"
    Write-Host "Run-Nunit asmList namespace                                                 | Run unit tests, e.g. Run-Nunit `$asmList `"ScribeStar.Document.Service.Tests.SystemIntegrationTests`""

    Write-SubTitle "Misc helpful stuff:"
    Write-Host "curl -Uri `"http://localhost:8080/static/?start=0&pagesize=128`" -Method GET             | list all attachments in local ravendb"
    Write-Host "gci D:\prod\web\scribestar.web\sass\styles -recurse | Select-String -Pattern `"pattern`" | look for pattern in sass files recursively"
}
 
