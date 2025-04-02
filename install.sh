#!/bin/bash

#Exit on any error
set -e

# Ask user if they want the gaming setup
read -p "Do you want the gaming setup? (y/N): " gaming_choice
gaming_choice=${gaming_choice,,}  # Convert to lowercase

# Cleanup unnecessary programs
echo "Removing unnecessary programs..."
sudo dnf remove -y libreoffice-* gnome-tour mediawriter yelp kmines ksudoku katomic kpat bomber kdeconnect kget konqueror kmix juk kontact kaddressbook kjots kolourpaint krdc krfb ksnapshot ktimer kteatime khelpcenter

# Update System
sudo dnf upgrage -y

# Install required programs
echo "Installing essential programs..."
PKGS=(git curl vim zsh unzip gnome-tweaks gcc make ripgrep fd unzip neovim fzf shotwell dotnet-sdk-8.0 luarocks docker docker-compose curl cabextract xorg-x11-font-utils fontconfig)

if [[ "$gaming_choice" == "y" ]]; then
    PKGS+=(steam)
fi

sudo dnf install -y "${PKGS[@]}"

# Ensure Flathub is configured
echo "Ensuring Flathub is available"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Flatpak programs
echo "Installing Flatpak programs..."
FLATPAKS=(com.discordapp.Discord org.telegram.desktop com.github.tchx84.Flatseal org.remmina.Remmina md.obsidian.Obsidian com.mattjakeman.ExtensionManager)

if [[ "$gaming_choice" == "y" ]]; then
    FLATPAKS+=(com.usebottles.bottles)
fi

flatpak install -y "${FLATPAKS[@]}"
flatpak update -y

# Install JetBrainsMono Nerd Font
echo "Installing JetBrainsMono Nerd Font..."
mkdir -p ~/.fonts && cd ~/.fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip -q JetBrainsMono.zip && rm JetBrainsMono.zip && rm *.md && rm *.ofl
cd ~

# Install Microsoft fonts
echo "Installing Microsoft fonts..."
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
wget -q -O - https://gist.githubusercontent.com/Blastoise/72e10b8af5ca359772ee64b6dba33c91/raw/2d7ab3caa27faa61beca9fbf7d3aca6ce9a25916/clearType.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/b74e06f739610c4a867cf94b27637a56/raw/96926e732a38d3da860624114990121d71c08ea1/tahoma.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/64ba4acc55047a53b680c1b3072dd985/raw/6bdf69384da4783cc6dafcb51d281cb3ddcb7ca0/segoeUI.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/d959d3196fb3937b36969013d96740e0/raw/429d8882b7c34e5dbd7b9cbc9d0079de5bd9e3aa/otherFonts.sh | bash

# Enable RPM Fusion
echo "Enabling RPM Fusion..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                     https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Install Multimedia Codecs
echo "Installing multimedia codecs..."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# Install AMD hardware codecs
echo "Installing AMD hardware codecs..."
sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

if [[ "$gaming_choice" == "y" ]]; then
    sudo dnf swap -y mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
    sudo dnf swap -y mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
fi

# Install Oh My Zsh
echo "Installing Oh My Zsh..."

export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

unset RUNZSH
unset CHSH
unset KEEP_ZSHRC

# Install NVM
echo "Installing Node Version Manager (NVM)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Add NVM to .zshrc
echo "Adding NVM to .zshrc..."
echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc

# Install Colloid icons and cursors
echo "Installing Colloid icon theme and cursors..."
git clone https://github.com/vinceliuice/Colloid-icon-theme.git
cd Colloid-icon-theme && ./install.sh
cd cursors && ./install.sh
cd ~ && rm -rf Colloid-icon-theme

echo "Installing Zed"
curl -f https://zed.dev/install.sh | sh

echo "Installing JetBrainsToolbox"
cd ~/Downloads
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.5.4.38621.tar.gz
tar -xf ./jetbrains-toolbox-2.5.4.38621.tar.gz
./jetbrains-toolbox-2.5.4.38621/jetbrains-toolbox

echo "Installation complete! Please reboot your system."
