set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'zeis/vim-kolor'
Plugin 'tpope/vim-markdown'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'tpope/vim-surround'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'PProvost/vim-ps1'
Plugin 'mhinz/vim-startify'
Plugin 'scrooloose/nerdtree'
Plugin 'rbgrouleff/bclose.vim'
"Plugin 'airblade/vim-gitgutter'
Plugin 'mhinz/vim-grepper'
Plugin 'mattn/emmet-vim'
"Plugin 'marijnh/tern_for_vim'
"Plugin 'Valloric/YouCompleteMe'
call vundle#end()

filetype plugin indent on

" turn off auto backing up - using google drive or git anyway right? :)
set nobackup
set noswapfile
set nowb

" buffers can exist in background
set hidden

" map control -n to next buffer
:nnoremap <C-n> :bnext<CR>

" Open markdown files with Chrome.
"autocmd BufEnter *.md exe 'noremap <F5> :!start chrome "%:p"<CR>'

" allow spell check
"set spell
"set spelllang=en

" line numbers
" set nu
set relativenumber

" turn off word wrapping
set nowrap

" show line and column markers
"set cursorline
"set cursorcolumn

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
set t_vb=
set tm=500
command Nob set vb t_vb=
set visualbell

" Line Numbers
set number

" Enable syntax highlighting
syntax enable
filetype on
au BufNewFile,BufRead *.cshtml set filetype=html
au BufNewFile,BufRead *.ejs set filetype=html

" Who doesn't like autoindent?
set autoindent

:nnoremap ' `
:nnoremap ` '

:nnoremap ; :
:nnoremap : ;

" when :vs the loaded file will show up on the right
set splitright

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" tabbing
set smarttab
set shiftwidth=4
set tabstop=4
" Use spaces instead of tabs
set expandtab

" javascript omnicompletion
" autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

"ctrl-p stuff
let g:ctrlp_custom_ignore = 'node_modules\|.git\|bower_components\|packages|3rdparty'
let g:ctrlp_working_path_mode = 'r'

" python stuff
autocmd FileType python nnoremap <buffer> <F9> :w !python<CR>
 
" markdown stuff
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" tabbing
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" color scheme for conemu (256 colors)
set term=xterm
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
"colorscheme zenburn
"colorscheme distinguished
colorscheme kolor

" key mappings
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

" commands
command SsWeb cd D:\Prod\src\ScribeStar.Web | !ctags -R .
command SsRoot cd D:\Prod | !ctags -R .

function! DeleteNextEmptyLine()
    :normal mz
    /^\s*$\n/
    :normal dgn
    :normal 'z
endfunction

command! Delnel call DeleteNextEmptyLine()

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

" nerdtree stuff
" close vim if nerdtree only window left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
