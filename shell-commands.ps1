function Write-Title {
	param (
		[string]$message
	)

	write-host $message -ForegroundColor cyan
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

    write-host "copycon x y                   | Create a text file with the filename x and text y"
    write-host "Move-Al ItemsToParentDir      | Does what it says on the tin (and deletes current dir!)"
    write-host "x | clip, copydir             | copy to clipboard, copy current directory"
    write-host "pushd and popd                | push and pop directories from stack"    
}
