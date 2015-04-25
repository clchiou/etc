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
