export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
export PATH=/usr/local/bin:/usr/local/sbin:${PATH}
export PATH=$HOME/.gem/ruby/1.8/bin:${PATH}
export GOROOT=/usr/local/Cellar/go/1.2/libexec
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$HOME/bin:${PATH}
export PATH=$PATH:$HOME/node_modules/.bin

if which go > /dev/null; then
	export PATH=$PATH:$(go env GOROOT)/bin
fi
