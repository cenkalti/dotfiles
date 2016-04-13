" vim-plug
call plug#begin()
Plug 'rking/ag.vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'benekastah/neomake'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'zchee/deoplete-jedi'
Plug 'raimondi/delimitmate'
Plug 'Shougo/deoplete.nvim'
Plug 'davidhalter/jedi-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'blueyed/vim-diminactive'
Plug 'easymotion/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'bronson/vim-trailing-whitespace'
call plug#end()

" color theme
set background=dark
let base16colorspace=256
colorscheme base16-solarized

" basic vim settings
set showcmd
set relativenumber
set splitbelow
set splitright
set cursorline
set ignorecase
set smartcase
set showmatch

" fzf
set rtp+=/usr/local/opt/fzf

" force yaml syntax on sls files
au BufNewFile,BufRead *.sls set filetype=yaml

" shortcuts
let mapleader="\<SPACE>"
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g :GitFiles<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>` :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <Leader>l :nohlsearch<CR>
nnoremap <Leader>m :Neomake<CR>

" split navigations
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-o> <C-w>o
nnoremap <C-c> <C-w>c

" override plugin options
let g:signify_update_on_focusgained = 1
let g:deoplete#enable_at_startup = 1
let g:airline_powerline_fonts = 1
let g:buffergator_viewport_split_policy = "B"

" jedi
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#completions_enabled = 0
autocmd FileType python setlocal completeopt-=preview
nnoremap <leader>a :call jedi#goto_assignments()<CR>
nnoremap <leader>d :call jedi#goto_definitions()<CR>
nnoremap <leader>u :call jedi#usages()<CR>
nnoremap <leader>r :call jedi#rename()<CR>
