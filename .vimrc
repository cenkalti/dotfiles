" vim-plug plugin manager
call plug#begin('~/.vim/bundle')

" Color schemes
Plug 'jonathanfilip/vim-lucius'
Plug 'vim-airline/vim-airline-themes'

" General plugins
Plug 'benekastah/neomake'
Plug 'bronson/vim-trailing-whitespace'
Plug 'christoomey/vim-sort-motion'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'qpkorr/vim-bufkill'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/BufOnly.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'wellle/targets.vim'
Plug 'xuyuanp/nerdtree-git-plugin'

" Language specific plugins
Plug 'davidhalter/jedi-vim'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'fatih/vim-go'
Plug 'glench/vim-jinja2-syntax'
Plug 'lambdatoast/elm.vim'
Plug 'saltstack/salt-vim'

if has('nvim')
    Plug 'shougo/deoplete.nvim'
    Plug 'zchee/deoplete-go', { 'do': 'make'}
    Plug 'zchee/deoplete-jedi'
end

call plug#end()

" Set color theme.
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=light
colorscheme lucius

" Adjust basic vim options.
set hidden
set number
set relativenumber
set splitbelow
set splitright
set ignorecase
set smartcase
set colorcolumn=80,120
set synmaxcol=128
set fillchars="vert: "  " Hide vertical fill characters between windows.
set scrolloff=6
set completeopt-=preview
set rtp+=/usr/local/opt/fzf
set sessionoptions=buffers,curdir,folds
set nofoldenable
set noshowmode
set lazyredraw

let mapleader="\<SPACE>"
let maplocalleader = "\\"

" Override plugin options.
let NERDTreeIgnore = ['\.pyc$', 'Session.vim', '\.egg-info$']
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
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'QPWOEIRUTYZMXNCBVGHALSKFJ'
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_enter_jump_first = 1
let g:neomake_open_list = 2
let g:neomake_python_enabled_makers = ['python', 'pylama']
let g:startify_change_to_dir = 0
let g:go_fmt_command = "goimports"
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:python_host_prog = '/usr/local/bin/python2.7'
let g:python3_host_prog = '/usr/local/bin/python3.6'

" Define commands for common operations on files.
:command! -range=% -nargs=0 Tab2Space execute '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
:command! -range=% -nargs=0 Space2Tab execute '<line1>,<line2>s#^\( \{'.&ts.'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'
:command! -range=% -nargs=0 TrimWhitespace execute ':%s/\s\+$//e'

augroup vimrc
    autocmd!
    autocmd FocusLost * :wa
    autocmd BufWritePost * Neomake
    " Quit program if only open buffer is NERDTree.
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " Hide quickfix in buffer list.
    autocmd FileType qf set nobuflisted
    " Language specific commands with LocalLeader key.
    autocmd FileType python map <buffer> <LocalLeader>a :call jedi#goto_assignments()<CR>
    autocmd FileType python map <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
    autocmd FileType python map <buffer> <LocalLeader>u :call jedi#usages()<CR>
    autocmd FileType python map <buffer> <LocalLeader>r :call jedi#rename()<CR>
    autocmd FileType python map <buffer> <LocalLeader>y :0,$!yapf<CR>
    autocmd FileType python setlocal formatprg=yapf
    autocmd FileType go map <buffer> <LocalLeader>d :GoDef<CR>
    autocmd FileType go map <buffer> <LocalLeader>u :GoCallers<CR>
    autocmd FileType go map <buffer> <LocalLeader>r :GoRename<CR>
augroup END

nnoremap <Leader>a :Ag<space>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GitFiles<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>g :SignifyRefresh<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>m :Neomake<CR>
" Reveal current buffer in NERDTree window.
nnoremap <Leader>r :NERDTreeFind<CR>
nnoremap <Leader>o :BTags<CR>
nnoremap <Leader>d :BW<CR>
nnoremap <Leader>D :bd!<CR>
" Wipe all buffers.
nnoremap <Leader>q :%bd<CR>
" Wipe all buffers other than current one.
nnoremap <Leader>b :BufOnly<CR>
" Close all windows except current one.
nnoremap <Leader>w <C-w>o
" Toggle quoting style.
nnoremap <Leader>' :normal cs"'<CR>
nnoremap <Leader>" :normal cs'"<CR>
" Search word under cursor with EasyMotion.
nnoremap <Leader>s :call EasyMotion#S(-1, 0, 2)<CR><C-r><C-w><CR><CR><S-n>
" Search word under cursor with Ag.
nnoremap <Leader>e :Ag<space><C-r><C-w><CR>
" Change word under cursor.
nnoremap <LocalLeader>w ciw
" Change WORD under cursor.
nnoremap <LocalLeader>W ciW

" Work on vimrc easily.
nnoremap <F2> :e! $MYVIMRC<CR>
nnoremap <F4> :source $MYVIMRC<CR>

" Reset file from disk.
nnoremap <F5> :e!<CR>

" Indent whole file.
nnoremap <F7> mzgg=G`z

" Save all buffers and close program.
nnoremap <F8> :wa<CR><bar>:mksession!<CR><bar>:qa!<CR>

" Abort with non-zero exit code.
nnoremap <F12> :cq<CR>

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

" Swith buffers with Ctrl-0 and Ctrl-9 keys.
noremap <C-n> :bnext<CR>
noremap <C-p> :bprevious<CR>

" Highlight word under cursor.
noremap <silent> <C-h> :set hlsearch <BAR> let @/='\<'.expand("<cword>").'\>'<CR>

" Clear highlighted text.
nnoremap <C-l> :nohlsearch<CR>

" Insert new line without leaving normal mode.
nmap <C-> mzo<Esc>0d$`z

" Complete with <Tab> key.
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

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
nnoremap <left>  <c-w>>
nnoremap <right> <c-w><
nnoremap <up>    <c-w>-
nnoremap <down>  <c-w>+

" Change window with <Leader> + HJKL keys.
nmap <leader>h <c-w>h
nmap <leader>j <c-w>j
nmap <leader>k <c-w>k
nmap <leader>l <c-w>l

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

" Insert single character without switching into insert mode.
:nnoremap , :exec "normal i".nr2char(getchar())."\e"<CR>

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
