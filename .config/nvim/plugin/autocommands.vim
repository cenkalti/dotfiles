augroup nvimrc
    autocmd!
    " Quit program if only open buffer is NERDTree.
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    autocmd FileType python setlocal formatprg=yapf
augroup END