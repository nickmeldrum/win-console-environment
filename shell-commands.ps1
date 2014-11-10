function Write-Title {
	param (
		[string]$message
	)

	write-host $message -ForegroundColor cyan
}

function Get-Time {
    cmd /c time /t
}

function Write-Subtitle {
    param (
        [string]$message
    )

    Write-Host $message -ForegroundColor DarkCyan
}

function List-Colors {
    Write-Title "Powershell console colors:"

    write-host " | White: " -nonewline
    write-host "White" -ForegroundColor White -nonewline
    write-host " | Gray: " -nonewline
    write-host "Gray" -ForegroundColor Gray -nonewline
    write-host " | DarkGray: " -nonewline
    write-host "DarkGray" -ForegroundColor DarkGray -nonewline
    write-host "| Black: " -nonewline
    write-host "Black" -ForegroundColor Black -nonewline

    write-host " | Blue: " -nonewline
    write-host "Blue" -ForegroundColor Blue -nonewline
    write-host " | DarkBlue: " -nonewline
    write-host "DarkBlue" -ForegroundColor DarkBlue -nonewline
    write-host " | Cyan: " -nonewline
    write-host "Cyan" -ForegroundColor Cyan -nonewline
    write-host " | DarkCyan: " -nonewline
    write-host "DarkCyan" -ForegroundColor DarkCyan -nonewline
    write-host " | Green: " -nonewline
    write-host "Green" -ForegroundColor Green -nonewline
    write-host " | DarkGreen: " -nonewline
    write-host "DarkGreen" -ForegroundColor DarkGreen -nonewline
    write-host " | DarkYellow: " -nonewline
    write-host "DarkYellow" -ForegroundColor DarkYellow -nonewline
    write-host " | Yellow: " -nonewline
    write-host "Yellow" -ForegroundColor Yellow -nonewline
    write-host " | Red: " -nonewline
    write-host "Red" -ForegroundColor Red -nonewline
    write-host " | DarkRed: " -nonewline
    write-host "DarkRed" -ForegroundColor DarkRed -nonewline
    write-host " | Magenta: " -nonewline
    write-host "Magenta" -ForegroundColor Magenta -nonewline
    write-host " | DarkMagenta: " -nonewline
    write-host "DarkMagenta" -ForegroundColor DarkMagenta -nonewline

    write-host " |"
}

# For when you've cloned into a directory with the same name as parent directory
# creating a folder heirachy pointlessly deep argh
function Move-AllItemsToParentDir {
    throw [System.NotImplementedException]
}

function Create-TextFile {
    param (
        [string]$filename,
        [string]$text
    )

    New-Item $filename -type file -force -value $text
}

Set-Alias copycon Create-TextFile

function Copy-CurDirToClipboard {
    $pwd.Path | clip
}

Set-Alias copydir Copy-CurDirToClipboard

function Echo-ShellCommands {
    Write-Title "Shell Commands and useful commands to remember:"

    Write-Host "copycon x y                             | Create a text file with the filename x and text y"
    Write-Host "Move-Al ItemsToParentDir                | Does what it says on the tin (and deletes current dir!)"
    Write-Host "x | clip, copydir                       | copy to clipboard, copy current directory"
    Write-Host "pushd and popd                          | push and pop directories from stack"    
    Write-Host "Show-Time                               | output current time"
}

function Echo-VimCommands {
    Write-Title "Vim commands:"

    Write-Subtitle "Moving around file:"
    Write-Host ":n or ngg                               | Goto line n"

    Write-Subtitle "Search and replace:"
    Write-Host "/search                                 | Search in file for text"
    Write-Host "/search/e                               | Search in file for text and place cursor at end of search text"
    Write-Host "?search                                 | Search backwards in file for text"
    Write-Host "n                                       | Repeat search"
    Write-Host "N                                       | Repeat search backwards"
    Write-Host ":s/search/replace/                      | Search and replace in line and replace 1st match"
    Write-Host ":8,10 s/search/replace/g                | Search and replace each match in range (line numbers)"
    Write-Host ":'<,'>s/search/search/g                 | Search and replace each match in range selected via visual mode (visually select range then hit :)"
    Write-Host ":%s/search/replace/g                    | Search and replace globally in whole file"

    Write-Subtitle "Swapping text:"
    Write-Host "xp                                      | Swap the current character (the character under the cursor) with the next"
    Write-Host "Xp                                      | Swap the current character with the previous"
    Write-Host "dawwP                                   | Swap the current word with the next"
    Write-Host "dawbP                                   | Swap the current word with the previous"    
    Write-Host "ddp                                     | Swap the current line with the next"
    Write-Host "ddkP                                    | Swap the current line with the previous"    
}

Set-Alias echovim Echo-VimCommands

