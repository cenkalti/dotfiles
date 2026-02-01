SPACESHIP_PROMPT_ORDER=(
  time           # Time stamps section
  user           # Username section
  dir            # Current directory section
  host           # Hostname section
  git            # Git section (git_branch + git_status)
  package        # Package version

  node           # Node.js section
  python         # Python section
  golang         # Go section
  lua            # Lua section

  docker         # Docker section
  docker_compose # Docker section
  aws            # Amazon Web Services section
  kubectl        # Kubectl context section
  exec_time      # Execution time
  async          # Async jobs indicator
  line_sep       # Line break
  battery        # Battery level and status
  jobs           # Background jobs indicator
  exit_code      # Exit code section
  sudo           # Sudo indicator
  char           # Prompt character
)

SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_CONTEXT_SHOW=true
