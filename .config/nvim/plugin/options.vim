let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_y = ''
let g:airline_section_z = '%l/%L :%c'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep= ''
let g:airline#extensions#tabline#buffers_label = ''
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'ASDGHKLQWERTYUIOPZXCVBNMFJ;'
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_enter_jump_first = 1
let g:go_fmt_options = {'gofmt': '-s'}
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1
let g:bookmark_sign = '>>'
let g:bookmark_annotation_sign = '##'
let g:bookmark_show_toggle_warning = 0
let g:BufKillCreateMappings = 0
let g:BufKillActionWhenBufferDisplayedInAnotherWindow = 'kill'
let g:go_highlight_function_calls = 1

let g:neomake_open_list = 2
let g:neomake_echo_current_error = 0
let g:neomake_virtualtext_current_error = 1

let g:neomake_python_enabled_makers = ['python']
if executable('flake8')
    call add(g:neomake_python_enabled_makers, 'flake8')
endif
if executable('mypy')
    call add(g:neomake_python_enabled_makers, 'mypy')
    let g:neomake_python_mypy_args = ['--ignore-missing-imports', '--follow-imports=skip']
endif

let g:neomake_typescript_enabled_makers = ['tsc']
if executable('eslint')
    call add(g:neomake_typescript_enabled_makers, 'eslint')
endif

let g:neomake_go_enabled_makers = ['go']
if executable('golangci-lint')
    call add(g:neomake_go_enabled_makers, 'golangci_lint')
endif

let g:neomake_cpp_enabled_makers = ['clangtidy']
