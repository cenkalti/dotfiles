" vim-plug plugin manager
call plug#begin()

" Color schemes
Plug 'jonathanfilip/vim-lucius'
"Plug 'whatyouhide/vim-gotham'
"Plug 'chriskempson/base16-vim'
"Plug 'chriskempson/vim-tomorrow-theme'
Plug 'vim-airline/vim-airline-themes'

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
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/BufOnly.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'wellle/targets.vim'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'zchee/deoplete-jedi'
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
set fillchars="vert: "  " Hide vertical fill characters between windows.
set scrolloff=6
set completeopt-=preview
set rtp+=/usr/local/opt/fzf
set sessionoptions=buffers,curdir,folds
set nofoldenable
set noshowmode

" Override plugin options.
let loaded_matchparen = 1
let NERDTreeIgnore = ['\.pyc$', 'Session.vim']
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
let g:startify_change_to_dir = 0
let g:go_fmt_command = "goimports"

augroup vimrc
    autocmd!
    autocmd FocusLost * :wa
    autocmd User Fugitive SignifyRefresh
    autocmd BufWritePost * Neomake
    " Quit program if only open buffer is NERDTree.
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " Hide quickfix in buffer list.
    autocmd FileType qf set nobuflisted
augroup END

source ~/.config/nvim/keys.vim
