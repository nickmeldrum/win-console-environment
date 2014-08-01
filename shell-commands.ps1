function WriteUnderlined-Host {
	param (
		[string]$message
	)

    write-host
	write-host $message -ForegroundColor cyan
	write-host ("=" * $message.Length) -ForegroundColor darkcyan
}

function List-Colors {
    write-host "Black | DarkBlue | DarkGreen | DarkCyan | DarkRed | DarkMagenta | DarkYellow | Gray | DarkGray | Blue | Green | Cyan | Red | Magenta | Yellow | White"
}