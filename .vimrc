" load pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

" show line numbers
set number

" fix colors in terminal
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" index more files
let g:ctrlp_max_files = 100000

set gfn=Monaco:h12
"set tabstop=4
"set softtabstop=4
"set shiftwidth=4
"set expandtab

"set nowrap
"set showmatch
"set fileencoding=utf-8
"set encoding=utf-8

"au FileType py set autoindent
"au FileType py set smartindent
"au FileType py set textwidth=79

"autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" always enable the compiler plugin in Go source files
autocmd FileType go compiler go

"autocmd BufRead,BufNewFile *.go set filetype=go
"autocmd BufWritePre *.go Fmt
autocmd FileType go autocmd BufWritePre <buffer> Fmt
