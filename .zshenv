case ":$PATH:" in
	*:$HOME/bin:*) ;;     # do nothing if $PATH already contains $HOME/bin
	*) PATH=$HOME/bin:$PATH ;;  # in every other case, add it to the front
esac

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
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:$(go env GOROOT)/bin
fi

if [[ -d ~/perl5 ]]; then
    if type perl &> /dev/null; then
        eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib);
    fi
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

