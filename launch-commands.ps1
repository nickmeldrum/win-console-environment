Set-Alias g git

Set-Alias sublime "C:\Program Files\Sublime Text 2\sublime_text.exe"
Set-Alias edit "C:\Program Files\Sublime Text 2\sublime_text.exe"
Set-Alias mdo "C:\Program Files (x86)\MarkdownPad 2\MarkdownPad2.exe"
Set-Alias music "C:\Users\nick.meldrum\AppData\Local\Amazon Music\Amazon Music.exe"
Set-Alias rdp "mstsc.exe"

function Get-MinecraftDir {
    c:
    cd "~\appdata\roaming\.minecraft\saves"
}
Set-Alias mine Get-MinecraftDir

function Chrome {
    param ([string]$url)

    ."C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --profile-directory="$($localConfig.defaultChromeProfile)" $url
}

function Google {
    param ([string]$search)

    Chrome  "https://www.google.co.uk/#q=$search"
}

function StackOverflow {
    param ([string]$search)

    Chrome  "https://stackoverflow.com/search?q=$search"
}

function Reload-Profile {
    . "~/documents/windowspowershell/profile.ps1"
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
    write-host "Chrome x                      | open browser with specific profile"
    write-host "Google x                      | search google"
    write-host "StackOverflow x               | search stack overflow"
    write-host "explorer x                    | open windows explorer at location x"
    write-host "music                         | amazon music"
    write-host "rdp                           | remote desktop connection"
    write-host "mine                          | go to minecraft dir"
    write-host "rlp, ep                       | reload this profile, echo profile commands"
    write-host "(curl -uri `"www.etsy.com`").content > page.html | vim page.html | get html contents of page and load that file into vim"
}
