# Do not put inside ~/.ssh to avoid iCloud sync issue.
SOCKET_PATH=${HOME}/.ssh_auth_sock

if [ ! -S $SOCKET_PATH ]; then
  eval $(ssh-agent) > /dev/null
  ln -sf "$SSH_AUTH_SOCK" $SOCKET_PATH
fi
export SSH_AUTH_SOCK=$SOCKET_PATH
ssh-add -l > /dev/null || ssh-add
