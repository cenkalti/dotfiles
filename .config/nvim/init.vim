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
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdcommenter'
call plug#end()

" color theme
syntax enable
set background=dark
let base16colorspace=256 
colorscheme base16-solarized

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" airline
let g:airline#extensions#tabline#enabled = 1

" startify
highlight StartifyBracket ctermfg=240
highlight StartifyFooter  ctermfg=240
highlight StartifyHeader  ctermfg=114
highlight StartifyNumber  ctermfg=215
highlight StartifyPath    ctermfg=245
highlight StartifySlash   ctermfg=240
highlight StartifySpecial ctermfg=240

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

