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

## Installing Programs

Install the following programs:

```bash
sudo dnf install -y \
  git curl vim zsh unzip gnome-tweaks \
  gcc make ripgrep fd neovim fzf shotwell \
  dotnet-sdk-10.0 luarocks docker docker-compose
```

Install the following programs (with gaming):

```bash
sudo dnf install -y \
  git curl vim zsh unzip gnome-tweaks \
  gcc make ripgrep fd neovim fzf shotwell \
  dotnet-sdk-10.0 luarocks docker docker-compose steam
```

Install programs via flatpak:

```bash
flatpak install \
  com.discordapp.Discord \
  com.github.tchx84.Flatseal \
  org.remmina.Remmina \
  md.obsidian.Obsidian \
  com.spotify.Client \
  org.mozilla.Thunderbird \
  io.dbeaver.DBeaverCommunity \
  com.usebruno.Bruno \
  com.mattjakeman.ExtensionManager \
  org.signal.Signal
```

Install programs via flatpak (with gaming):

```bash
flatpak install \
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
  com.mattjakeman.ExtensionManager \
  org.signal.Signal
```

**Zed:**

```bash
curl -f https://zed.dev/install.sh | sh
```

**Node Version Manager:**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

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

**Oh my Zsh:**

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**Installing Plugins**

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
```

**Kickstart nvim config:**

```bash
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

**Add NVM to .zshrc:**

```bash
echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.zshrc && \
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
```

**SSH Keys:**

```bash
chmod 600 key1 key2
chmod 644 key1.pub key2.pub
```

## Optimizations

```bash
sudo systemctl disable NetworkManager-wait-online.service # Disable NetworkManager-wait-online.service
sudo rm /etc/xdg/autostart/org.gnome.Software.desktop # Disable GNOME-Software
```
