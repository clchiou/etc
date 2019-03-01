alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ag='ag --pager less'
alias gg='git grep'
alias tree='tree -C'
alias vn='vi +NERDTree'

mq() {
  local CMD="${1}"; shift; (set -x; hg ${CMD} --mq "$@")
}
