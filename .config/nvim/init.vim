source ~/.vimrc

" vim-plug plugin manager
call plug#begin(stdpath('data') . '/plugged')

" Color schemes
Plug 'arcticicestudio/nord-vim'

" General plugins
Plug 'blueyed/vim-qf_resize'
Plug 'bronson/vim-trailing-whitespace'
Plug 'christoomey/vim-sort-motion'
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go'
Plug 'jgramacho/vim-mysql-mtr'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mattesgroeger/vim-bookmarks'
Plug 'mhinz/vim-signify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'preservim/tagbar'
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
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': '0.5-compat'}
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
