-- Disable netrw for nvim-tree. Must be at the very start of init.lua.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load legacy vim config
vim.cmd('source ~/.vimrc')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Color schemes
  use { 'arcticicestudio/nord-vim', as = 'nord' }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
  }

  -- Highlight word under cursor
  use 'RRethy/vim-illuminate'

  -- Highlight trailing whitespaces in red
  use 'bronson/vim-trailing-whitespace'

  -- Sort selected text with `gs`
  use 'christoomey/vim-sort-motion'

  -- Search with 2 letters
  use 'easymotion/vim-easymotion'

  -- Show git status on gutter
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- File tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- Delete all buffers except current one
  use 'vim-scripts/BufOnly.vim'

  -- Show open buffers on top and switch with <leader>1..9
  use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Delete buffer without changing window layout
  use 'qpkorr/vim-bufkill'

  -- Comment out code
  use 'tpope/vim-commentary'

  -- Custom bookmarks
  use 'mattesgroeger/vim-bookmarks'

  -- Delete indentation level with `dii`, 1 above with `dai`.
  use 'michaeljsmith/vim-indent-object'

  -- Replace with yanked text: `grw`
  use 'vim-scripts/ReplaceWithRegister'

  -- More text objects. `ci(` replaces text inside ().
  use 'wellle/targets.vim'

  -- Fixes repeating pluging commands with `.`
  use 'tpope/vim-repeat'

  -- Git commands
  use 'tpope/vim-fugitive'

  -- Enables :GBrowse from vim-fugitive to open GitHub URLs
  use 'tpope/vim-rhubarb'

  -- Readline mappings from command line
  use 'tpope/vim-rsi'

  -- Automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
  use 'tpope/vim-sleuth'

  -- Change quotes with `cs'"`, delete with `ds"`.
  use 'tpope/vim-surround'

  -- Tmux support (Tyank, Tput)
  use 'tpope/vim-tbone'

  -- Golang support
  use 'ray-x/go.nvim'

  -- Language syntax plugins
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional
      {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    }
  }

  -- Load local plugins
  if vim.fn.filereadable('~/.config/nvim/lua/local.lua') then
    require('local').config(use)
  end
end)

