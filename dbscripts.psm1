# How to use this Powershell Module:
# copyp this file into your directory: C:\Users\<username>\Documents\WindowsPowerShell\Modules
# (or to C:\Windows\System32\WindowsPowerShell\v1.0\Modules if you are running it on a build server (noninteractive etc.))
# (check $env:psmodulepath variable for the list of places powershell looks for modules)
#
# Then import it with the command: "Import-Module dbscripts"
#
####################################################################
########
######## Neo4J Stuff
########
####################################################################

$script:cypherQueries = @{
    "return-all" = "MATCH (n) return n;";
    "delete-all" = "MATCH (n) OPTIONAL MATCH (n)-[r]-()  DELETE n, r;";
    "all-doc-nodes-by-master-branch-id" = "match (root {Name: `"Master`"}) -[*0..7]- children where id(root) = {0} return root, children;";
}

$script:neoUrl = "http://localhost:7474/db/data/"
$script:ravenDbUrl = "http://localhost:8080/"
$script:sqlServer = "localhost"
$script:sqlDatabase = "scribestar"

Function Set-Neo4jUrl {
<#
    .SYNOPSIS 
        Set the Url to the Neo4j REST API that the Neo4j functions use internally (can be retrieved using Get-Neo4jUrl)
#>
    param ([string]$url)

    $script:neoUrl = $url
}

Function Get-Neo4jUrl {
<#
    .SYNOPSIS 
        Retrieve the Url to the Neo4j REST API that the Neo4j functions use internally (can be set using Set-Neo4jUrl)
#>
     return $script:neoUrl
}

Function Get-Neo4jCypherQueries {
<#
    .SYNOPSIS 
        List some common cypher queries as strings you could pass into Request-Neo4jCypher
#>
    return $script:cypherQueries
}

Function Request-Neo4jRest {
<#
    .SYNOPSIS 
        Make a Neo4j REST Api call (typically used by other dbscript module functions but exposed for completeness)
#>
    param ([string]$query, [string]$method, [string]$body)
    
    if ([string]::IsNullOrWhitespace($body)) {
        return (Invoke-WebRequest -Uri ($neoUrl + $query) -Method $method -ContentType "application/json")
    }
    else {
        return (Invoke-WebRequest -Uri ($neoUrl + $query) -Method $method -ContentType "application/json" -Body $body)
    }
}

Function Add-Neo4jNode {
<#
    .SYNOPSIS 
    Add a Node to the Neo4j graph optionally passing a hashtable of properties
    .EXAMPLE
    Add-Node @{"Name" = "Master"; "BranchType" = "Master"}"
#>
    param ([hashtable]$properties)

    Request-Neo4jRest "node" "Post" ($properties | ConvertTo-Json -Depth 10)
}

Function Get-Neo4jNode {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node)

    Request-Neo4jRest "node/$node" "Get"
}

Function Remove-Neo4jNode {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node)

    Request-Neo4jRest "node/$node" "Delete" ""
}

Function Add-Neo4jNodeLabel {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node, [array]$labels)

    Request-Neo4jRest "node/$node/labels" "Post" ($labels | ConvertTo-Json -Depth 10)
}

Function Get-Neo4jNodeLabels {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node)

    Request-Neo4jRest "node/$node/labels" "Get" ""
}

Function Remove-Neo4jNodeLabel {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node, [string]$label)

    Request-Neo4jRest "node/$node/labels/$label" "Delete" ""
}

Function Add-Neo4jNodeProperties {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node, [hashtable]$properties)

    Request-Neo4jRest "node/$node/properties" "Put" ($properties | ConvertTo-Json -Depth 10)
}

Function Get-Neo4jNodeProperties {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node)

    Request-Neo4jRest "node/$node/properties" "Get"
}

Function Remove-Neo4jNodeProperties {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node)

    Request-Neo4jRest "node/$node/properties" "Delete" ""
}

Function Set-Neo4jNodeProperty {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node, [string]$name, [string]$value)

    Request-Neo4jRest "node/$node/properties/$name" "Put" ($value | ConvertTo-Json -Depth 10)
}

Function Remove-Neo4jNodeProperty {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$node, [string]$name)

    Request-Neo4jRest "node/$node/properties/$name" "Delete"
}

Function Add-Neo4jRelationship {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$from, [int]$to, [string]$type)

    $body = @{"to" = $neoUrl + "node/$to"; "type" = $type} | ConvertTo-Json -Depth 10
    Request-Neo4jRest "node/$from/relationships" "Post" $body
}

Function Get-Neo4jRelationship {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$rel)

    Request-Neo4jRest "relationship/$rel" "Get" ""
}

Function Remove-Neo4jRelationship {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$rel)

    Request-Neo4jRest "relationship/$rel" "Delete" ""
}

Function Add-Neo4jRelationshipProperties {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$rel, [hashtable]$properties)

    Request-Neo4jRest "relationship/$rel/properties" "Put" ($properties | ConvertTo-Json -Depth 10)
}

Function Get-Neo4jRelationshipProperties {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$rel)

    Request-Neo4jRest "relationship/$rel/properties" "Get" ""
}

Function Remove-Neo4jRelationshipProperties {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$rel)

    Request-Neo4jRest "relationship/$rel/properties" "Delete" ""
}

Function Set-Neo4jRelationshipProperties {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$rel, [string]$name, [string]$value)

    Request-Neo4jRest "relationship/$rel/properties/$name" "Put" ($value | ConvertTo-Json -Depth 10)
}

Function Remove-Neo4jRelationshipProperty {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([int]$rel, [string]$name)

    Request-Neo4jRest "relationship/$rel/properties/$name" "Delete"
}

Function Request-Neo4jCypher {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([string]$query)

    $queryJson = @{"query" = $query} | ConvertTo-Json -Depth 10
    return (Request-Neo4jRest "cypher" "Post" $queryJson) | ConvertFrom-Json
}

Function Get-AllNeo4jNodes {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    return (Request-Neo4jCypher $cypherQueries["return-all"]).data
}

Function Clear-Neo4jGraph {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    Request-Neo4jCypher $cypherQueries["delete-all"]
}

Function Remove-Neo4jDatabase {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    Stop-Service neo4j-server
    Remove-Item C:\Neo4j\neo4j-community-2.1.5\data\graph.db -force -recurse
    Start-Service neo4j-server
}

####################################################################
########
######## RavenDb Stuff
########
####################################################################

Function Set-RavenDbUrl {
    param ([string]$url)

    $script:ravenDbUrl = $url
}

Function Get-RavenDbUrl {
     return $script:ravenDbUrl
}

Function Request-RavenDb {
<#
    .SYNOPSIS 
        Make a RavenDb REST Api call (typically used by other dbscript module functions but exposed for completeness)
#>
    param ([string]$query, [string]$method, [string]$body)
    
    if ([string]::IsNullOrWhitespace($body)) {
        return Invoke-WebRequest -Uri ($ravenDbUrl + $query) -Method $method
    }
    else {
        return Invoke-WebRequest -Uri ($ravenDbUrl + $query) -Method $method -ContentType "application/json" -Body $body
    }
}

Function Get-RavenDbData {
    param ([string]$query, [string]$method, [string]$body)

    (Request-RavenDb $query $method $body).Content | ConvertFrom-Json
}

Function Get-RavenDbDocument {
    param ([string]$database, [string]$collection, [string]$documentId)

    Get-RavenDbData "databases/$database/docs/$collection/$documentId" "Get"
}

Function Get-AllRavenDbDocumentsByName {
    param ([string]$database, [string]$entityName)

    (Get-RavenDbData "databases/$database/indexes/Raven/DocumentsByEntityName?query=Tag:$entityName" "get").results
}

Function Get-AllRavenDbDocuments {
    param ([string]$database)

    Get-AllRavenDbDocumentsByName $database "Documents"
}

Function Get-AllRavenDbChangesets {
    param ([string]$database)

    Get-AllRavenDbDocumentsByName $database "Changesets"
}

Function Get-AllRavenDbVerificationItems {
    param ([string]$database)

    Get-AllRavenDbDocumentsByName $database "VerificationItems"
}

Function Get-RavenDbDatabases {
    Get-RavenDbData "databases" "Get"
}

Function Remove-RavenDbDatabase {
    param ([string]$database)

    echo "attempting to delete raven database $database..."
    (Request-RavenDb ("admin/databases/$database" + "?hard-delete=true") "Delete").StatusDescription
}

Function Remove-RavenDbDatabases {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    $databases = Get-RavenDbDatabases
    
    ForEach ($database in $databases) {
        Remove-RavenDbDatabase $database
    }
    echo "remember to do an Restart-WebAppPool Scribestar if you wanna access the website now, as it's now holding onto an invalid sessionfactory"
}

Function Restart-ScribestarWeb {
    Restart-WebAppPool Scribestar
    curl "https://development.scribestar.internal/"
    curl "https://development.scribestar.internal/htmldocument/preloaded/Mix-25-Pages"
}

####################################################################
########
######## Sql Stuff
########
####################################################################

Function Set-SqlProperties {
<#
    .SYNOPSIS 
        Set the Sqlserver and database used (defaults to localhost and scribestar respectively)
#>
    param ([string]$server = "localhost", [string]$database = "scribestar")

    $script:sqlServer = $server
    $script:sqlDatabase = $database
}

Function Get-SqlProperties {
<#
    .SYNOPSIS 
        Retrieve the SqlServer server and database properties the queries are using
#>
     return "$script:sqlServer,$script:sqlDatabase"
}

push-location
import-module sqlps -disablenamechecking
pop-location

Function Request-Sql {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([string]$query)

    Invoke-Sqlcmd $query -ServerInstance $script:sqlServer -Database $script:sqlDatabase
}

Function Get-SqlTables {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    Request-Sql sp_tables | where {$_.table_type -eq "table" -and $_.table_owner -eq "dbo"} | select table_name
}

Function Get-SqlColumns {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([string]$table)

    Request-Sql "sp_columns `"$table`" " | format-table
}

