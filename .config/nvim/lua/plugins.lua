return {
  -- Color schemes
  { 'arcticicestudio/nord-vim', name = 'nord' },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim', version = '0.1.1',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },

  -- Highlight word under cursor
  'RRethy/vim-illuminate',

  -- Highlight trailing whitespaces in red
  'bronson/vim-trailing-whitespace',

  -- Sort selected text with `gs`
  'christoomey/vim-sort-motion',

  -- Search with 2 letters
  { 'phaazon/hop.nvim', branch = 'v2' },

  -- Show git status on gutter
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Delete all buffers except current one
  'vim-scripts/BufOnly.vim',

  -- Show open buffers on top and switch with <leader>1..9
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  -- Delete buffer without changing window layout
  'qpkorr/vim-bufkill',

  -- Comment out code
  'tpope/vim-commentary',

  -- Custom bookmarks
  'mattesgroeger/vim-bookmarks',

  -- Delete indentation level with `dii`, 1 above with `dai`.
  'michaeljsmith/vim-indent-object',

  -- Replace with yanked text: `grw`
  'vim-scripts/ReplaceWithRegister',

  -- More text objects. `ci(` replaces text inside ().
  'wellle/targets.vim',

  -- Fixes repeating pluging commands with `.`
  'tpope/vim-repeat',

  -- Git commands
  'tpope/vim-fugitive',

  -- Enables :GBrowse from vim-fugitive to open GitHub URLs
  'tpope/vim-rhubarb',

  -- Readline mappings from command line
  'tpope/vim-rsi',

  -- Automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
  'tpope/vim-sleuth',

  -- Change quotes with `cs'"`, delete with `ds"`.
  'tpope/vim-surround',

  -- Tmux support (Tyank, Tput)
  'tpope/vim-tbone',

  -- Golang support
  'ray-x/go.nvim',

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

}
