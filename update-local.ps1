function copyfileifunaltered {
    param ($filename, $localLocation)

    echo "overwriting $filename to $locallocation..."
    copy $localLocation "./$filename" -force
}

copyfileifunaltered ".vimrc" "~/.vimrc"
copyfileifunaltered ".npmrc" "~/.npmrc"
#copyfileifunaltered ".gitconfig" "~/.gitconfig"
#copyfileifunaltered "localconfig.json" "~/localconfig.json"
copyfileifunaltered "autohotkey.ahk" "~/Documents/autohotkey.ahk"
copyfileifunaltered "snippets/javascript.snippets" "~/vimfiles/snippets/javascript.snippets"

