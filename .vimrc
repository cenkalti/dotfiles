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

    " Language syntax plugins
    Plug 'glench/vim-jinja2-syntax'
    Plug 'saltstack/salt-vim'
    Plug 'cespare/vim-toml'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'chr4/nginx.vim'

    " Language Server Protocol configurations
    Plug 'neovim/nvim-lspconfig'
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
endif

function! HasPlugin(name)
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
set scrolloff=5
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
set nofixendofline

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
" if HasPlugin('neomake')
"     call neomake#configure#automake('w')
" endif

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

" Custom Functions {{{
function! QFdelete(bufnr) range
    " get current qflist
    let l:qfl = getqflist()
    " no need for filter() and such; just drop the items in range
    call remove(l:qfl, a:firstline - 1, a:lastline - 1)
    " replace items in the current list, do not make a new copy of it;
    " this also preserves the list title
    call setqflist([], 'r', {'items': l:qfl})
    " restore current line
    call setpos('.', [a:bufnr, a:firstline, 1, 0])
endfunction
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
    autocmd FileType go map <buffer> <LocalLeader>t :GoDefType<CR>
    autocmd FileType go map <buffer> <LocalLeader>u :GoCallers<CR>
    autocmd FileType go map <buffer> <LocalLeader>r :GoRename<CR>
    autocmd FileType typescript map <buffer> <LocalLeader>d :TSDef<CR>
    " Remove lines from quick fix window
    autocmd BufWinEnter quickfix if &bt ==# 'quickfix'
    autocmd BufWinEnter quickfix    nnoremap <silent><buffer>dd :call QFdelete(bufnr())<CR>
    autocmd BufWinEnter quickfix    vnoremap <silent><buffer>d  :call QFdelete(bufnr())<CR>
    autocmd BufWinEnter quickfix endif
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
nnoremap <Leader>Q :qa!<CR>
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

" LSP {{{
" https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
" }}}

" Autocompletion {{{
" https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
lua << EOF
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
EOF
" }}}

" vim:foldmethod=marker:foldlevel=0
