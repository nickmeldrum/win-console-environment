param([string]$commitmsg)

function copyfileifunaltered {
    param ($filename, $localLocation)


    if (-not [string]::isnullorwhitespace((git status --porcelain | grep "$filename"))) {
        return "$filename altered in local git, please push local changes first. not copying over..."
    }
    else {
        echo "copying $filename to $locallocation..."
        copy $localLocation "./$filename" -force
    }
}

copyfileifunaltered ".vimrc" "~/.vimrc"
copyfileifunaltered ".npmrc" "~/.npmrc"
#copyfileifunaltered ".gitconfig" "~/.gitconfig"
#copyfileifunaltered "localconfig.json" "~/localconfig.json"
copyfileifunaltered "autohotkey.ahk" "~/Documents/autohotkey.ahk"
copyfileifunaltered "snippets/javascript.snippets" "~/vimfiles/snippets/javascript.snippets"

if (-not [string]::isnullorwhitespace($commitmsg)) {
    echo "commit msg passed in, attempting to commit and push..."
    git add .
    git commit -v -m $commitmsg
    git push
}
else {
    echo "no commit msg passed in, please manually commit and push..."
    git status
}
