syntax on

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set nowrap
set showmatch
set fileencoding=utf-8
set encoding=utf-8

filetype plugin indent on
au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" always enable the compiler plugin in Go source files
autocmd FileType go compiler go

