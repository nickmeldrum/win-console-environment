function copyfileifunaltered {
    param ($filename, $localLocation)

    echo "overwriting $filename to $locallocation..."
    copy "./$localLocation" $filename -force
}

copyfileifunaltered "~/.vimrc" ".vimrc"
copyfileifunaltered "~/.npmrc" ".npmrc"
copyfileifunaltered "~/Documents/autohotkey.ahk" "autohotkey.ahk"
copyfileifunaltered "~/vimfiles/snippets/javascript.snippets" "snippets/javascript.snippets"

