function Write-Title {
	param (
		[string]$message
	)

	write-host $message -ForegroundColor cyan
}

function fortune {
    [System.IO.File]::ReadAllText($localconfig.envrepo +'\fortune.txt') -replace "`r`n", "`n" -split "`n%`n" | Get-Random
}

function Get-ModuleVerbs {
    get-verb | sort verb | format-wide -property verb -column 8
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

function Kill-MsBuild {
    get-process "msbuild" | kill
}

function Kill-Node {
    get-process "node" | kill
}

Set-Alias killnode Kill-Node
Set-Alias killmsbuild Kill-MsBuild

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

function JsGrep {
    param (
        [string]$text
    )

    grep -i -n -r $text *.js .
}

function sw {
    return [system.diagnostics.stopwatch]::startNew();
}

function alarm {
    param (
            [int]$period,
            [string]$message
          )
    echo "alarm set for $period minutes with msg [$message]"
    $sw = sw
    $sw.reset()
    $sw.start()
    while ($sw.elapsed.minutes –lt $period) {$null};
    [System.Windows.Forms.MessageBox]::Show($message, "Alarum") 
    $sw.stop()
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


    Write-Host "Vim shortcuts"

    Write-Host "Help"
    Write-Host ":help command will open up vim help in a split about that command"

    Write-Host "Splits"
    Write-Host ":sp or ctrl-w n or v to create a new split normal or vertical"
    Write-Host "ctrl-w <dir> move between splits"
    Write-Host "ZQ or ZZ close current window either saving or not saving respectively"
    Write-Host "ctrl-w q close current split"
    Write-Host ":on or ctrl-w o make current window the only visible window"

    Write-Host "Opening files"
    Write-Host ":new"
    Write-Host ":edit"
    Write-Host ":tabe"
    Write-Host ":find **\Dom** find any file with Dom at the start of the name and open it"

    Write-Host "Tabs"
    Write-Host ":tabe or :tabnew file open a file in a new tab (edit or new)"
    Write-Host ":tabf for find a file and open in new tab"
    Write-Host ":tabn or gt goto next tab"
    Write-Host ":tabp or :tabN for previous and next tab"
    Write-Host ":tabc tabclose"
    Write-Host ":tabo close all other tabs"

    Write-Host "quitting"
    Write-Host ":q! quit without saving (or close current tab)"
    Write-Host ":wq write and quit"
    Write-Host ":w write with optional filename"

    Write-Host "cut copy paste"
    Write-Host "v visual mode"
    Write-Host "shift-v select whole lines"
    Write-Host "ctrl-v select columns"

    Write-Host "y yank"
    Write-Host "x cut (yank and delete)"
    Write-Host "p put"
    Write-Host "`"<n>y store the yank in buffer n"
    Write-Host "`"* is the special clipboard buffer" 

    Write-Host "Macros"
    Write-Host "q<n> start recording into buffer n"
    Write-Host "@<n> replay recording in buffer n"

    Write-Host "Working Directory"
    Write-Host ":pwd display it"
    Write-Host ":cd %:p:h set pwd to current files dir"

    Write-Host ":noh turn off last search highlighting"
    Write-Host ":source ~/.vimrc reload vimrc without restarting vim"
    Write-Host "dab `"delete arounb brackets`", daB for around curly brackets, t for xml type tags, combinations with normal commands are as expected cib/yaB/dit/vat etc"
    Write-Host ":earlier 15m :later n - revert the document to a time in the past (later moves it back forward)"
    Write-Host ":.! ls - dump output from command into editor"
    write-host
    write-host "vim surround stuff:"
    write-host "S<p class='important'> = surround selected text in Visual mode with <p class='important'>something selected</p>"
    write-host "cs`"' change surrounding double quotes to single"
    write-host "ds`" to remove quote delimiters"
    write-host "ysiw[ = surround a word with [ word ]"
    write-host "ysiw] = surround a word with [word]"

    write-host "zg add word under cursor as good"
    write-host "zw add word under cursor as bad"
    write-host "z= suggestions"
    write-host ";spellr repeat z= suggestion done for all matches in current window"
}

Set-Alias echovim Echo-VimCommands

