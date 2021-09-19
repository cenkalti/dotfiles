source ~/.vimrc

" Plugins {{{
" vim-plug plugin manager
call plug#begin(stdpath('data') . '/plugged')

" Color schemes
Plug 'ishan9299/nvim-solarized-lua'
Plug 'jonathanfilip/vim-lucius'
Plug 'vim-airline/vim-airline-themes'

" General plugins
Plug 'blueyed/vim-qf_resize'
Plug 'bronson/vim-trailing-whitespace'
Plug 'christoomey/vim-sort-motion'
Plug 'darrikonn/vim-gofmt'
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

" Language syntax plugins
Plug 'glench/vim-jinja2-syntax'
Plug 'saltstack/salt-vim'
Plug 'cespare/vim-toml'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'chr4/nginx.vim'

" Collection of configurations for built-in LSP client
Plug 'neovim/nvim-lspconfig'
" Autocompletion plugin
Plug 'hrsh7th/nvim-cmp'
" LSP source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
" Snippets source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip'
" Snippets plugin
Plug 'L3MON4D3/LuaSnip'

" Neomake must be loaded last.
" https://github.com/neomake/neomake/issues/2175
Plug 'neomake/neomake'

call plug#end()
" }}}

" Color scheme {{{
set termguicolors
set background=dark
colorscheme lucius
" }}}

" Plugin Options {{{
let NERDTreeIgnore = ['\.pyc$', 'Session.vim', '\.egg-info$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:signify_update_on_focusgained = 1
let g:deoplete#enable_at_startup = 1
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_y = ''
let g:airline_section_z = '%l/%L :%c'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep= ''
let g:airline#extensions#tabline#buffers_label = ''
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
let g:neomake_echo_current_error = 0
let g:neomake_virtualtext_current_error = 0
let g:go_fmt_options = {
    \ 'gofmt': '-s',
    \ }

let g:neomake_python_enabled_makers = ['python3']
if executable('flake8')
    call add(g:neomake_python_enabled_makers, 'flake8')
endif
if executable('mypy')
    call add(g:neomake_python_enabled_makers, 'mypy')
    let g:neomake_python_mypy_args = ['--ignore-missing-imports', '--follow-imports=skip']
endif

let g:neomake_typescript_enabled_makers = ['tsc']
if executable('eslint')
    call add(g:neomake_typescript_enabled_makers, 'eslint')
endif

" Configure Neomake to run on save.
call neomake#configure#automake('w')

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
:command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--mmap', <bang>0)
" }}}

" Autogroup {{{
augroup nvimrc
    autocmd!
    " Quit program if only open buffer is NERDTree.
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " Language specific commands with LocalLeader key.
    autocmd FileType python map <buffer> <LocalLeader>a :call jedi#goto_assignments()<CR>
    autocmd FileType python map <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
    autocmd FileType python map <buffer> <LocalLeader>u :call jedi#usages()<CR>
    autocmd FileType python map <buffer> <LocalLeader>r :call jedi#rename()<CR>
    autocmd FileType python map <buffer> <LocalLeader>y :0,$!yapf<CR>
    autocmd FileType python setlocal formatprg=yapf
    autocmd FileType go map <buffer> <LocalLeader>d :GoDef<CR>
    autocmd FileType go map <buffer> <LocalLeader>t :GoDefType<CR>
    autocmd FileType go map <buffer> <LocalLeader>u :GoCallers<CR>
    autocmd FileType go map <buffer> <LocalLeader>r :GoRename<CR>
    autocmd FileType typescript map <buffer> <LocalLeader>d :TSDef<CR>
    autocmd BufWritePost *.go GoFmt
augroup END
" }}}

" Leader Key Bindings {{{
nnoremap <Leader>o :BTags<CR>
nnoremap <Leader>a :Ag<space>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GitFiles<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>g :SignifyRefresh<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
" Reveal current buffer in NERDTree window.
nnoremap <Leader>r :NERDTreeFind<CR>
" Wipe all buffers other than current one.
nnoremap <Leader>b :BufOnly<CR>
" Search word under cursor with EasyMotion.
nnoremap <Leader>s :call EasyMotion#S(-1, 0, 2)<CR><C-r><C-w><CR><CR><S-n>
" Search word under cursor with Ag.
nnoremap <Leader>e :Ag<space><C-r><C-w><CR>
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
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" }}}

" Single Key Bindings {{{
" Replace some default motion keys with EasyMotion equivalents.
map  s <Plug>(easymotion-s2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
" }}}

:lua require('lsp')
:lua require('autocompletion')

" vim:foldmethod=marker:foldlevel=0
