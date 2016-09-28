if type task &> /dev/null; then
    task rc.verbose=nothing next || true
fi
