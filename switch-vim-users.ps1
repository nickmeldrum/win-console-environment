function idempotent-gitupdate {
    param ([string]$repo, [string]$localpath)

    pushd
    if (-not (test-path $localpath)) {
        write-host "getting $localpath repository..."
        git clone $repo $localpath
        cd $localpath
    }
    else {
        write-host "updating $localpath repository..."
        cd $localpath
        git pull
    }
    popd
}

function update-vundled-vim {
    if (-not (test-path "~/.vim/bundle")) {
        mkdir ~/.vim/bundle
    }

    pushd
    cd ~/.vim/bundle
    idempotent-gitupdate https://github.com/gmarik/Vundle.vim.git Vundle.vim
    vim +PluginClean +qall
    vim +PluginInstall +qall
    vim +PluginClean +qall
    popd
}

function setup-vim-user {
    param ([string]$repo, [string]$foldername)

    idempotent-gitupdate $repo $foldername

    mv ~/.vimrc ~/.vimrc.bak -ErrorAction SilentlyContinue
    mv $foldername\.vimrc ~/.vimrc -force

    update-vundled-vim
}

function setup-rob {
    setup-vim-user https://github.com/Rob-H/dotfiles/ d:\robsfiles
}

function setup-nick {
    setup-vim-user https://github.com/nickmeldrum/win-console-environment/ d:\env
}

