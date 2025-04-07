layout_venv() {
    VIRTUAL_ENV="$(pwd)/${1:-.venv}"
    export VIRTUAL_ENV
    PATH_add "$VIRTUAL_ENV/bin"
}
