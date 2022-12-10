#!/usr/bin/env bash
# setup script for WSL Debian
# author: Yuzhou "Joe" Mo (@yuzhoumo)
# license: GNU GPLv3

# install apt packages
printf "\n\x1b[33m### Adding missing Debian packages...\x1b[0m\n\n"
sudo apt update -y && sudo apt upgrade -y
sudo apt install curl man-db xz-utils -y

# install nix
if [ ! -d ~/.nix-profile ]; then
  printf "\n\x1b[33m### Installing NIX package manager...\x1b[0m\n\n"
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
  . ~/.nix-profile/etc/profile.d/nix.sh
fi

# install nix packages
printf "\n\x1b[33m### Installing NIX packages...\x1b[0m\n\n"
nix-env -iA \
  nixpkgs.bat \
  nixpkgs.gcc \
  nixpkgs.git \
  nixpkgs.neofetch \
  nixpkgs.neovim \
  nixpkgs.nodejs \
  nixpkgs.openssh \
  nixpkgs.python311 \
  nixpkgs.rustup \
  nixpkgs.tmux \
  nixpkgs.unzip \
  nixpkgs.yarn \
  nixpkgs.zsh

# bootstrap rust tools
rustup default stable

# set zsh as shell
printf "\n\x1b[33m### Setting zsh as default shell...\x1b[0m\n\n"
grep -w 'zsh' /etc/shells || command -v zsh | sudo tee -a /etc/shells
[[ $SHELL =~ ^.*/zsh$ ]] || sudo chsh -s $(which zsh) $USER

# set dotfiles
if [ ! -d ~/code/joe/dotfiles ]; then
  printf "\n\x1b[33m### Installing dotfiles...\x1b[0m\n\n"

  http_url="https://github.com/yuzhoumo/dotfiles.git"
  ssh_url="git@github.com:yuzhoumo/dotfiles.git"

  mkdir -p ~/code/yuzhoumo/dotfiles && cd ~/code/yuzhoumo
  git clone "${http_url}" && cd dotfiles && \
  git remote set-url origin "${ssh_url}" && ./sync.sh
fi

# install neovim plugins
printf "\n\x1b[33m### Installing neovim plugins...\x1b[0m\n\n"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

printf "\n\n\x1b[32mSetup complete! Restart the terminal.\x1b[0m\n\n"
