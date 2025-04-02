# https://github.com/direnv/direnv/wiki/Python#virtualenvwrapper
layout_venv() {
  source "${1:-.venv}/bin/activate"
  # https://github.com/direnv/direnv/wiki/PS1
  unset PS1
}
