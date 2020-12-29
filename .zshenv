export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CDPATH=$HOME:$HOME/projects

if [[ -f /usr/local/bin/brew ]]; then
    export PATH=$PATH:/usr/local/sbin
    export PATH=$PATH:/usr/local/bin
fi

if [[ -f /home/linuxbrew/.linuxbrew/bin ]]; then
    export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
    export PATH=$PATH:/home/linuxbrew/.linuxbrew/sbin
fi

if [[ -d $HOME/.gem/ruby/1.9/bin ]]; then
    export PATH=$PATH:$HOME/.gem/ruby/1.9/bin
fi

PATH=$PWD/node_modules/.bin:$PATH
if [[ -d $HOME/node_modules/.bin ]]; then
    export PATH=$PATH:$HOME/node_modules/.bin
fi

if [[ -d $HOME/.cabal/bin ]]; then
    export PATH=$PATH:$HOME/.cabal/bin
fi

if [[ -d /usr/local/opt/awscli@1 ]]; then
    export PATH=$PATH:/usr/local/opt/awscli@1/bin
fi

if type go &> /dev/null; then
    export PATH=$(go env GOPATH)/bin:$(go env GOROOT)/bin:$PATH
fi

if [[ -d $HOME/go/bin ]] then
    export PATH=$HOME/go/bin:$PATH
fi

if [[ -d /usr/local/opt/mysql-client/bin ]]; then
    export PATH="/usr/local/opt/mysql-client/bin:$PATH"
fi

if [[ -d $HOME/.toolbox/bin ]]; then
    export PATH="$HOME/.toolbox/bin:$PATH"
fi

VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

if [[ -f /usr/local/bin/direnv ]]; then
    eval "$(direnv hook zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
