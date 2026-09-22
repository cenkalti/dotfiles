# Aliases.

alias l="eza -l --icons --hyperlink"
alias la="l -aa"
alias lt="ls -lt | head"

alias rg='rg --hyperlink-format=kitty'

# One-key shortcuts
alias d="pwd"
alias u="sudo -iu"
alias s="sudo su"
alias e="etcdctl"
alias k="kubectl"
alias p="cd ~/projects/private && claude --continue"
alias h="hostname"

alias lg="lazygit"

alias c="claude"
alias a='agent run'

alias myip="curl http://ipinfo.io/ip"
alias mycity="curl http://ipinfo.io/city"

alias disk-usage='sudo du -xcms * 2>/dev/null | sort -rn | head -11'

alias remove-old-files="find . -mindepth 1 -maxdepth 1 -mtime +1 -exec rm -rf '{}' +"

alias https='http --default-scheme=https'

alias todosw="watch --color -x zsh -ic 'todo | tee >(wc -l | xargs echo \"Count:\")'"

alias nvims="nvim -S Session.vim"

alias isodate='date +"%Y-%m-%dT%H:%M:%S%z"'

# Enable core dump
alias encoredump='ulimit -c unlimited'
# Disable core dump
alias nocoredump='ulimit -c 0'
# Check core dump
alias iscoredump='ulimit -c'

# git aliases
alias g="git st"
alias gp="git push || git pull --rebase && git push"
alias gti=git
# ...others are in .gitconfig file

# shows listening ports
alias listening="sudo lsof -Pn -iTCP -sTCP:LISTEN"

# pacman
alias paci='sudo pacman -S'         # Install a specific package from repos added to the system
alias pacr='sudo pacman -R'         # Remove the specified package but retain its configuration and deps
alias pacu='sudo pacman -Syu'       # Update the system and upgrade all system packages.
alias pacinf='pacman -Si'           # Display information about a given package located in the repositories
alias pacl='sudo pacman -U'         # Install specific package that has been downloaded to the local system
alias pacs='pacman -Ss'             # Search for package or packages in the repositories
alias pacrall='sudo pacman -Rns'    # Remove package, its configuration and all unwanted dependencies
alias pacsl='pacman -Qi'            # Display information about a given package in the local database
alias paclocs='pacman -Qs'          # Search for package/packages in the local database

# yay
alias yi='yay -S'           # Install a specific package from repos added to the system
alias yr='yay -R'           # Remove package but retain configs and required dependencies
alias yu='yay -Syua'        # Synchronize with repositories and upgrade packages, including AUR packages.
alias yil='yay -U'          # Install specific package that has been downloaded to the local system
alias yrall='yay -Rns'      # Remove package or packages , its configuration and all unwanted dependencies
alias yip='yay -Si'         # Display information about a given package located in the repositories
alias ys='yay -Ss'          # Search for package or packages in the repositories
alias yil='yay -Qi'         # Display information about a given package in the local database
alias ysl='yay -Qs'         # Search for package(s) in the local database
alias yll='yay -Qe'         # List installed packages, even those installed from AUR (they're tagged as "local")
alias yro='yay -Qtd'        # Remove orphans using yay

# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks
alias pacman-remove-orphans="pacman -Qtdq | sudo pacman -Rns -"

# docker aliases
alias dcu='docker compose up --detach --remove-orphans'
alias docker-remove-all-containers="docker ps -aq | xargs docker rm --force"
alias docker-remove-stopped-containers="docker ps -aq -f status=exited -f status=created | xargs docker rm --force"
alias docker-remove-dangling-images="docker images -qf dangling=true | xargs docker rmi"
alias docker-remove-dangling-volumes="docker volume ls -qf dangling=true | xargs docker volume rm"
alias docker-clean="docker-remove-stopped-containers && docker-remove-dangling-volumes && docker-remove-dangling-images"

# show imported packages in go
alias go-list-imports="go list -f '{{join .Deps \"\n\"}}' | xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}'"

alias noled="while true; do sudo smc -k ACLC -w 01; sleep 0.5; done"  # turn off magsafe charger led
