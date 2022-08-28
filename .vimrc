" Vim Options {{{
set hidden
set number
set norelativenumber
set splitbelow
set splitright
set ignorecase
set smartcase
set colorcolumn=80,120
set synmaxcol=240
set fillchars="vert: "  " Hide vertical fill characters between windows.
set scrolloff=5
set rtp+=/usr/local/opt/fzf
set sessionoptions=buffers,curdir,folds
set foldenable
set foldmethod=manual
set foldlevelstart=99
set noshowmode
set wildmenu
set lazyredraw
set mouse=a
set modelines=1
set nofixendofline

let mapleader="\<SPACE>"
let maplocalleader = "\\"
" }}}

" Custom Functions {{{
function! QFdelete(bufnr) range
    " get current qflist
    let l:qfl = getqflist()
    " no need for filter() and such; just drop the items in range
    call remove(l:qfl, a:firstline - 1, a:lastline - 1)
    " replace items in the current list, do not make a new copy of it;
    " this also preserves the list title
    call setqflist([], 'r', {'items': l:qfl})
    " restore current line
    call setpos('.', [a:bufnr, a:firstline, 1, 0])
endfunction
" }}}

" Custom Commands {{{
:command! -range=% -nargs=0 Tab2Space execute '<line1>,<line2>s#^\t\+#\=repeat(" ", len(submatch(0))*' . &ts . ')'
:command! -range=% -nargs=0 Space2Tab execute '<line1>,<line2>s#^\( \{'.&ts.'\}\)\+#\=repeat("\t", len(submatch(0))/' . &ts . ')'
:command! -range=% -nargs=0 TrimWhitespace execute ':%s/\s\+$//e'
" }}}

" Autogroup {{{
augroup vimrc
    autocmd!
    autocmd FocusLost * :wa
    " Hide quickfix in buffer list.
    autocmd FileType qf set nobuflisted
    " Remove lines from quick fix window
    autocmd BufWinEnter quickfix if &bt ==# 'quickfix'
    autocmd BufWinEnter quickfix    nnoremap <silent><buffer>dd :call QFdelete(bufnr())<CR>
    autocmd BufWinEnter quickfix    vnoremap <silent><buffer>d  :call QFdelete(bufnr())<CR>
    autocmd BufWinEnter quickfix endif
augroup END
" }}}

" Leader Key Bindings {{{
nnoremap <Leader>d :BW<CR>
nnoremap <Leader>D :bd!<CR>
nnoremap <Leader>Q :qa!<CR>
" Wipe all buffers.
nnoremap <Leader>q :%bd<CR>
" Close all windows except current one.
nnoremap <Leader>w <C-w>o
" Toggle quoting style.
nnoremap <Leader>' :normal cs"'<CR>
nnoremap <Leader>" :normal cs'"<CR>
" Change word under cursor.
nnoremap <Leader>w ciw
" Change WORD under cursor.
nnoremap <Leader>W ciW
" Close quickfix list.
nnoremap <Leader>c :cclose<CR>
" Close location list.
nnoremap <LocalLeader>c :lclose<CR>
nnoremap <LocalLeader><CR> yypk:Commentary<CR>j
" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
" }}}

" Function Key Bindings {{{
" Work on vimrc easily.
nnoremap <F2> :e! $MYVIMRC<CR>
nnoremap <F4> :source $MYVIMRC<CR>

" Reset file from disk.
nnoremap <F5> :e!<CR>

" Copy all file.
nnoremap <F6> mzgg"+yG`z

" Indent whole file.
nnoremap <F7> mzgg=G`z

" Save all buffers and close program.
nnoremap <F8> :wa<CR><bar>:mksession!<CR><bar>:qa!<CR>

" Abort with non-zero exit code.
nnoremap <F12> :cq<CR>
" }}}

" Single Key Bindings {{{
" Resize windows with arrow keys.
nnoremap <left>  <c-w>>
nnoremap <right> <c-w><
nnoremap <up>    <c-w>-
nnoremap <down>  <c-w>+
" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv
" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$
" Repeat last macro
map , @@
" Move vertically by visual line
nnoremap j gj
nnoremap k gk
" Delete matching braces
nnoremap X %x``x
"}}}

" Combination Key Bindings {{{
" Navigate between buffers.
noremap <C-n> :bnext<CR>
noremap <C-p> :bprevious<CR>
" Highlight word under cursor.
noremap <silent> <C-h> :set hlsearch <BAR> let @/='\<'.expand("<cword>").'\>'<CR>
" Clear highlighted text.
nnoremap <C-l> :nohlsearch<CR>
" Insert new line without leaving normal mode.
nmap <C-> mzo<Esc>0d$`z
" Better shortcut for scrolling window.
nmap <C-j> 4<C-e>
nmap <C-k> 4<C-y>
" Better shortcut for navigating windows.
nmap gh <c-w>h
nmap gj <c-w>j
nmap gk <c-w>k
nmap gl <c-w>l
"}}}

" Other Key Bindings {{{
" Move to items in quickfix and location list.
nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>
nnoremap [l :lprevious<cr>
nnoremap ]l :lnext<cr>
nnoremap [L :lfirst<cr>
nnoremap ]L :llast<cr>
" Highlight last inserted text.
noremap gV `[v`]
" }}}

" vim:foldmethod=marker:foldlevel=0
