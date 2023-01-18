set termguicolors
lua << EOF
require("bufferline").setup{
    options = {
        numbers = 'ordinal',
        show_close_icon = false,
        show_buffer_close_icons = false,
    },
}
EOF

nnoremap <silent><leader>1 <cmd>lua require("bufferline").go_to_buffer(1, true)<cr>
nnoremap <silent><leader>2 <cmd>lua require("bufferline").go_to_buffer(2, true)<cr>
nnoremap <silent><leader>3 <cmd>lua require("bufferline").go_to_buffer(3, true)<cr>
nnoremap <silent><leader>4 <cmd>lua require("bufferline").go_to_buffer(4, true)<cr>
nnoremap <silent><leader>5 <cmd>lua require("bufferline").go_to_buffer(5, true)<cr>
nnoremap <silent><leader>6 <cmd>lua require("bufferline").go_to_buffer(6, true)<cr>
nnoremap <silent><leader>7 <cmd>lua require("bufferline").go_to_buffer(7, true)<cr>
nnoremap <silent><leader>8 <cmd>lua require("bufferline").go_to_buffer(8, true)<cr>
nnoremap <silent><leader>9 <cmd>lua require("bufferline").go_to_buffer(9, true)<cr>
nnoremap <silent><leader>$ <cmd>lua require("bufferline").go_to_buffer(-1, true)<cr>

nnoremap <silent><C-n> :BufferLineCycleNext<CR>
nnoremap <silent><C-p> :BufferLineCyclePrev<CR>

nnoremap <silent><C-A-n> :BufferLineMoveNext<CR>
nnoremap <silent><C-A-p> :BufferLineMovePrev<CR>
