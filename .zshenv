export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CDPATH=$HOME:$HOME/projects

if [[ -d /opt/homebrew ]]; then
    export PATH=/opt/homebrew/sbin:$PATH
    export PATH=/opt/homebrew/bin:$PATH
elif [[ -f /usr/local/bin/brew ]]; then
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/bin:$PATH
elif [[ -f /home/linuxbrew/.linuxbrew/bin ]]; then
    export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
    export PATH=/home/linuxbrew/.linuxbrew/sbin:$PATH
fi

PATH=$PWD/node_modules/.bin:$PATH
if [[ -d $HOME/node_modules/.bin ]]; then
    export PATH=/node_modules/.bin:$PATH
fi

if type go &> /dev/null; then
    export PATH=$(go env GOPATH)/bin:$(go env GOROOT)/bin:$PATH
fi

if [[ -d $HOME/go/bin ]] then
    export PATH=/go/bin:$PATH
fi

if [[ -d $HOME/.toolbox/bin ]]; then
    export PATH="$HOME/.toolbox/bin:$PATH"
fi

if type direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
