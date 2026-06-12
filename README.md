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

**Setup RPM Fusion:**

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

**Software Packages (Without Gaming):**

```bash
sudo dnf install -y \
  zsh \
  flatpak \
  gcc \
  make \
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
  gnome-tweaks \
  thunderbird \
  nextcloud-client
```

**Software Packages (With Gaming):**

```bash
sudo dnf install -y \
  zsh \
  flatpak \
  gcc \
  make \
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
  steam \
  curl \
  7zip \
  shotwell \
  gnome-tweaks \
  thunderbird \
  nextcloud-client
```

**Flatpaks (Without Gaming):**

```bash
flatpak install flathub \
  com.discordapp.Discord \
  com.github.tchx84.Flatseal \
  org.remmina.Remmina \
  md.obsidian.Obsidian \
  com.spotify.Client \
  io.dbeaver.DBeaverCommunity \
  com.usebruno.Bruno \
  org.signal.Signal \
  app.zen_browser.zen \
  com.mattjakeman.ExtensionManager
```

**Flatpaks (With Gaming):**

```bash
flatpak install flathub \
  com.discordapp.Discord \
  com.github.tchx84.Flatseal \
  org.remmina.Remmina \
  md.obsidian.Obsidian \
  com.usebottles.bottles \
  com.spotify.Client \
  moe.launcher.the-honkers-railway-launcher \
  io.dbeaver.DBeaverCommunity \
  com.usebruno.Bruno \
  org.signal.Signal \
  app.zen_browser.zen \
  com.mattjakeman.ExtensionManager
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

Once the keys are setup you can clone all the projects:

```bash
cd ~/Documents
mkdir programming
cd programming
git clone ssh://git@codeberg.org/thierryjegen/docker-containers.git
git clone ssh://git@codeberg.org/thierryjegen/proton-auth-converter.git
git clone ssh://git@codeberg.org/thierryjegen/playgrounds.git
git clone ssh://git@codeberg.org/thierryjegen/tiny-emitter-cve-fixes.git
git clone ssh://git@codeberg.org/thierryjegen/server-config.git
git clone ssh://git@codeberg.org/thierryjegen/centsible.git
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
