#!/bin/bash

if [ "$(pwd)" != "${HOME}" ]; then
  echo "You must run install.sh under your home directory"
  exit 1
fi

abspath() {
  local curdir="$(pwd)"
  cd "${1}"
  pwd
  cd "${curdir}"
}

ETC_DIR="$(abspath "$(dirname $0)")"
ETC_DIR="${ETC_DIR#${HOME}/}"

RCFILES=".bash_aliases"
RCFILES+=" .gitconfig"
RCFILES+=" .gitexcludes"
RCFILES+=" .hgrc"
RCFILES+=" .jslintrc"
RCFILES+=" .pylintrc"
RCFILES+=" .screenrc"
RCFILES+=" .tmux.conf"
RCFILES+=" .vimrc"
for rcfile in ${RCFILES}; do
  src="${ETC_DIR%%/}/dot${rcfile}"
  if [ -f "${rcfile}" ]; then
    echo "Skip ${rcfile}"
  else
    echo "Link ${src}"
    ln -s "${ETC_DIR%%/}/dot${rcfile}" "${rcfile}"
  fi
done

if cmp -s /etc/skel/.bashrc .bashrc; then
  echo "Patch .bashrc"
  patch < "${ETC_DIR%%/}/dot.bashrc.patch"
else
  echo "Different from /etc/skel/.bashrc. Skip patching .bashrc"
fi

# Install Vim plugins.

if [ ! -d "${HOME}/.vim/bundle/Vundle.vim" ]; then
  echo "Install Vundle"
  mkdir -p "${HOME}/.vim/bundle"
  git clone "https://github.com/VundleVim/Vundle.vim.git" \
    "${HOME}/.vim/bundle/Vundle.vim"
  vim +PluginInstall +qall
fi

if [ ! -f "${HOME}/.vim/syntax/python.vim" ]; then
  echo "Install python.vim"
  mkdir -p "${HOME}/.vim/syntax"
  wget -O "${HOME}/.vim/syntax/python.vim" \
    "http://www.vim.org/scripts/download_script.php?src_id=21056"
fi
