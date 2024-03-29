-- Custom bookmarks
return {
  'mattesgroeger/vim-bookmarks',
  init = function ()
    vim.g.bookmark_auto_save = 1
    vim.g.bookmark_sign = '>>'
    vim.g.bookmark_annotation_sign = '##'
    vim.g.bookmark_show_toggle_warning = 0
  end,
}
