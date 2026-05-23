#!/bin/bash

# Setup script for Arch (EndeavourOS) Dotfiles
# Exit on error
set -e

echo "Starting setup..."

# 1. Update System
echo "Updating system..."
yay -Syu --noconfirm

# 2. Install Core Packages (Pacman + AUR)
echo "Installing core packages..."
PACKAGES=(
    fish
    fnm
    flatpak
    gcc
    make
    git
    rsync
    rclone
    ripgrep
    fd
    unzip
    neovim
    dotnet-sdk
    luarocks
    fzf
    docker
    docker-compose
    steam
    curl
    brave-bin
    bat
    stow
    starship
    zoxide
    eza
    jetbrains-toolbox
)

yay -S --needed --noconfirm "${PACKAGES[@]}"

# 3. Install Flatpaks
echo "Installing Flatpaks..."
FLATPAKS=(
    com.discordapp.Discord
    com.github.tchx84.Flatseal
    org.remmina.Remmina
    md.obsidian.Obsidian
    com.usebottles.bottles
    com.spotify.Client
    org.mozilla.Thunderbird
    moe.launcher.the-honkers-railway-launcher
    io.dbeaver.DBeaverCommunity
    com.usebruno.Bruno
    org.signal.Signal
)

for app in "${FLATPAKS[@]}"; do
    flatpak install -y flathub "$app"
done

# 4. Install Zed
if ! command -v zed &> /dev/null; then
    echo "Installing Zed..."
    curl -f https://zed.dev/install.sh | sh
fi

# 5. Install Fonts
echo "Setting up fonts..."
mkdir -p ~/.fonts
cd ~/.fonts
if [ ! -f "JetBrainsMono.zip" ]; then
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
    unzip -o ./JetBrainsMono.zip
    rm ./JetBrainsMono.zip
fi
if [ ! -f "FiraCode.zip" ]; then
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
    unzip -o ./FiraCode.zip
    rm ./FiraCode.zip
fi
fc-cache -f
cd - > /dev/null

# 6. Install Icons and Cursors
if [ ! -d "$HOME/Downloads/Colloid-icon-theme" ]; then
    echo "Installing Colloid icon theme..."
    cd ~/Downloads
    git clone https://github.com/vinceliuice/Colloid-icon-theme.git
    cd Colloid-icon-theme
    ./install.sh
    cd cursors
    ./install.sh
    cd ~
    rm -rf ~/Downloads/Colloid-icon-theme
fi

# 7. Setup Neovim (Kickstart)
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Setting up Neovim configuration..."
    git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
fi

# 8. Docker configuration
echo "Configuring Docker..."
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# 9. Optimizations
echo "Applying optimizations..."
sudo systemctl disable NetworkManager-wait-online.service

# 10. Symlink dotfiles using Stow (must run before Fisher so fish_plugins is in place)
echo "Symlinking dotfiles with GNU Stow..."
stow fish ssh zed git

# 11. Install Fisher and sync plugins from fish_plugins
if ! fish -c 'functions -q fisher' 2>/dev/null; then
    echo "Installing Fisher..."
    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
fi
echo "Syncing Fisher plugins from fish_plugins..."
fish -c 'fisher update'

# 12. Make fish the default login shell
FISH_BIN="$(command -v fish)"
if ! grep -qx "$FISH_BIN" /etc/shells; then
    echo "$FISH_BIN" | sudo tee -a /etc/shells > /dev/null
fi
if [ "$SHELL" != "$FISH_BIN" ]; then
    echo "Setting fish as default shell..."
    chsh -s "$FISH_BIN"
fi

echo "Setup complete! Please log out and back in for changes to take effect."
