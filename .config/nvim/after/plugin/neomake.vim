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

" Configure Neomake to run on save.
call neomake#configure#automake('w')

