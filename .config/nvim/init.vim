" vim-plug
call plug#begin()
Plug 'Shougo/deoplete.nvim'
Plug 'benekastah/neomake'
Plug 'bronson/vim-trailing-whitespace'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go'
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
Plug 'whatyouhide/vim-gotham'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go', { 'do': 'make'}
call plug#end()

" color theme
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme gotham

" basic vim settings
set hidden
set showcmd
set number
set splitbelow
set splitright
set ignorecase
set smartcase
set showmatch
let &colorcolumn="80,120"
set fillchars="vert: "

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
nnoremap <Leader>r :NERDTreeFind<CR>
nnoremap <Leader>o :BTags<CR>
nnoremap <leader>d :bp <BAR> bd #<CR>
autocmd FileType python map <buffer> <LocalLeader>a :call jedi#goto_assignments()<CR>
autocmd FileType python map <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
autocmd FileType python map <buffer> <LocalLeader>u :call jedi#usages()<CR>
autocmd FileType python map <buffer> <LocalLeader>r :call jedi#rename()<CR>

" window management
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" override plugin options
let NERDTreeIgnore = ['\.pyc$']
let g:signify_update_on_focusgained = 1
let g:deoplete#enable_at_startup = 1
let g:airline_powerline_fonts = 1
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep= ''
let g:airline_left_sep=''
let g:airline_right_sep=''
