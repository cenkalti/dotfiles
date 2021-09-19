:command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--mmap', <bang>0)
