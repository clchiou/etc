#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# Compute ${ETC} relative to ${HOME} before `cd`-ing to ${HOME}.
readonly ETC="$(realpath --relative-to="${HOME}" "$(dirname $0)")"
cd "${HOME}"

# Create dotfile symlinks.
readonly DOTFILES=(
  .bash_aliases
  .gitconfig
  .pylintrc
  .style.yapf
  .tmux.conf
  .vimrc

  .cargo/config.toml
  .config/git

  .bashrc.d
)
for dotfile in "${DOTFILES[@]}"; do
  if [[ -e "${dotfile}" ]]; then
    echo "skip: ${dotfile}"
    continue
  fi

  # It is subtle, but do not use `dirname` here.
  dst_dir="${dotfile%/*}"
  if [[ "${dotfile}" != ${dst_dir} ]]; then
    if [[ ! -d "${dst_dir}" ]]; then
      echo "mkdir: ${dst_dir}"
      mkdir --parents "${dst_dir}"
    fi
    rel_path="$(realpath --relative-to="${dst_dir}" .)/"
  else
    rel_path=
  fi

  src="${rel_path}${ETC}/dot${dotfile}"
  echo "link: ${src}"
  ln --symbolic "${src}" "${dotfile}"
done

# This seems like a good practice.
chmod 0700 .config

# Patch ~/.bashrc
if cmp --silent /etc/skel/.bashrc .bashrc; then
  echo "patch: .bashrc"
  patch < "${ETC}/dot.bashrc.patch"
else
  echo "skip patching: .bashrc"
fi

# Install Vim plugins
if [[ ! -d .vim/bundle/Vundle.vim ]]; then
  echo "install vundle"
  mkdir --parents .vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
  vim +PluginInstall +qall
fi
