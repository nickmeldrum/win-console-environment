Set-Alias g git

Set-Alias sublime "C:\Program Files\Sublime Text 2\sublime_text.exe"
Set-Alias edit "C:\Program Files\Sublime Text 2\sublime_text.exe"
Set-Alias mdo "C:\Program Files (x86)\MarkdownPad 2\MarkdownPad2.exe"
Set-Alias music "C:\Users\nick.meldrum\AppData\Local\Amazon Music\Amazon Music.exe"
Set-Alias rdp "mstsc.exe"

function Get-MinecraftDir {
    c:
    cd c:\users\nick\appdata\roaming\.minecraft\saves
}
Set-Alias mine Get-MinecraftDir

function Google {
    Start chrome "https://www.google.co.uk/#q=`"$args`""
}

function EditorKarma {
    sseditordir
    node .\node_modules\karma\bin\karma start
    #karma start
}

function Reload-Profile {
    . $profile
}
function Echo-Profile {
    Echo-VimCommands
    Echo-GitCommands
    Echo-DotnetCommands
    Echo-SystemCommands
    Echo-LaunchCommands
    Echo-ShellCommands
    Echo-ScribestarCommands
}

Set-Alias rlp Reload-Profile
Set-Alias ep Echo-Profile

function Echo-LaunchCommands {
    Write-Title "Launch commands:"

    write-host "edit x                        | edit x in sublime text"
    write-host "mdo x                         | edit x in markdownpad"
    write-host "start chrome                  | open browser"
    write-host "explorer x                    | open windows explorer at location x"
    write-host "music                         | amazon music"
    write-host "rdp                           | remote desktop connection"
    write-host "mine                          | go to minecraft dir"
    write-host "rlp, ep                       | reload this profile, echo profile commands"
    write-host "(curl -uri `"www.etsy.com`").content > page.html | vim page.html | get html contents of page and load that file into vim"
}
