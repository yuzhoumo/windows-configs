#!/usr/bin/env bash

packages=(
  man
  curl
  git
  python3
  python3-pip
  wget
  vim
  htop
  fzf
  universal-ctags
  zsh
  shellcheck
)

code_directory="${HOME}/github"
github_username="yuzhoumo"
dotfiles_repo="dotfiles"
dotfiles_script="sync.sh"

# Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Change default shell to zsh if not already set
current_user="${USER}"
[ "${SHELL}" != '/bin/zsh' ] && printf "\nChanging default shell to zsh...\n" && \
  sudo chsh -s /bin/zsh "${current_user}"

# Install packages
printf "\nInstalling packages...\n\n"
sudo apt update && sudo apt -y upgrade
printf "%s\n" "${packages[@]}" | xargs -I % sudo apt -y install "%"

# Install neovim (Debian neovim is outdated)
./install_nvim.sh

# Create github directories
mkdir -p "${code_directory}/joe"
mkdir -p "${code_directory}/ppanda"

# Install dotfiles
printf "\nInstalling dotfiles...\n\n"
(
  # Use http to clone to avoid authentication, then set origin to use ssh
  http_url="https://github.com/${github_username}/${dotfiles_repo}.git"
  ssh_url="git@github.com:${github_username}/${dotfiles_repo}.git"
  cd "${code_directory}/joe" || exit
  [ -d "${dotfiles_repo}" ] || git clone "${http_url}"
  cd "${dotfiles_repo}" && git remote set-url origin "${ssh_url}" && \
    "./${dotfiles_script}"
)

printf "\nDone.\n"

