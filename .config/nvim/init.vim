" vim-plug
call plug#begin()
Plug 'rking/ag.vim'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-sensible'
Plug 'wellle/targets.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'chriskempson/base16-vim'
call plug#end()

" color theme
syntax enable
set background=dark
let base16colorspace=256 
colorscheme base16-solarized

" fzf
set rtp+=/usr/local/opt/fzf

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" basic vim settings
set showcmd
set relativenumber
set splitbelow
set splitright
set cursorline
set cursorcolumn

" shortcuts
nnoremap ; :
let mapleader="\<SPACE>"
nnoremap <leader>b :ls<CR>:b
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g :GitFiles<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>r :source %<CR>

" search
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" tagbar
map <C-t> :TagbarToggle<CR>

