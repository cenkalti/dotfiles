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

source ~/.config/nvim/keys.vim
