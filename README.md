# Dotfiles Fedora

The following dotfiles are for a fresh install of Fedora Linux. Do note this is my personal way of configuring Fedora and may differ from your personal preferences.

I am currently using KDE. 

## Cleanup

Uninstall the following programs with the following command:

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

**Delete dangling packages:**

```bash
sudo dnf autoremove -y
```

## Before continuing, some initial setup is required:

**RPM Fusion:**

Follow the instructions on: [rpmfusion.org](https://rpmfusion.org/Configuration)

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
```

```bash
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
```

```bash
sudo dnf update @core
sudo dnf install rpmfusion-\*-appstream-data
```

**Multimedia codecs (AMD only):**

Follow the instructions on: [rpmfusion.org](https://rpmfusion.org/Howto/Multimedia)

```bash
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
```

```bash
sudo dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
```

```bash
sudo dnf install mesa-va-drivers-freeworld
sudo dnf swap mesa-vulkan-drivers{,-freeworld}
sudo dnf install mesa-va-drivers-freeworld.i686
sudo dnf swap mesa-vulkan-drivers{,-freeworld}.i686
```

```bash
sudo dnf install rpmfusion-free-release-tainted
sudo dnf install libdvdcss
```

```bash
sudo dnf install rpmfusion-nonfree-release-tainted
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"
```

**Updates:**

```bash
sudo dnf group update core -y
sudo dnf4 group install core -y
sudo dnf update -y
```

> It is recommended to reboot now.

**Updating Firmware (optional):**

```bash
fwupdmgr refresh --force
fwupdmgr get-devices # Lists devices with available updates.
fwupdmgr get-updates # Fetches list of available updates.
fwupdmgr update
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
  luarocks \
  fzf \
  docker \
  docker-compose \
  curl \
  7zip \
  shotwell \
  thunderbird \
  rclone \
  yt-dlp \
  runc \
  kitty \
  mpv \
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

**Helium Browser:**

Note: I used the copr variant if you do not like that you may use a different installation method or simply use a different browser.

```bash
dnf copr enable imput/helium
dnf install helium-bin
```

**VS Code:**
	
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

sudo dnf check-update &&
sudo dnf install code -y
```

**Node Version Manager:**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
```

**JetBrains Toolbox: (Note: the provided version may be outdated)**

```bash
mkdir ~/Applications
cd ~/Applications
curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-3.8.1.88030.tar.gz" -o "jetbrains-toolbox.tar.gz"
tar -xzf ./jetbrains-toolbox.tar.gz
rm ./jetbrains-toolbox.tar.gz
```

**XBOX Controller:**

```bash
sudo dnf install kernel-devel kernel-headers cabextract dkms -y
```

```bash
cd ~/Documents
git clone https://github.com/medusalix/xone.git
cd xone
sudo ./install.sh
```

```bash
sudo xone-get-firmware.sh
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

**Colloid Icon-Theme:**

```bash
cd ~/Downloads
git clone https://github.com/vinceliuice/Colloid-icon-theme.git
cd Colloid-icon-theme
./install.sh
cd cursors
./install.sh
cd ~/Downloads
rm -rf Colloid-icon-theme
```

**SSH Keys:**

```bash
chmod 600 id_ed25519 server_default
chmod 644 id_ed25519.pub server_default.pub
```

Once the keys are set up you can clone all the projects:

```bash
cd ~/Documents
mkdir programming
cd programming
git clone ssh://git@codeberg.org/thierryjegen/docker-containers.git
git clone ssh://git@codeberg.org/thierryjegen/proton-authenticator-to-bitwarden.git
git clone ssh://git@codeberg.org/thierryjegen/playgrounds.git
git clone ssh://git@codeberg.org/thierryjegen/server-config.git
git clone ssh://git@codeberg.org/thierryjegen/centsible.git
git clone ssh://git@codeberg.org/thierryjegen/dotfiles.git
git clone ssh://git@codeberg.org/thierryjegen/yt-dlp-web.git
git clone ssh://git@codeberg.org/thierryjegen/personal-homepage.git
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
