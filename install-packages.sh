#!/usr/bin/env bash

# Install packages that are normally not installed by default.

readonly PACKAGES=(
  jq
  patch
  sqlite3
  tree

  bzip2
  tar
  unzip
  xz-utils
  zip

  # We choose ripgrep over ag (The Silver Searcher) because the latter does not appear to be in
  # active development.
  ripgrep

  # build-essential without the Debian packaging stuff.
  binutils
  g++
  gcc
  libc6-dev
  make

  # Replacement of pkg-config.
  pkgconf

  # Python packages.
  python3-venv

  # OpenSSL development files.
  libssl-dev

  # Use capnproto provided by Ubuntu 24.04.  It is version 1.0.1, which is not far from the latest
  # version 1.0.2.  However, you still need to install capnproto-java yourself.
  capnproto
  libcapnp-dev
)

set -o xtrace

sudo apt-get install "${PACKAGES[@]}"
