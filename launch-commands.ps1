WriteUnderlined-Host "Launch commands:"

Set-Alias g git

Set-Alias sublime "C:\Program Files\Sublime Text 2\sublime_text.exe"
Set-Alias edit "C:\Program Files\Sublime Text 2\sublime_text.exe"
Set-Alias mdo "C:\Program Files (x86)\MarkdownPad 2\MarkdownPad2.exe"
Set-Alias music "C:\Users\Nick\AppData\Local\Amazon Music\Amazon Music.exe"
Set-Alias rdp "mstsc.exe"

function Get-MinecraftDir {
    c:
    cd c:\users\nick\appdata\roaming\.minecraft\saves
}
Set-Alias mine Get-MinecraftDir

function Reload-Profile {
    . $profile
}
Set-Alias c Reload-Profile

write-host "edit x                        | edit x in sublime text"
write-host "mdo x                         | edit x in markdownpad"
write-host "start chrome                  | open browser"
write-host "explorer x                    | open windows explorer at location x"
write-host "music                         | amazon music"
write-host "rdp                           | remote desktop connection"
write-host "mine                          | go to minecraft dir"
write-host "c                             | reload this profile"
