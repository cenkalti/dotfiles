#!/bin/sh
# Run the Go import highlight test with and without gopls.
dir=$(dirname "$0")
case $dir in /*) ;; *) dir=$PWD/$dir ;; esac
cd "$dir/../.." || exit 1
status=0
for lsp in 0 1; do
    # The trailing cq! makes nvim exit non-zero if run.lua errors before finishing.
    GO_IMPORTS_LSP=$lsp nvim --headless -c 'luafile tests/go_imports/run.lua' -c 'cq!' || status=1
done
exit $status
