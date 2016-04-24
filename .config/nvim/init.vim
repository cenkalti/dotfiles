" vim-plug
call plug#begin()
Plug 'Shougo/deoplete.nvim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'benekastah/neomake'
Plug 'bronson/vim-trailing-whitespace'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'whatyouhide/vim-gotham'
Plug 'wellle/targets.vim'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'zchee/deoplete-jedi'
call plug#end()

" color theme
set background=dark
if $TERM_PROGRAM == "iTerm.app"
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    colorscheme gotham
elseif (index(['xterm-256color', 'screen-256color'], $TERM) >= 0)
    colorscheme gotham256
endif

" basic vim settings
set hidden
set number
set splitbelow
set splitright
set ignorecase
set smartcase
set colorcolumn=80,120
set fillchars="vert: "
set scrolloff=6
set completeopt-=preview
let loaded_matchparen = 1

" fzf
set rtp+=/usr/local/opt/fzf

" force yaml syntax on salt states
autocmd BufNewFile,BufRead *.sls set filetype=yaml

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" run neomake on save
autocmd! BufWritePost * Neomake
let g:neomake_open_list = 2

" refresh signify when fugitive commands are run
autocmd User Fugitive SignifyRefresh

" shortcuts
let mapleader="\<SPACE>"
nnoremap <Leader>a :Ag<space>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>g :GitFiles<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>s :source $MYVIMRC<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <Leader>l :nohlsearch<CR>
nnoremap <Leader>m :Neomake<CR>
nnoremap <Leader>r :NERDTreeFind<CR>
nnoremap <Leader>o :BTags<CR>
nnoremap <Leader>d :bprevious <BAR> bwipeout #<CR>
nnoremap <LocalLeader>c :lclose<CR><BAR>:cclose<CR>
nmap s <Plug>(easymotion-overwin-f2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
noremap <A-j> :bnext<CR>
noremap <A-k> :bprevious<CR>
nmap <A-o> o<Esc>0d$k
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" language specific key bindings
autocmd FileType python map <buffer> <LocalLeader>a :call jedi#goto_assignments()<CR>
autocmd FileType python map <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
autocmd FileType python map <buffer> <LocalLeader>u :call jedi#usages()<CR>
autocmd FileType python map <buffer> <LocalLeader>r :call jedi#rename()<CR>
autocmd FileType go map <buffer> <LocalLeader>d :GoDef<CR>
autocmd FileType go map <buffer> <LocalLeader>u :GoCallers<CR>
autocmd FileType go map <buffer> <LocalLeader>r :GoRename<CR>
" word movements in insert mode
inoremap <A-b> <C-o>b
inoremap <A-f> <C-o>w
inoremap <A-w> <C-o>dw
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
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
