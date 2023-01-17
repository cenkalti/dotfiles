" Adjust quickfix window
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
augroup quickfix
    autocmd!
    autocmd FileType qf call AdjustWindowHeight(3, 10)
augroup END

