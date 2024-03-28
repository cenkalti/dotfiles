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
set updatetime=250

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

" Adjust quickfix window
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
augroup quickfix
    autocmd!
    autocmd FileType qf call AdjustWindowHeight(3, 10)
augroup END
" }}}

" vim:foldmethod=marker:foldlevel=0
