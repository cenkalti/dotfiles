export CDPATH=$HOME:$HOME/projects

if [[ -d /opt/homebrew ]]; then  # m1 macos
    export PATH=/opt/homebrew/sbin:$PATH
    export PATH=/opt/homebrew/bin:$PATH
elif [[ -f /usr/local/bin/brew ]]; then  # intel macos
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/bin:$PATH
elif [[ -f /home/linuxbrew/.linuxbrew/bin ]]; then  # linux
    export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
    export PATH=/home/linuxbrew/.linuxbrew/sbin:$PATH
fi

if [[ -d $HOME/go/bin ]]; then
    export PATH=$HOME/go/bin:$PATH
fi

if type direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

if [[ -d $HOME/.toolbox/bin ]]; then
    export PATH="$HOME/.toolbox/bin:$PATH"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm