alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ag='ag --pager less'
alias gg='git grep'
alias tree='tree -C'
alias vn='vi +NERDTree'

gcd() {
  cd "$(git rev-parse --show-toplevel)/${1:-}"
  pwd
}
