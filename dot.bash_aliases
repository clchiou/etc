alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias gg='git grep'
alias tree='tree -C'
alias vn='vi +NERDTree'

mq() {
  local CMD="${1}"; shift; (set -x; hg ${CMD} --mq "$@")
}

# Workaround?
alias tmux='TERM=linux tmux'
