#!/usr/bin/env bash

# Install packages that are normally not installed by default.

set -o xtrace

sudo apt-get install \
  python3-venv \
  ripgrep \
  sqlite3 \
  tree \
  unzip \
  zip \
