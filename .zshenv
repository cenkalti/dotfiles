export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

if [[ -f /usr/local/bin/brew ]]; then
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/bin:$PATH
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
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:$(go env GOROOT)/bin
fi

if [[ -d ~/perl5 ]]; then
    if type perl &> /dev/null; then
        eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib);
    fi
fi
