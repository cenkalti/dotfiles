" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Replace some default motion keys with EasyMotion equivalents.
map  s <Plug>(easymotion-s2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" Search word under cursor with EasyMotion.
nnoremap <Leader>s :call EasyMotion#S(-1, 0, 2)<CR><C-r><C-w><CR><CR><S-n>
