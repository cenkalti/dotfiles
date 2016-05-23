let mapleader="\<SPACE>"

inoremap jj <Esc>
nnoremap <Leader>a :Ag<space>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GitFiles<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>sr :SignifyRefresh<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <Leader>m :Neomake<CR>
" Reveal current buffer in NERDTree window.
nnoremap <Leader>r :NERDTreeFind<CR>
nnoremap <Leader>o :BTags<CR>
nnoremap <Leader>d :BW<CR>
" Wipe all buffers.
nnoremap <Leader>q :%bd<CR>
" Wipe all buffers other than current one.
nnoremap <Leader>b :BufOnly<CR>

" Work on vimrc easily.
nnoremap <F4> :e! $MYVIMRC<cr>
nnoremap <F5> :source $MYVIMRC<CR>

" Indent whole file.
nnoremap <F7> mzgg=G`z

" Replace some default motion keys with EasyMotion equivalents.
map  s <Plug>(easymotion-s2)
map  f <Plug>(easymotion-bd-f)
map  F <Plug>(easymotion-bd-fl)
map  t <Plug>(easymotion-bd-t)
map  T <Plug>(easymotion-bd-tl)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" Swith buffers with Ctrl-jk keys.
noremap <A-n> :bnext<CR>
noremap <A-p> :bprevious<CR>

" Highlight word under cursor.
noremap <silent> <C-h> :set hlsearch <BAR> let @/='\<'.expand("<cword>").'\>'<CR>

" Clear highlighted text.
nnoremap <C-l> :nohlsearch<CR>

" Insert new line without leaving normal mode.
nmap <A-o> mzo<Esc>0d$`z
nmap <A-O> mzO<Esc>0d$`z

" Complete with <Tab> key.
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

" Language specific commands with LocalLeader key.
augroup language
    autocmd!
    autocmd FileType python map <buffer> <LocalLeader>a :call jedi#goto_assignments()<CR>
    autocmd FileType python map <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
    autocmd FileType python map <buffer> <LocalLeader>u :call jedi#usages()<CR>
    autocmd FileType python map <buffer> <LocalLeader>r :call jedi#rename()<CR>
    autocmd FileType python map <buffer> <LocalLeader>y :0,$!yapf<CR>
    autocmd FileType python setlocal formatprg=yapf
    autocmd FileType go map <buffer> <LocalLeader>d :GoDef<CR>
    autocmd FileType go map <buffer> <LocalLeader>u :GoCallers<CR>
    autocmd FileType go map <buffer> <LocalLeader>r :GoRename<CR>
augroup END

" Jump to buffer with index number.
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" Move to items in quickfix and location list.
nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [l :lprevious<cr>
nnoremap ]l :lnext<cr>
nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>

" Close quickfix and location list windows.
nnoremap <LocalLeader>c :lclose<CR><BAR>:cclose<CR>

" Resize windows with arrow keys.
nnoremap <left>       <c-w>>
nnoremap <right>      <c-w><
nnoremap <up>         <c-w>-
nnoremap <down>       <c-w>+

" Switch windows with Alt+hjks keys.
nnoremap <A-h>        <c-w>h
nnoremap <A-j>        <c-w>j
nnoremap <A-k>        <c-w>k
nnoremap <A-l>        <c-w>l

" Better shortcut for scrolling window.
nmap <C-j> <C-e>
nmap <C-k> <C-y>

" Quickly select the text that was just pasted. This allows you to, e.g.,
" indent it after pasting.
noremap gV `[v`]

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$

" Insert mode movements with Ctrl key.
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0

" Insert mode movements with Alt key.
inoremap <A-b> <C-o>b
inoremap <A-f> <C-o>w
inoremap <A-w> <C-o>dw
