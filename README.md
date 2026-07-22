# Dotfiles Fedora

The following dotfiles are for a fresh install of Fedora Linux. Do note this is my personal way of configuring Fedora and may differ from your personal preferences.

I am currently Using the KDE Desktop Enviroment.

## Cleanup

Uninstall the following programs with the following command:

**(KDE)**

```bash
sudo dnf remove -y \
  kmail \
  korganizer \
  kaddressbook \
  akregator \
  konversation \
  neochat \
  dragon \
  kmines \
  kpat \
  mediawriter \
  krdc \
  krfb \
  kdeconnectd \
  plasma-discover
```

## Before continuing, some initial setup is required:

**Set up RPM Fusion:**

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

**Updates:**

```bash
sudo dnf group update core -y
sudo dnf4 group install core -y
sudo dnf update -y
```

> It is recommended to reboot now.

**Updating Firmware:**

```bash
fwupdmgr refresh --force
fwupdmgr get-devices # Lists devices with available updates.
fwupdmgr get-updates # Fetches list of available updates.
fwupdmgr update
```

**Installing Video Codecs and Acceleration:**

```bash
sudo dnf4 group install multimedia -y
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing -y
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf group install -y sound-and-video
sudo dnf install ffmpeg-libs libva libva-utils -y
sudo dnf install mesa-va-drivers-freeworld -y
sudo dnf install mesa-va-drivers-freeworld.i686 -y
sudo dnf install openh264 gstreamer1-plugin-openh264 mozilla-openh264 -y
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
```

## Installing Software

**Software Packages:**

```bash
sudo dnf install -y \
  zsh \
  flatpak \
  gcc \
  make \
  golang \
  git \
  ripgrep \
  fd \
  unzip \
  neovim \
  dotnet-sdk-10.0 \
  luarocks \
  fzf \
  docker \
  docker-compose \
  curl \
  7zip \
  shotwell \
  thunderbird \
  nextcloud-client \
  yt-dlp \
  runc \
  steam 
```

**Flatpaks:**

```bash
flatpak install flathub \
  com.discordapp.Discord \
  com.github.tchx84.Flatseal \
  org.remmina.Remmina \
  md.obsidian.Obsidian \
  moe.launcher.the-honkers-railway-launcher \
  io.dbeaver.DBeaverCommunity \
  com.usebruno.Bruno \
  org.signal.Signal \
  com.usebottles.bottles
```

**Node Version Manager:**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
```

**Deno JavaScript Engine:**

```bash
curl -fsSL https://deno.land/install.sh | sh
```

**JetBrains Toolbox: (Note: the provided version may be outdated)**

```bash
mkdir ~/Applications
cd ~/Applications
curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-3.6.2.85969.tar.gz" -o "jetbrains-toolbox.tar.gz"
tar -xzf ./jetbrains-toolbox.tar.gz
rm ./jetbrains-toolbox.tar.gz
```

## Fonts

Download and extract `JetBrains Mono` and `Fira Code`:

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

## Configurations

**Oh My Zsh:**

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**Installing Plugins:**

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
```

**Kickstart nvim config:**

```bash
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

**SSH Keys:**

```bash
chmod 600 id_ed25519 server_default
chmod 644 id_ed25519.pub server_default.pub
```

Once the keys are set up you can clone all the projects:

```bash
cd ~/Documents
mkdir GitHub
cd GitHub
git clone git@github.com:JegenThierry/docker-containers.git
git clone git@github.com:JegenThierry/proton-auth-converter.git
git clone git@github.com:JegenThierry/playgrounds.git
git clone git@github.com:JegenThierry/server-config.git
git clone git@github.com:JegenThierry/centsible.git
git clone git@github.com:JegenThierry/dotfiles.git
git clone git@github.com:JegenThierry/yt-dlp-web.git
git clone git@github.com:JegenThierry/dew-flowerly.git
```

## Docker

```bash
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

## Optimizations

```bash
sudo systemctl disable NetworkManager-wait-online.service
```
