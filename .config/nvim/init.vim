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

" tagbar
map <C-t> :TagbarToggle<CR>

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
nnoremap <Leader>r :source %<CR>

" search
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
nnoremap <Leader>l :nohlsearch<CR>

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" split navigations
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <bs> <c-w>h " hack for neovim
nnoremap <c-h> <bs>

" force yaml syntax on sls files
au BufNewFile,BufRead *.sls set filetype=yaml

" signify
let g:signify_update_on_focusgained = 1

