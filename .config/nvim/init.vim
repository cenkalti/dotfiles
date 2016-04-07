" vim-plug
call plug#begin()
Plug 'rking/ag.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-sensible'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'scrooloose/nerdtree'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'altercation/vim-colors-solarized'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/lightline.vim'
call plug#end()

" color theme
syntax enable
set background=dark
let base16colorspace=256 
colorscheme base16-solarized

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" startify
highlight StartifyBracket ctermfg=240
highlight StartifyFooter  ctermfg=240
highlight StartifyHeader  ctermfg=114
highlight StartifyNumber  ctermfg=215
highlight StartifyPath    ctermfg=245
highlight StartifySlash   ctermfg=240
highlight StartifySpecial ctermfg=240

" basic vim settings
set showcmd
set noshowmode
set relativenumber
set splitbelow
set splitright
set cursorline
set cursorcolumn
let mapleader="\<SPACE>"
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
nnoremap ; :

" search
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" tagbar
nmap <F8> :TagbarToggle<CR>

" fly between buffers
nnoremap <leader>l :ls<CR>:b<space>

