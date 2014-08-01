function WriteUnderlined-Host {
	param (
		[string]$message
	)

    write-host
	write-host $message -ForegroundColor cyan
	write-host ("=" * $message.Length) -ForegroundColor darkcyan
}

WriteUnderlined-Host "Shell Commands and useful commands to remember:"

function List-Colors {
    write-host "Black | DarkBlue | DarkGreen | DarkCyan | DarkRed | DarkMagenta | DarkYellow | Gray | DarkGray | Blue | Green | Cyan | Red | Magenta | Yellow | White"
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

write-host "copycon x y                   | Create a text file with the filename x and text y"
write-host "Move-AllItemsToParentDir      | Does what it says on the tin (and deletes current dir!)"
write-host "`"x | clip`"                    | copy to clipboard"
write-host "`"cd | clip`"                   | copy current dir to clipboard"
write-host "pushd and popd                | push and pop directories from stack"
