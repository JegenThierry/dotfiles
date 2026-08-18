# Dotfiles Fedora

The following dotfiles are for a fresh install of Fedora Linux. Do note this is my personal way of configuring Fedora and may differ from your personal preferences.

I am currently using GNOME.

## Cleanup

Uninstall the following programs with the following command:

```bash
sudo dnf remove -y \
  gnome-tour \
  gnome-connections \
  simple-scan \
  yelp \
  gnome-boxes
```

**Delete dangling packages:**

```bash
sudo dnf autoremove -y
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

Enable Google-Chrome from the Fedora Repos:

```bash
sudo dnf config-manager setopt google-chrome.enabled=1
```


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
  calibre \
  google-chrome-stable \
  gnome-tweaks \
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
  org.jeffvli.feishin \
  com.mattjakeman.ExtensionManager \
  com.usebottles.bottles
```

**VS Code:**

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

sudo dnf check-update &&
sudo dnf install code -y
```

**Zed:**

```bash
curl -f https://zed.dev/install.sh | sh
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

## Waydroid Setup Fedora With TFT

**Waydroid and dependencies:**

```bash
sudo dnf install waydroid lzip -y
```

**Setup GAPPS**

```bash
sudo waydroid init -s GAPPS -c https://ota.waydro.id/system -v https://ota.waydro.id/vendor -f
```

**Setup container service:**

Note: I did not want to enable the service on system launch. So you can choose according to your preferences:

```bash
sudo systemctl enable --now waydroid-container.service
sudo systemctl start waydroid-container.service
```
**Firewall Fixes:**

```bash
sudo firewall-cmd --zone=trusted --add-interface=waydroid0 --permanent
sudo firewall-cmd --zone=FedoraWorkstation --add-masquerade --permanent
sudo firewall-cmd --reload

sudo sysctl net.ipv4.ip_forward=1

sudo systemctl stop waydroid-container
sudo nmcli connection delete waydroid0 2>/dev/null || true
sudo systemctl start waydroid-container
```

**Get android ID:**

```bash
sudo python3 -c "import sqlite3; print(sqlite3.connect('/var/lib/waydroid/data/data/com.google.android.gsf/databases/gservices.db').execute('SELECT value FROM main WHERE name=\"android_id\"').fetchone()[0])"
```

Enter the ID here: https://www.google.com/android/uncertified


**For TFT a translation Level is needed:**

```bash
git clone https://github.com/casualsnek/waydroid_script
cd waydroid_script
python3 -m venv venv
venv/bin/pip install -r requirements.txt
sudo venv/bin/python3 main.py
```

> Should you experience issues: Go to Apps > PlayStore > Clear Storage
