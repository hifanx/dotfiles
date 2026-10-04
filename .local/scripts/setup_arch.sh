#!/bin/bash

# Install base-devel if it is not installed
if ! pacman -Qqg base-devel &>/dev/null; then
  echo "base-devel is not installed. Installing..."
  sudo pacman -S --needed --noconfirm base-devel
  echo "base-devel is now installed."
fi

# Install git if it is not installed
if ! command -v git &>/dev/null; then
  echo "git is not installed. Installing..."
  sudo pacman -S --needed --noconfirm git
  echo "git is now installed."
fi

# Install yay if it is not installed
if ! command -v yay &>/dev/null; then
  echo "yay is not installed. Installing..."
  git clone https://aur.archlinux.org/yay-bin.git /tmp/buildyay &&
    cd /tmp/buildyay &&
    makepkg -o &&
    makepkg -si --noconfirm &&
    cd "$OLDPWD" &&
    rm -rf /tmp/buildyay
  echo "yay is now installed."
fi

# Check if a filename was provided
if [ -z "$1" ]; then
  echo "No filename provided. Please provide a filename as an argument."
  exit 1
fi

# Check if the provided filename exists
if [ ! -f "$1" ]; then
  echo "File not found. Please provide a valid filename."
  exit 1
fi

# Read packages from the file into an array
mapfile -t packages < <(grep -v '^#' "$1")

# Install all packages at once
yay -S --needed --noconfirm "${packages[@]}"
