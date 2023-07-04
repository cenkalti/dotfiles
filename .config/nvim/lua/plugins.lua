return {
  -- Color schemes
  { 'arcticicestudio/nord-vim', name = 'nord' },

  -- Highlight word under cursor
  'RRethy/vim-illuminate',

  -- Highlight trailing whitespaces in red
  'bronson/vim-trailing-whitespace',

  -- Sort selected text with `gs`
  'christoomey/vim-sort-motion',

  -- Show git status on gutter
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Delete all buffers except current one
  'vim-scripts/BufOnly.vim',

  -- Show open buffers on top and switch with <leader>1..9
  {'akinsho/bufferline.nvim', version = "*", dependencies = { 'nvim-tree/nvim-web-devicons' } },

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
}
