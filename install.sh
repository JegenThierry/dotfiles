#!/bin/bash

# Install essential packages using pacman
sudo pacman -S --noconfirm --needed git curl vim zsh unzip

# Clone and install yay AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -Rf ./yay

# Install packages via yay
yay -S --noconfirm --needed gcc make ripgrep fd unzip neovim waybar btop brightnessctl wlogout ttf-ms-win11-auto vscodium-bin thunderbird thunar catppuccin-cursors-macchiato papirus-icon-theme gtk-engine-murrine gnome-themes-extra nwg-look hyprpaper polkit-gnome flatpak chromium vlc shotwell dotnet-sdk luarocks krita gimp inkscape hyprshot docker docker-compose

# Remove dolphin package
yay -R dolphin

# Install Nerd Fonts
mkdir -p ~/.fonts
cd ~/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Noto.zip
unzip ./JetBrainsMono.zip
unzip ./Noto.zip
rm ./*.zip
cd ~

# Clone and install Qogir theme
mkdir -p ~/Downloads
cd ~/Downloads
git clone https://github.com/vinceliuice/Qogir-theme.git
cd Qogir-theme
./install.sh
cd ~

# Clean up configuration files
rm -rf ~/.config/nvim ~/.config/hypr ~/.config/waybar ~/.config/kitty

# Clone and apply dotfiles
cd ~/Downloads
git clone https://github.com/JegenThierry/dotfiles.git
cd dotfiles
mv ./btop ~/.config/
mv ./nvim ~/.config/
mv ./kitty ~/.config/
mv ./waybar ~/.config/
mv ./hypr ~/.config/
mv zshrc ~/.zshrc

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Organize pictures folder
mkdir -p ~/Pictures
mv wallpapers ~/Pictures

echo "Installation and configuration completed!"
