" vim-plug
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'altercation/vim-colors-solarized'
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree'
Plug 'rking/ag.vim'
Plug 'mhinz/vim-signify'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" solarized
syntax enable
set background=dark
colorscheme solarized

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" airline
let g:airline#extensions#tabline#enabled = 1

" basic vim settings
set relativenumber
set splitbelow
set splitright
let mapleader="\<SPACE>"
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
nnoremap ; :

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

