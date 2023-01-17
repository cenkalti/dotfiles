nnoremap <Leader>n :NERDTreeToggle<CR>
" Reveal current buffer in NERDTree window.
nnoremap <Leader>r :NERDTreeFind<CR>

" Quit program if only open buffer is NERDTree.
augroup nerdtree
    autocmd!
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
