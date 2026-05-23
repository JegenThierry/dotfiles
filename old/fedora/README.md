# Dotfiles Fedora

The following dotfiles are for a fresh install of Fedora Linux with the default Gnome desktop. Do note this is my personal way of configuring fedora and may differ from your personal preferences.

## Cleanup

Uninstall the following programs with the following command:

```bash
sudo dnf remove -y \
  gnome-tour \
  mediawriter \
  yelp
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
**Setup: Special**

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

sudo dnf group upgrade core -y
sudo dnf4 group install core -y

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo dnf4 group install multimedia
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing # Switch to full FFMPEG.
sudo dnf upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin # Installs gstreamer components. Required if you use Gnome Videos and other dependent applications.
sudo dnf group install -y sound-and-video # Installs useful Sound and Video complementary packages.

sudo dnf install ffmpeg-libs libva libva-utils -y
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686 -y
sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686 -y
```

## Installing Software

**DNF:**

```bash
sudo dnf install -y \
  fish \
  flatpak \
  gcc \
  make \
  git \
  rsync \
  rclone \
  ripgrep \
  fd \
  unzip \
  neovim \
  dotnet-sdk \
  luarocks \
  fzf \
  docker \
  docker-compose \
  steam \
  curl \
  bat \
  stow \
  starship \
  zoxide \
  eza \
  gnome-tweaks
```

**Flatpaks:**

```bash
flatpak install flathub \
  com.discordapp.Discord \
  com.github.tchx84.Flatseal \
  org.remmina.Remmina \
  md.obsidian.Obsidian \
  com.usebottles.bottles \
  com.spotify.Client \
  org.mozilla.Thunderbird \
  moe.launcher.the-honkers-railway-launcher \
  io.dbeaver.DBeaverCommunity \
  com.usebruno.Bruno \
  org.signal.Signal \
  com.mattjakeman.ExtensionManager
```

**Zed:**

```bash
curl -f https://zed.dev/install.sh | sh
```

**fnm (Node version manager — fish-native, replaces NVM):**

```bash
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
```

`config.fish` initializes it with `fnm env --use-on-cd --shell fish | source`, so `.nvmrc` files auto-switch on `cd`.

**Jetbrains Toolbox: (Note: the provided version may be outdated)**

```bash
mkdir ~/Applications
cd ~/Applications
curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-3.2.0.65851.tar.gz" -o "jetbrains-toolbox.tar.gz"
tar -xzf ./jetbrains-toolbox.tar.gz
rm ./jetbrains-toolbox.tar.gz
```

## Fonts

Download and extract `JetBrainsMono` and `FiraCode`:

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

## Icons and Cursors

Using the colloid-icon-theme:

```bash
cd ~/Downloads
git clone https://github.com/vinceliuice/Colloid-icon-theme.git && \
cd Colloid-icon-theme && \
./install.sh && \
cd cursors && \
./install.sh
cd ~/Downloads
sudo rm -R ./Colloid-icon-theme
cd
```

## Configurations

**Fisher (fish plugin manager):**

```bash
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
```

Plugins are declared in `fish/.config/fish/fish_plugins`. After stowing, `fisher update` installs them:

```bash
fish -c 'fisher update'
```

**Set fish as the default login shell:**

```bash
echo "$(command -v fish)" | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"
```

**Kickstart nvim config:**

```bash
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

**SSH Keys:**

```bash
chmod 600 key1 key2
chmod 644 key1.pub key2.pub
```

## Docker

```bash
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

## Optimizations

```bash
sudo systemctl disable NetworkManager-wait-online.service # Disable NetworkManager-wait-online.service
sudo rm /etc/xdg/autostart/org.gnome.Software.desktop # Disable GNOME-Software
```
