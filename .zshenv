export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export CDPATH=$HOME:$HOME/projects

if [[ -f /usr/local/bin/brew ]]; then
    export PATH=$PATH:/usr/local/sbin
    export PATH=$PATH:/usr/local/bin
fi

if [[ -d $HOME/.gem/ruby/1.9/bin ]]; then
    export PATH=$PATH:$HOME/.gem/ruby/1.9/bin
fi

if [[ -d $HOME/node_modules/.bin ]]; then
    export PATH=$PATH:$HOME/node_modules/.bin
fi

if [[ -d $HOME/.cabal/bin ]]; then
    export PATH=$PATH:$HOME/.cabal/bin
fi

if type go &> /dev/null; then
    export GOROOT=$(go env GOROOT)
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
    export CDPATH=$CDPATH:$GOPATH/src
fi

if [[ -d ~/perl5 ]]; then
    if type perl &> /dev/null; then
        eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib);
    fi
fi

VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

if [[ -f /usr/local/bin/direnv ]]; then
  eval "$(direnv hook zsh)"
fi

if type docker-machine &> /dev/null; then
  eval $(docker-machine env default &> /dev/null)
fi
