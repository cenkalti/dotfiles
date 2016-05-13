call plug#begin()
Plug 'benekastah/neomake'
Plug 'bronson/vim-trailing-whitespace'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'fatih/vim-go'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'
Plug 'qpkorr/vim-bufkill'
Plug 'saltstack/salt-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'shougo/deoplete.nvim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/BufOnly.vim'
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-gotham'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'zchee/deoplete-jedi'
call plug#end()

set background=dark
autocmd ColorScheme * highlight NonText guifg=#0c1014
if $TERM_PROGRAM == "iTerm.app"
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    colorscheme gotham
elseif (index(['xterm-256color', 'screen-256color'], $TERM) >= 0)
    colorscheme gotham256
endif

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
set rtp+=/usr/local/opt/fzf
let loaded_matchparen = 1

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd FocusLost * :wa
autocmd User Fugitive SignifyRefresh
autocmd! BufWritePost * Neomake

let mapleader="\<SPACE>"
nnoremap <Leader>a :Ag<space>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GitFiles<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>sr :SignifyRefresh<CR>
nnoremap <F5> :source $MYVIMRC<CR>
nnoremap <F7> mzgg=G`z
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <C-l> :nohlsearch<CR>
nnoremap <Leader>m :Neomake<CR>
nnoremap <Leader>r :NERDTreeFind<CR>
nnoremap <Leader>o :BTags<CR>
nnoremap <Leader>d :BW<CR>
nnoremap <Leader>q :%bd<CR>
nnoremap <Leader>b :BufOnly<CR>
nnoremap <LocalLeader>c :lclose<CR><BAR>:cclose<CR>
map s <Plug>(easymotion-s2)
map f <Plug>(easymotion-fl)
map F <Plug>(easymotion-Fl)
map t <Plug>(easymotion-tl)
map T <Plug>(easymotion-Tl)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
map <Leader>w <Plug>(easymotion-bd-w)
map <Leader>W <Plug>(easymotion-bd-W)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
noremap <C-k> :bnext<CR>
noremap <C-j> :bprevious<CR>
noremap <silent> <C-h> :set hlsearch <BAR> let @/='\<'.expand("<cword>").'\>'<CR>
nmap <A-o> o<Esc>0d$k
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"
inoremap <A-b> <C-o>b
inoremap <A-f> <C-o>w
inoremap <A-w> <C-o>dw
autocmd FileType python map <buffer> <LocalLeader>a :call jedi#goto_assignments()<CR>
autocmd FileType python map <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
autocmd FileType python map <buffer> <LocalLeader>u :call jedi#usages()<CR>
autocmd FileType python map <buffer> <LocalLeader>r :call jedi#rename()<CR>
autocmd FileType go map <buffer> <LocalLeader>d :GoDef<CR>
autocmd FileType go map <buffer> <LocalLeader>u :GoCallers<CR>
autocmd FileType go map <buffer> <LocalLeader>r :GoRename<CR>
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nnoremap [q           :cprevious<cr>
nnoremap ]q           :cnext<cr>
nnoremap [Q           :cfirst<cr>
nnoremap ]Q           :clast<cr>
nnoremap [l           :lprevious<cr>
nnoremap ]l           :lnext<cr>
nnoremap [L           :lfirst<cr>
nnoremap ]L           :llast<cr>
nnoremap <left>       <c-w>>
nnoremap <right>      <c-w><
nnoremap <up>         <c-w>-
nnoremap <down>       <c-w>+
nnoremap <a-h>        <c-w>h
nnoremap <a-j>        <c-w>j
nnoremap <a-k>        <c-w>k
nnoremap <a-l>        <c-w>l

let NERDTreeIgnore = ['\.pyc$']
let NERDTreeMinimalUI = 1
let g:signify_update_on_focusgained = 1
let g:deoplete#enable_at_startup = 1
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep= ''
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#buffers_label = ''
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:neomake_open_list = 2
let g:startify_change_to_dir = 0
let g:EasyMotion_keys = 'qpwoeirutyzmxncbvghalskfj'
let g:airline_section_y = ''
