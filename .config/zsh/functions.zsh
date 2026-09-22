# Shell functions.

function todos() {rg --line-number TODO | tr '\t' ' ' | tr -s ' ' | sort | awk -F':' '{print $3 " " "\033[34m" "!!!(" $1 ":" $2 ")" "\033[0m"}' | sed 's/.*TODO //' | awk '{print "\033[33mTODO\033[0m " $0}' | column -t -s'!!!'}

# my ssh & tmux helper
function ssht() { ssh -t $1 "tmux attach -t cenk || tmux new -s cenk" }
function mt() { mosh $1 -- sh -c "tmux attach -t cenk || tmux new -s cenk" }
function home() { mt "arch.home.cenkalti.com" }

function tunnel() { ssh -N -R "172.17.0.1:8080:127.0.0.1:$1" "cenk@arch.home.cenkalti.com" & }

function mkcd () {
  mkdir -p "$1"
  cd "$1"
}

function tempe () {
  cd "$(mktemp -d)"
  chmod -R 0700 .
  if [[ $# -eq 1 ]]; then
    mkdir -p "$1"
    cd "$1"
    chmod -R 0700 .
  fi
}

function searchandreplace() {
  if [ -z "$1" ]; then
    echo "Usage: searchandreplace <dir> <ext> <search> <replace>"
    return
  fi
  LC_ALL=C find $1 -path './.*' -prune -o -type f -name "*.$2" -exec sed -E -i '' "s/$3/$4/g" {} +
}

function searchanddelete() {
  if [ -z "$1" ]; then
    echo "Usage: searchandreplace <dir> <ext> <search>"
    return
  fi
  LC_ALL=C find $1 -path './.*' -prune -o -type f -name "*.$2" -exec sed -E -i '' "/$3/d" {} +
}

function loop() {
    seconds="$1"; shift
    while true; do
        echo "\$ $@"
        zsh -ic $@
        sleep $seconds
    done
}

function run-until-error() { while $@; do :; done; say "command is finished" }

function monitor()      { watch -n 1 "pgrep -l ${@:q} | grep -v watch" }
function monitor-full() { watch -n 1 "pgrep -a ${@:q} | grep -v watch" }

function etime() { ps -eo pid,comm,etime,args | grep $1 }

# Git Push Tag helper
function gpt() {
  # Get bump level and optional remote
  level="$1"
  remote="${2:-origin}"

  # Validate level argument
  case "$level" in
    "major"|"minor"|"patch") ;;
    *)
      echo "Usage: gpt <major|minor|patch> [remote]"
      return 1
  esac

  # Get highest tag and increment version
  version=$(git describe --abbrev=0 --tags 2>/dev/null | tr -d v || echo "0.0.0")
  parts=(${(s:.:)version})

  # Ensure we have 3 parts
  VNUM1=${parts[1]:-0}
  VNUM2=${parts[2]:-0}
  VNUM3=${parts[3]:-0}

  # Increment based on level
  case "$level" in
    "major") VNUM1=$((VNUM1+1)); VNUM2=0; VNUM3=0 ;;
    "minor") VNUM2=$((VNUM2+1)); VNUM3=0 ;;
    "patch") VNUM3=$((VNUM3+1)) ;;
  esac

  # Create new tag
  new_tag="v$VNUM1.$VNUM2.$VNUM3"

  read \?"Press enter for tagging as $new_tag and push to $remote..."

  git tag $new_tag
  git push "$remote" "$new_tag"
}

function pacman-leaves() {
  expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <({ expac -l '\n' '%E' base; } | sort -u)) | sort -n
}

function docker-remove-images-pattern() {
  docker images | grep "$1" | awk '{print $1":"$2}' | xargs docker rmi
}
function docker-remove-container-pattern() {
  docker ps -a | grep "$1" | awk '{print $1}' | xargs docker rm
}
function docker-build-and-run() {
  name="$(basename $(pwd))"
  docker build -t $name . && docker run -it --rm --name $name $name $@
}
function dex {
  docker exec -it "$1" "${@:2}"
}
function dl {
  docker logs -f $1
}

# go aliases
function gr() {
  local cmd=$1
  shift
  go run ./cmd/$cmd "$@"
}

function gi() {
  if [[ -z "$1" ]]; then
    echo "Usage: gi <subcommand> [args...]"
    echo "Example: gi run --session foo --assistant bar \"bla bla\""
    return 1
  fi

  local subcommand="$1"
  shift

  go run -C ~/projects/gi "./cmd/gi-$subcommand" -C "$PWD" "$@"
}

# colorize man pages
function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function ghsetup() {
    # Check if a repository is provided
    if [ -z "$1" ]; then
        echo "Please provide a repository in the format username/project"
        return 1
    fi

    # Extract username and project name
    USERNAME=$(echo $1 | cut -d "/" -f1)
    PROJECT=$(echo $1 | cut -d "/" -f2)

    # Default to Python 3 if not provided
    PYTHON_VERSION=${2:-3}

    # Clone the repository
    git clone "https://github.com/$1.git" ~/projects/$PROJECT
    cd ~/projects/$PROJECT

    # Set up Python virtual environment
    python${PYTHON_VERSION} -m venv .venv
    echo layout venv .venv > .envrc
    direnv allow .

    # Determine if it's a pip or poetry project and install requirements
    if [ -f "uv.lock" ]; then
        echo "uv.lock detected"
        direnv exec . uv sync
    elif [ -f "pdm.lock" ]; then
        echo "pdm.lock detected"
        direnv exec . pdm install
    elif [ -f "poetry.lock" ]; then
        echo "poetry.lock detected"
        direnv exec . poetry install
    elif [ -f "pyproject.toml" ]; then
        echo "pyproject.toml detected"
        direnv exec . pip install build
        direnv exec . pip install .
    elif [ -f "requirements.txt" ]; then
        echo "requirements.txt detected"
        direnv exec . pip install -r requirements.txt
    else
        echo "No requirements file found. Skipping package installation."
    fi

    echo "Setup complete for $PROJECT"
}

function ghnvim() {
    ghsetup $@
    exec nvim -c NvimTreeOpen -c "Telescope git_files"
}
