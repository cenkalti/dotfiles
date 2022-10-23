" Map/unmap vim-bookmarks bindings on Nerdtree {{{
let g:bookmark_no_default_key_mappings = 1
function! BookmarkMapKeys()
    nmap mm :BookmarkToggle<CR>
    nmap mi :BookmarkAnnotate<CR>
    nmap mn :BookmarkNext<CR>
    nmap mp :BookmarkPrev<CR>
    nmap ma :BookmarkShowAll<CR>
    nmap mc :BookmarkClear<CR>
    nmap mx :BookmarkClearAll<CR>
    nmap mkk :BookmarkMoveUp
    nmap mjj :BookmarkMoveDown
endfunction
function! BookmarkUnmapKeys()
    unmap mm
    unmap mi
    unmap mn
    unmap mp
    unmap ma
    unmap mc
    unmap mx
    unmap mkk
    unmap mjj
endfunction
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" }}}

augroup nvimrc
    autocmd!
    autocmd FileType python setlocal formatprg=yapf
    autocmd FileType qf call AdjustWindowHeight(3, 10)
    " Quit program if only open buffer is NERDTree.
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " Map/unmap vim-bookmarks bindings on Nerdtree
    autocmd BufEnter * :call BookmarkMapKeys()
    autocmd BufEnter NERD_tree_* :call BookmarkUnmapKeys()
augroup END

" vim:foldmethod=marker:foldlevel=0
