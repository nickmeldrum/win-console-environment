set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
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
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'isRuslan/vim-es6'
call vundle#end()

filetype plugin indent on

set diffopt+=vertical

:set laststatus=2

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=Red ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=LightYellow ctermfg=8 guifg=Black ctermbg=15

set statusline=%f         " Path to the file
set statusline+=\      " Separator
set statusline+=%y        " Filetype of the file
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=\      " Separator
set statusline+=%c    " Current col
set statusline+=/    " Separator
set statusline+=%l    " Current line
set statusline+=/    " Separator
set statusline+=%L   " Total lines
set statusline+=\      " Separator
set statusline+=%{fugitive#statusline()} "git status

"gvim stuff
set guioptions -=m
set guioptions -=T
set guifont=Consolas:h12:cANSI
set guioptions -=r
set guioptions -=R
set guioptions -=l
set guioptions -=L

set autoread

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

" so gf knows some files might not include the .js extension in the script
set suffixesadd+=.js

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

set wildignore+=node_modules/**
set wildignore+=packages/**
set wildignore+=3rdparty/**
set wildignore+=bower_components/**
set wildignore+=coverage/**
set wildignore+=tags
set wildignore+=target/**
set wildignore+=.teamcity/**

let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|teamcity|vs)$\|node_modules$\|bower_components$\|packages$\|3rdparty$\|coverage$\|target$',
  \ 'file': '\v\.(exe|so|dll|class)$'
  \ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Ignore case when searching
set ignorecase
set smartcase
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch

" No annoying sound on errors
set noerrorbells
set t_vb=
set tm=500
command! Nob set vb t_vb=
set vb t_vb=
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

" evil remaps from hell
nnoremap ' `
nnoremap ` '

nnoremap ; :
nnoremap : ;

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

" python stuff
autocmd! FileType python nnoremap <buffer> <F9> :w !python<CR>
 
" markdown stuff
autocmd! BufNewFile,BufReadPost *.md set filetype=markdown

" tabbing
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" color scheme for conemu (256 colors)
if has("gui_running")
else
    set term=xterm
endif
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
"colorscheme zenburn
"colorscheme distinguished
colorscheme kolor

inoremap jk <ESC>

" commands
command! SsWeb cd D:\Prod\src\Web
command! SsScripts cd D:\Prod\src\Web\scripts\Scribestar
command! SsRoot cd D:\Prod

function! DeleteNextEmptyLine()
    :normal mz
    /^\s*$\n/
    :normal dgn
    :normal 'z
endfunction

command! Delnel call DeleteNextEmptyLine()

function! AutoIndentFile()
    :normal mzgg=G'z
endfunction

command! AI call AutoIndentFile()

function! RemoveTrailingWhitespaceFromFile()
    :let _s=@/
    :%s/\s\+$//e
    :let @/=_s
endfunction

command! RTW call RemoveTrailingWhitespaceFromFile()

function! AddCatchToEndOfThen()
    :%s/^\(\s*\)});/\1})\r\1.catch((err) => { window.console.error(err);});/gc
endfunction

"following is a copy of my i register that allows me to turn requires into
"imports in js
"cwimportf=vf(cfrom f)dl

autocmd! BufWritePre *.js :call RemoveTrailingWhitespaceFromFile() | :call AutoIndentFile()

nmap <C-A> mzggvG

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
autocmd! bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

set foldmethod=indent

