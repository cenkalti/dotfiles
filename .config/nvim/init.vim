" vim-plug
call plug#begin()
Plug 'rking/ag.vim'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'chriskempson/base16-vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'easymotion/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-sleuth'
call plug#end()

" color theme
syntax enable
set background=dark
let base16colorspace=256
colorscheme base16-solarized

" fzf
set rtp+=/usr/local/opt/fzf

" nerdtree
nnoremap <Leader>q :NERDTreeToggle<CR>

" tagbar
nnoremap <Leader>p :TagbarToggle<CR>

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
nnoremap <Leader>b :ls<CR>:b<space>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g :GitFiles<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>r :source ~/.config/nvim/init.vim<CR>

" search
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
nnoremap <Leader>l :nohlsearch<CR>

" split navigations
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" force yaml syntax on sls files
au BufNewFile,BufRead *.sls set filetype=yaml

" signify
let g:signify_update_on_focusgained = 1
