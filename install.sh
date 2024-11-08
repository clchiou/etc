#!/usr/bin/env bash

# Compute ${ETC} relative to ${HOME} before we `cd` to ${HOME}
ETC="$(realpath "$(dirname $0)")"
ETC="${ETC#${HOME}/}"

cd "${HOME}"

# Create symlinks for dot files
DOTFILES=(
  .bash_aliases
  .gitconfig
  .pylintrc
  .style.yapf
  .tmux.conf
  .vimrc
)
for dotfile in "${DOTFILES[@]}"; do
  src="${ETC%%/}/dot${dotfile}"
  if [[ -e "${dotfile}" ]]; then
    echo "Skip ${dotfile}"
  else
    echo "Link ${src}"
    ln -s "${src}" "${dotfile}"
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

# Create symlink from ~/.cargo/config.toml
mkdir -p ".cargo"
if [[ -e ".cargo/config.toml" ]]; then
  echo "Skip .cargo/config.toml"
else
  echo "Link .cargo/config.toml"
  ln -s "../${ETC%%/}/dot.cargo/config.toml" ".cargo/config.toml"
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
