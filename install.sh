#!/usr/bin/env bash

# Function to check prerequisites
check_prerequisites() {
  
  # check if git is installed
  if ! command -v git &>/dev/null; then
    echo "git is not installed, please install it"
  fi
  
  if ! command -v ffmpeg &>/dev/null; then
    echo "nvim is not installed, please install it"
  fi

}

# Create a config dir for nvim
mkdir -p $HOME/.config/nvim

# Clone the gitrepo into the directory
git clone https://github.com/Mr-Sunglasses/vimconfig $HOME/.config/nvim
