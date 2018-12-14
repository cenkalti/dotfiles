" Plugins {{{
" vim-plug plugin manager
let s:plugindir = '~/.vim/bundle/'
if !empty(glob('~/.vim/autoload/plug.vim'))
    call plug#begin(s:plugindir)

    " Color schemes
    Plug 'jonathanfilip/vim-lucius'
    Plug 'vim-airline/vim-airline-themes'

    " General plugins
    Plug 'blueyed/vim-qf_resize'
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'chr4/nginx.vim'
    Plug 'christoomey/vim-sort-motion'
    Plug 'easymotion/vim-easymotion'
    Plug 'junegunn/fzf.vim'
    Plug 'mhinz/vim-signify'
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'qpkorr/vim-bufkill'
    Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-commentary'
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
    Plug 'fatih/vim-go'
    Plug 'glench/vim-jinja2-syntax'
    Plug 'lambdatoast/elm.vim'
    Plug 'saltstack/salt-vim'

    if has('nvim')
        Plug 'shougo/deoplete.nvim'
        Plug 'zchee/deoplete-go', { 'do': 'make'}
        Plug 'zchee/deoplete-jedi'
    end

    " https://github.com/neomake/neomake/issues/2175
    Plug 'neomake/neomake'

    call plug#end()
endif

function HasPlugin(name)
    let dir = s:plugindir . a:name
    return !empty(glob(dir))
endfunction
" }}}

" Color scheme {{{
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
if HasPlugin('vim-lucius')
    colorscheme lucius
endif
" }}}

" Vim Options {{{
set hidden
set number
set norelativenumber
set splitbelow
set splitright
set ignorecase
set smartcase
set colorcolumn=80,120
set synmaxcol=240
set fillchars="vert: "  " Hide vertical fill characters between windows.
set scrolloff=6
set completeopt-=preview
set rtp+=/usr/local/opt/fzf
set sessionoptions=buffers,curdir,folds
set foldenable
set foldmethod=indent
set foldlevelstart=99
set noshowmode
set wildmenu
set lazyredraw
set mouse=a
set modelines=1

if has ('gui_vimr')
    set termguicolors
    set title
end

let mapleader="\<SPACE>"
let maplocalleader = "\\"
" }}}

" Plugin Options {{{
let NERDTreeIgnore = ['\.pyc$', 'Session.vim', '\.egg-info$', '__pycache__']
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
let g:EasyMotion_keys = 'ASDGHKLQWERTYUIOPZXCVBNMFJ;'
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_enter_jump_first = 1
let g:startify_change_to_dir = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:neomake_open_list = 2
let g:go_fmt_options = {
    \ 'gofmt': '-s',
    \ }

let g:neomake_python_enabled_makers = ['python']
if executable('flake8')
    call add(g:neomake_python_enabled_makers, 'flake8')
endif
if executable('mypy')
    call add(g:neomake_python_enabled_makers, 'mypy')
    let g:neomake_python_mypy_args = ['--ignore-missing-imports', '--follow-imports=skip']
endif

let g:neomake_go_enabled_makers = ['go']
if executable('gometalinter')
    call add(g:neomake_go_enabled_makers, 'gometalinter')
    let g:neomake_go_gometalinter_args = ['--fast', '--vendor', '--disable=maligned', '--disable=aligncheck', '--disable=gocyclo', '--exclude', 'be unexported.*golint', '--exclude', 'Errors unhandled.*gosec']
endif

if HasPlugin('neomake')
    call neomake#configure#automake('w')
endif

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" }}}

" Custom Commands {{{
:command! -range=% -nargs=0 Tab2Space execute '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
:command! -range=% -nargs=0 Space2Tab execute '<line1>,<line2>s#^\( \{'.&ts.'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'
:command! -range=% -nargs=0 TrimWhitespace execute ':%s/\s\+$//e'
:command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--mmap', <bang>0)
" }}}

" Autogroup {{{
augroup vimrc
    autocmd!
    autocmd FocusLost * :wa
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
" }}}

" Leader Key Bindings {{{
nnoremap <Leader>a :Ag<space>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GitFiles<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>g :SignifyRefresh<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
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
nnoremap <Leader>w ciw
" Change WORD under cursor.
nnoremap <Leader>W ciW
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
" Close quickfix list.
nnoremap <Leader>c :cclose<CR>
" Close location list.
nnoremap <LocalLeader>c :lclose<CR>
" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" }}}

" Function Key Bindings {{{
" Work on vimrc easily.
nnoremap <F2> :e! $MYVIMRC<CR>
nnoremap <F4> :source $MYVIMRC<CR>

" Reset file from disk.
nnoremap <F5> :e!<CR>

" Copy all file.
nnoremap <F6> mzgg"+yG`z

" Indent whole file.
nnoremap <F7> mzgg=G`z

" Save all buffers and close program.
nnoremap <F8> :wa<CR><bar>:mksession!<CR><bar>:qa!<CR>

" Abort with non-zero exit code.
nnoremap <F12> :cq<CR>
" }}}

" Single Key Bindings {{{
" Replace some default motion keys with EasyMotion equivalents.
if HasPlugin('vim-easymotion')
    map  s <Plug>(easymotion-s2)
    map  / <Plug>(easymotion-sn)
    omap / <Plug>(easymotion-tn)
    map  n <Plug>(easymotion-next)
    map  N <Plug>(easymotion-prev)
endif
" Resize windows with arrow keys.
nnoremap <left>  <c-w>>
nnoremap <right> <c-w><
nnoremap <up>    <c-w>-
nnoremap <down>  <c-w>+
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
" Move vertically by visual line
nnoremap j gj
nnoremap k gk
" Delete matching braces
nnoremap X %x``x
"}}}

" Combination Key Bindings {{{
" Navigate between buffers.
noremap <C-n> :bnext<CR>
noremap <C-p> :bprevious<CR>
" Highlight word under cursor.
noremap <silent> <C-h> :set hlsearch <BAR> let @/='\<'.expand("<cword>").'\>'<CR>
" Clear highlighted text.
nnoremap <C-l> :nohlsearch<CR>
" Insert new line without leaving normal mode.
nmap <C-> mzo<Esc>0d$`z
" Better shortcut for scrolling window.
nmap <C-j> 4<C-e>
nmap <C-k> 4<C-y>
" Better shortcut for navigating windows.
nmap gh <c-w>h
nmap gj <c-w>j
nmap gk <c-w>k
nmap gl <c-w>l
"}}}

" Other Key Bindings {{{
" Complete with <Tab> key.
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"
" Move to items in quickfix and location list.
nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [l :lprevious<cr>
nnoremap ]l :lnext<cr>
nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>
" Highlight last inserted text.
noremap gV `[v`]
" }}}

" vim:foldmethod=marker:foldlevel=0
