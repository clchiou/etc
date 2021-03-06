#!/usr/bin/env bash

abspath() {
  local curdir="$(pwd)"
  cd "${1}"
  pwd
  cd "${curdir}"
}

# Compute ${ETC} relative to ${HOME} before we `cd` to ${HOME}
ETC="$(abspath "$(dirname $0)")"
ETC="${ETC#${HOME}/}"

cd "${HOME}"

# Create symlinks for dot files
DOTFILES=(
  .bash_aliases
  .bash_completion
  .bash_completion.d
  .gitconfig
  .hgrc
  .jslintrc
  .pylintrc
  .tmux.conf
  .vimrc
)
for dotfile in "${DOTFILES[@]}"; do
  src="${ETC%%/}/dot${dotfile}"
  if [[ -e "${dotfile}" ]]; then
    echo "Skip ${dotfile}"
  else
    echo "Link ${src}"
    ln -s "${ETC%%/}/dot${dotfile}" "${dotfile}"
  fi
done

# Create symlink from ~/.config/git
mkdir -p ".config"
if [[ -e ".config/git" ]]; then
  echo "Skip .config/git"
else
  echo "Link .config/git"
  ln -s "../${ETC%%/}/git" ".config/git"
fi

# Patch ~/.bashrc
if cmp -s /etc/skel/.bashrc .bashrc; then
  echo "Patch .bashrc"
  patch < "${ETC%%/}/dot.bashrc.patch"
else
  echo "Different from /etc/skel/.bashrc. Skip patching .bashrc"
fi

# Install Vim plugins
if [[ ! -d "${HOME}/.vim/bundle/Vundle.vim" ]]; then
  echo "Install Vundle"
  mkdir -p "${HOME}/.vim/bundle"
  git clone "https://github.com/VundleVim/Vundle.vim.git" \
    "${HOME}/.vim/bundle/Vundle.vim"
  vim +PluginInstall +qall
fi
