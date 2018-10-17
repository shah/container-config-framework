#!/usr/bin/env bash
#
# Install CCF from GitHub and setup local symlinks into /etc, /usr/lib, etc.
#
# TODO: make this script smarter by checking if CCF is already installed and
#       doing a git pull to upgrade instead.
# TODO: only create jsonnet symlink if jsonnet is not already present

export CCF_SRC_REPO_URL=https://github.com/shah/container-config-framework
export CCF_INSTALL_PATH="${CCF_INSTALL_PATH:-default /opt/container-config-framework}"
export CCF_COMPONENT_NAME="${CCF_COMPONENT_NAME:-default container-conf}"

sudo apt install make git jq

sudo mkdir -p $CCF_INSTALL_PATH
sudo git clone $CCF_SRC_REPO_URL $CCF_INSTALL_PATH
sudo ln -s $CCF_INSTALL_PATH/bin/jsonnet-v0.11.2 /usr/bin/jsonnet
sudo ln -s $CCF_INSTALL_PATH/etc /etc/$CCF_COMPONENT_NAME
sudo ln -s $CCF_INSTALL_PATH/lib /usr/lib/$CCF_COMPONENT_NAME

cd /usr/lib/$CCF_COMPONENT_NAME
make check-dependencies