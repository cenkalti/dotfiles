" vim-plug plugin manager
call plug#begin()
Plug 'benekastah/neomake'
Plug 'bronson/vim-trailing-whitespace'
Plug 'christoomey/vim-sort-motion'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'fatih/vim-go'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'qpkorr/vim-bufkill'
Plug 'saltstack/salt-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'shougo/deoplete.nvim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/BufOnly.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-gotham'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'zchee/deoplete-jedi'
call plug#end()

set background=dark
" Hide ~ characters after EOF by making them same color as background.
autocmd ColorScheme * highlight NonText guifg=#0c1014
if $TERM_PROGRAM == "iTerm.app"
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    colorscheme gotham
elseif (index(['xterm-256color', 'screen-256color'], $TERM) >= 0)
    colorscheme gotham256
endif

set hidden
set number
set relativenumber
set splitbelow
set splitright
set ignorecase
set smartcase
set colorcolumn=80,120
" Hide vertical fill characters between windows.
set fillchars="vert: "
set scrolloff=6
set completeopt-=preview
set rtp+=/usr/local/opt/fzf

" Quit program if only open buffer is NERDTree.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd FocusLost * :wa
autocmd User Fugitive SignifyRefresh
autocmd! BufWritePost * Neomake
" Hide quickfix in buffer list.
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

let mapleader="\<SPACE>"
inoremap jj <Esc>
nnoremap <Leader>a :Ag<space>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GitFiles<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>sr :SignifyRefresh<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <Leader>m :Neomake<CR>
" Reveal current buffer in NERDTree window.
nnoremap <Leader>r :NERDTreeFind<CR>
nnoremap <Leader>o :BTags<CR>
nnoremap <Leader>d :BW<CR>
" Wipe all buffers.
nnoremap <Leader>q :%bd<CR>
" Wipe all buffers other than current one.
nnoremap <Leader>b :BufOnly<CR>

nnoremap <F5> :source $MYVIMRC<CR>
" Indent whole file.
nnoremap <F7> mzgg=G`z

" Replace some default motion keys with EasyMotion equivalents.
map  s <Plug>(easymotion-s2)
map  f <Plug>(easymotion-fl)
map  F <Plug>(easymotion-Fl)
map  t <Plug>(easymotion-tl)
map  T <Plug>(easymotion-Tl)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" Swith buffers with Ctrl-jk keys.
noremap <A-n> :bnext<CR>
noremap <A-p> :bprevious<CR>

" Highlight word under cursor.
noremap <silent> <C-h> :set hlsearch <BAR> let @/='\<'.expand("<cword>").'\>'<CR>

" Clear highlighted text.
nnoremap <C-l> :nohlsearch<CR>

" Insert new line under cursor without leaving normal mode.
nmap <A-o> o<Esc>0d$k

" Complete with <Tab> key.
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

" Language specific commands with LocalLeader key.
autocmd FileType python map <buffer> <LocalLeader>a :call jedi#goto_assignments()<CR>
autocmd FileType python map <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
autocmd FileType python map <buffer> <LocalLeader>u :call jedi#usages()<CR>
autocmd FileType python map <buffer> <LocalLeader>r :call jedi#rename()<CR>
autocmd FileType go map <buffer> <LocalLeader>d :GoDef<CR>
autocmd FileType go map <buffer> <LocalLeader>u :GoCallers<CR>
autocmd FileType go map <buffer> <LocalLeader>r :GoRename<CR>

" Jump to buffer with index number.
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" Move to items in quickfix and location list.
nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [l :lprevious<cr>
nnoremap ]l :lnext<cr>
nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>

" Close quickfix and location list windows.
nnoremap <LocalLeader>c :lclose<CR><BAR>:cclose<CR>

" Resize windows with arrow keys.
nnoremap <left>       <c-w>>
nnoremap <right>      <c-w><
nnoremap <up>         <c-w>-
nnoremap <down>       <c-w>+

" Switch windows with Alt+hjks keys.
nnoremap <A-h>        <c-w>h
nnoremap <A-j>        <c-w>j
nnoremap <A-k>        <c-w>k
nnoremap <A-l>        <c-w>l

" Better shortcut for scrolling window.
nmap <C-j> <C-e>
nmap <C-k> <C-y>

" Quickly select the text that was just pasted. This allows you to, e.g.,
" indent it after pasting.
noremap gV `[v`]

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$

" Insert mode movements with Ctrl key.
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0

" Insert mode movements with Alt key.
inoremap <A-b> <C-o>b
inoremap <A-f> <C-o>w
inoremap <A-w> <C-o>dw

let loaded_matchparen = 1
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeMinimalUI = 1
let g:signify_update_on_focusgained = 1
let g:deoplete#enable_at_startup = 1
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
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
let g:airline_section_y = ''
let g:airline_section_z = '%l/%L :%c'
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:neomake_open_list = 2
let g:startify_change_to_dir = 0
let g:EasyMotion_keys = 'qpwoeirutyzmxncbvghalskfj'
