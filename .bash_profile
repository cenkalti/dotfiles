#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

MAC_PYTHON_PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin"
if [ -d "$MAC_PYTHON_PATH" ]
then
    PATH="$MAC_PYTHON_PATH:${PATH}"
    export PATH
fi
