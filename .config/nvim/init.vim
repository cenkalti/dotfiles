" vim-plug
call plug#begin()
Plug 'Shougo/deoplete.nvim'
Plug 'benekastah/neomake'
Plug 'bronson/vim-trailing-whitespace'
Plug 'chriskempson/base16-vim'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'zchee/deoplete-jedi'
call plug#end()

" color theme
set background=dark
let base16colorspace=256
colorscheme base16-solarized

" basic vim settings
set showcmd
set number
set splitbelow
set splitright
set ignorecase
set smartcase
set showmatch
let &colorcolumn="80,120"

" fzf
set rtp+=/usr/local/opt/fzf

" force yaml syntax on sls files
au BufNewFile,BufRead *.sls set filetype=yaml

" shortcuts
let mapleader="\<SPACE>"
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g :GitFiles<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>` :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <Leader>l :nohlsearch<CR>
nnoremap <Leader>m :Neomake<CR>

" window management
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
let NERDTreeIgnore = ['\.pyc$']

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
