#!/usr/bin/env bash

# Compute ${ETC} relative to ${HOME} before we `cd` to ${HOME}.
ETC="$(realpath "$(dirname $0)")"
ETC="${ETC#${HOME}/}"

cd "${HOME}"

# Create symlinks for dot files.
DOTFILES=(
  .bashrc
  .bash_profile
)
for dotfile in "${DOTFILES[@]}"; do
  src="${ETC%%/}/dot${dotfile}-macos"
  if [[ -e "${dotfile}" ]]; then
    echo "Skip ${dotfile}"
  else
    echo "Link ${src}"
    ln -s "${src}" "${dotfile}"
  fi
done
