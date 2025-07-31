# Dotfiles Fedora

The following dotfiles are for a fresh install of Fedora Linux with the default Gnome desktop. Do note this is my personal way of configuring fedora and may differ from your personal preferences.

## Cleanup

Uninstall the following programs with the following command:

```bash
sudo dnf remove -y libreoffice-* gnome-tour mediawriter yelp
```

## Before continuing some initial Setup is required:

### Install Updates

```bash
sudo dnf group update core
```

```bash
sudo dnf4 group install core
```

```bash
sudo dnf upgrade -y
```

### If supported do some Firmware upgrades

```bash
sudo fwupdmgr refresh --force
sudo fwupdmgr get-devices # Lists devices with available updates.
sudo fwupdmgr get-updates # Fetches list of available updates.
sudo fwupdmgr update
```

## Installing Programs

Install the following programs:

```bash
sudo dnf install -y \
  git curl vim zsh unzip gnome-tweaks \
  gcc make ripgrep fd neovim fzf shotwell \
  dotnet-sdk-8.0 luarocks docker docker-compose \
  curl cabextract xorg-x11-font-utils fontconfig
```

Install the following programs (with gaming):

```bash
sudo dnf install -y \
  git curl vim zsh unzip gnome-tweaks \
  gcc make ripgrep fd neovim fzf shotwell \
  dotnet-sdk-8.0 luarocks docker docker-compose \
  steam curl cabextract xorg-x11-font-utils fontconfig
```

Install programs via flatpak:

```bash
flatpak install \
  com.discordapp.Discord \
  org.telegram.desktop \
  com.github.tchx84.Flatseal \
  org.remmina.Remmina \
  md.obsidian.Obsidian \
  com.mattjakeman.ExtensionManager
```

Install programs via flatpak (with gaming):

```bash
flatpak install \
  com.discordapp.Discord \
  org.telegram.desktop \
  com.github.tchx84.Flatseal \
  org.remmina.Remmina \
  md.obsidian.Obsidian \
  com.mattjakeman.ExtensionManager \
  com.usebottles.bottles \
  com.spotify.Client \
  org.mozilla.Thunderbird
```

## Adding Fonts

I use JetBrainsMono Nerd Font as my font for coding.

```bash
mkdir ~/.fonts
cd ~/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
unzip ./JetBrainsMono.zip
unzip ./FiraCode.zip
rm ./*.zip
cd
```

## Media Codes and Hardware Acceleration (AMD Only)

```bash
sudo dnf4 group install multimedia
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf group install -y sound-and-video
```

```bash
sudo dnf install ffmpeg-libs libva libva-utils
```

```bash
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
```

```bash
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
```

### Other Setups

Oh my zsh (https://ohmyz.sh/)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Node version manager (https://github.com/nvm-sh/nvm):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.zshrc && \
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
```

### Nvim config (kickstart nivm: https://github.com/nvim-lua/kickstart.nvim)

```bash
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

### Icons and Cursors

Clone and install the colloid icon-theme:

```bash
git clone https://github.com/vinceliuice/Colloid-icon-theme.git && \
cd Colloid-icon-theme && \
./install.sh && \
cd cursors && \
./install.sh
```

### Optimizations

Execute the following optimizations based on personal preferences:

```bash
sudo systemctl disable NetworkManager-wait-online.service # Disable NetworkManager-wait-online.service
sudo rm /etc/xdg/autostart/org.gnome.Software.desktop # Disable GNOME-Software
```
