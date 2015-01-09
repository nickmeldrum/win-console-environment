set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
#Plugin 'tpope/vim-fugitive'
#Plugin 'kien/ctrlp.vim'
#Plugin 'zeis/vim-kolor'
call vundle#end()

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Line Numbers PWN!
set number

" Enable syntax highlighting
syntax enable

" Who doesn't like autoindent?
set autoindent

colorscheme desert
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

# make ; act as : - faster command typing
:nmap ; :

# colorscheme kolor