Function Get-SqlUser {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([string]$id)

    Request-Sql "SELECT * FROM [User] where UniqueReference = '$id'"
}

Function Get-SqlDocument {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    param ([string]$name)

    Request-Sql "select top 10 * from document where name like '%$name%'"
}

Function Set-AllSqlPasswordsToScribestar {
<#
    .SYNOPSIS 
        Sets the password of all users on local scribestar instance to: Scr1best@r!
    .EXAMPLE
#>
    Request-Sql "update [user] set password = '`$2a`$10`$jrIF6vriQteOWfq7/jZ50.EfoUQxslhpCS0.grYgsxioEH9yM.wvi'"
}

Function Clear-SqlDocuments {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    Request-Sql @"
DELETE FROM ScribeStar.dbo.DocumentUserRole
go
DELETE FROM ScribeStar.dbo.Document
go
DELETE FROM ScribeStar.dbo.Task
go
"@
}

Function Remove-SqlDatabase {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    Request-Sql @"
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ScribeStar'
GO
USE [master]
GO
ALTER DATABASE [ScribeStar] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
DROP DATABASE [ScribeStar]
GO
"@
}

Function Publish-SqlSchema()
{
	Write-Host "Building the SqlServer Schema..."
    Write-Host "NOTE: Assumes you are in the root directory of the Scribestar Product repository"

	$environment="LOCAL"
	$roundHouseFilesDirectory = (Join-Path $pwd "src\database")
	$roundHouseExe = (Join-Path $pwd "src\database\tools\rh.exe")
	$databaseName="ScribeStar"
	$serverName="(local)"
	$versionFile = (Join-Path $pwd "src\database\_BuildInfo.xml")
	$versionXPath="//buildInfo/version"
	
	& $roundHouseExe /f $roundHouseFilesDirectory /d=$databaseName /s=$serverName /vf=$versionFile /vx=$versionXPath /env=$environment /drop /silent
	& $roundHouseExe /f $roundHouseFilesDirectory /d=$databaseName /s=$serverName /vf=$versionFile /vx=$versionXPath /env=$environment /silent
}

####################################################################
########
######## Combined stuff
########
####################################################################

Function Clear-AllDatabases {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    Clear-SqlDocuments
    Remove-RavenDbDatabases
    Clear-Neo4jGraph
}

Function Remove-AllDatabases {
<#
    .SYNOPSIS 
    .EXAMPLE
#>
    Remove-SqlDatabase
    Remove-RavenDbDatabases
    Remove-Neo4jDatabase
}

Function Get-RavenDbCommands {
    gcm -module dbscripts | select name | where {$_.name -like "*raven*"}
}

Function Get-Neo4jCommands {
    gcm -module dbscripts | select name | where {$_.name -like "*neo4j*"}
}

Function Get-SqlCommands {
    gcm -module dbscripts | select name | where {$_.name -like "*sql*"} | sort name
}

Function Get-AllCommands {
    gcm -module dbscripts | select name | sort name
}

