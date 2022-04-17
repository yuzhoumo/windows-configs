#!/usr/bin/env bash

packages=(
  man
  curl
  git
  python3
  wget
  neovim
  htop
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

# Create github directories
mkdir -p "${code_directory}/joe"
mkdir -p "${code_directory}/ppanda"

# Install dotfiles
printf "\nInstalling dotfiles...\n\n"
(
  # Use http to clone to avoid ssh authentication, then set origin
  http_url="https://github.com/${github_username}/${dotfiles_repo}.git"
  ssh_url="git@github.com:${github_username}/${dotfiles_repo}.git"
  cd "${code_directory}/joe" || exit
  [ -d "${dotfiles_repo}" ] || git clone "${http_url}"
  cd "${dotfiles_repo}" && git remote set-url origin "${ssh_url}" && \
    "./${dotfiles_script}"
)

printf "\nDone.\n"
exit 0
