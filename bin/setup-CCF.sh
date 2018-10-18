#!/usr/bin/env bash
#
# Install CCF from GitHub and setup local symlinks into /etc, /usr/lib, etc.
#
# TODO: make this script smarter by checking if CCF is already installed and
#       doing a git pull to upgrade instead.
# TODO: only create jsonnet symlink if jsonnet is not already present

export CCF_SRC_REPO_URL=https://github.com/shah/container-config-framework
export CCF_HOME="${CCF_HOME:-/opt/container-config-framework}"

sudo apt install make git jq

sudo mkdir -p $CCF_HOME
sudo git clone $CCF_SRC_REPO_URL $CCF_HOME
sudo chmod +x $CCF_HOME/bin/*
sudo ln -s $CCF_HOME/bin/ccfinit /usr/bin/ccfinit
sudo ln -s $CCF_HOME/bin/ccfmake /usr/bin/ccfmake
sudo ln -s $CCF_HOME/bin/jsonnet-v0.11.2 /usr/bin/jsonnet

cd $CCF_HOME/lib/$CCF_COMPONENT_NAME
make check-dependencies