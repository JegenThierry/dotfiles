#!/bin/bash

#Exit on any error
set -e

# Ask user if they want the gaming setup
read -p "Do you want the gaming setup? (y/N): " gaming_choice
gaming_choice=${gaming_choice,,}  # Convert to lowercase

# Cleanup unnecessary programs
echo "Removing unnecessary programs..."
sudo dnf remove -y libreoffice-* gnome-tour mediawriter yelp kmines ksudoku katomic kpat bomber kdeconnect kget konqueror kmix juk kontact kaddressbook kjots kolourpaint krdc krfb ksnapshot ktimer kteatime khelpcenter

# Enable RPM Fusion
echo "Enabling RPM Fusion..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
         https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Update System
sudo dnf upgrade -y

# Install required programs
echo "Installing essential programs..."
PKGS=(
    fish
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
    dotnet-sdk-8.0
    luarocks
    fzf
    docker
    docker-compose
    curl
    bat
    stow
    starship
    zoxide
    eza
    gnome-tweaks
    shotwell
    cabextract
    xorg-x11-font-utils
    fontconfig
)

if [[ "$gaming_choice" == "y" ]]; then
  PKGS+=(steam)
fi

sudo dnf install -y "${PKGS[@]}"

# Ensure Flathub is configured
echo "Ensuring Flathub is available"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Flatpak programs
echo "Installing Flatpak programs..."
FLATPAKS=(
    com.discordapp.Discord
    com.github.tchx84.Flatseal
    org.remmina.Remmina
    md.obsidian.Obsidian
    com.spotify.Client
    org.mozilla.Thunderbird
    io.dbeaver.DBeaverCommunity
    com.usebruno.Bruno
    org.signal.Signal
    com.mattjakeman.ExtensionManager
)

if [[ "$gaming_choice" == "y" ]]; then
  FLATPAKS+=(com.usebottles.bottles moe.launcher.the-honkers-railway-launcher)
fi

flatpak install -y "${FLATPAKS[@]}"
flatpak update -y

# Install JetBrainsMono Nerd Font
echo "Installing JetBrainsMono Nerd Font..."
mkdir -p ~/.fonts && cd ~/.fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Ubuntu.zip
unzip -q JetBrainsMono.zip && rm JetBrainsMono.zip && rm *.md && rm *.txt
unzip -q Ubuntu.zip && rm *.zip && rm *.md && rm *.txt
cd ~

# Install Microsoft fonts
echo "Installing Microsoft fonts..."
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
wget -q -O - https://gist.githubusercontent.com/Blastoise/72e10b8af5ca359772ee64b6dba33c91/raw/2d7ab3caa27faa61beca9fbf7d3aca6ce9a25916/clearType.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/b74e06f739610c4a867cf94b27637a56/raw/96926e732a38d3da860624114990121d71c08ea1/tahoma.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/64ba4acc55047a53b680c1b3072dd985/raw/6bdf69384da4783cc6dafcb51d281cb3ddcb7ca0/segoeUI.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/d959d3196fb3937b36969013d96740e0/raw/429d8882b7c34e5dbd7b9cbc9d0079de5bd9e3aa/otherFonts.sh | bash

# Install Multimedia Codecs
echo "Installing multimedia codecs..."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf4 update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# Install AMD hardware codecs
echo "Installing AMD hardware codecs..."
sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

if [[ "$gaming_choice" == "y" ]]; then
  sudo dnf swap -y mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
  sudo dnf swap -y mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
fi

# Install fnm (not in default Fedora repos; use the official installer into ~/.local/bin)
if ! command -v fnm &> /dev/null; then
    echo "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
fi

# Setup Neovim (Kickstart)
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Setting up Neovim configuration..."
    git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
fi

# Install Colloid icons and cursors
echo "Installing Colloid icon theme and cursors..."
git clone https://github.com/vinceliuice/Colloid-icon-theme.git
cd Colloid-icon-theme && ./install.sh
cd cursors && ./install.sh
cd ~ && rm -rf Colloid-icon-theme

echo "Installing Catppuccin GTK-Theme"
if [ ! -d ~/Downloads/Catppuccin-GTK-Theme ]; then
    git clone https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme.git ~/Downloads/Catppuccin-GTK-Theme
    (cd ~/Downloads/Catppuccin-GTK-Theme/themes && ./install.sh)
fi

echo "Installing Zed"
if ! command -v zed &> /dev/null; then
    curl -f https://zed.dev/install.sh | sh
fi

echo "Installing JetBrains Toolbox (via Flatpak)"
flatpak install -y flathub com.jetbrains.JetBrains-Toolbox

# Docker configuration
echo "Configuring Docker..."
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# Optimizations
echo "Applying optimizations..."
sudo systemctl disable NetworkManager-wait-online.service
sudo rm -f /etc/xdg/autostart/org.gnome.Software.desktop

# Symlink dotfiles using Stow (must run before Fisher so fish_plugins is in place)
echo "Symlinking dotfiles with GNU Stow..."
REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
(cd "$REPO_DIR" && stow fish ssh zed git)

# Install Fisher and sync plugins from fish_plugins
if ! fish -c 'functions -q fisher' 2>/dev/null; then
    echo "Installing Fisher..."
    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
fi
echo "Syncing Fisher plugins from fish_plugins..."
fish -c 'fisher update'

# Make fish the default login shell
FISH_BIN="$(command -v fish)"
if ! grep -qx "$FISH_BIN" /etc/shells; then
    echo "$FISH_BIN" | sudo tee -a /etc/shells > /dev/null
fi
if [ "$SHELL" != "$FISH_BIN" ]; then
    echo "Setting fish as default shell..."
    chsh -s "$FISH_BIN"
fi

echo "Installation complete! Please reboot your system."
