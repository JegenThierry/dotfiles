# Dotfiles Fedora

The following dotfiles are for a fresh install of Fedora Linux with the default Gnome desktop. Do note this is my personal way of configuring fedora and may differ from your personal preferences.

## Cleanup

Uninstall the following programs with the following command:

```bash
sudo dnf remove -y libreoffice-* gnome-tour mediawriter yelp
```

## Installing Programs

Install the following programs:

```bash
sudo dnf install -y git curl vim zsh unzip gnome-tweaks gcc make ripgrep fd unzip neovim fzf shotwell dotnet-sdk-8.0 luarocks docker docker-compose curl cabextract xorg-x11-font-utils fontconfig
```

Install the following programs (with gaming):

```bash
sudo dnf install -y git curl vim zsh unzip gnome-tweaks gcc make ripgrep fd unzip neovim fzf shotwell dotnet-sdk-8.0 luarocks docker docker-compose steam curl cabextract xorg-x11-font-utils fontconfig
```

Install programs via flatpak:

```bash
flatpak install com.discordapp.Discord org.telegram.desktop com.github.tchx84.Flatseal org.remmina.Remmina md.obsidian.Obsidian com.mattjakeman.ExtensionManager
```

Install programs via flatpak (with gaming):

```bash
flatpak install com.discordapp.Discord org.telegram.desktop com.github.tchx84.Flatseal org.remmina.Remmina md.obsidian.Obsidian com.mattjakeman.ExtensionManager com.usebottles.bottles
```

## Adding Fonts

I use JetBrainsMono Nerd Font as my font for coding.

```bash
mkdir ~/.fonts
cd ~/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip ./JetBrainsMono.zip
rm ./*.zip
cd
```

Add some Windows fonts (Dependencies in the initial install command):

```bash
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
```

Download additional fonts from (https://lexics.github.io/installing-ms-fonts)

### Installing Microsoft ClearType Fonts

```bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/72e10b8af5ca359772ee64b6dba33c91/raw/2d7ab3caa27faa61beca9fbf7d3aca6ce9a25916/clearType.sh | bash
```

### Installing Tahoma and Segoe-UI Fonts

```bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/b74e06f739610c4a867cf94b27637a56/raw/96926e732a38d3da860624114990121d71c08ea1/tahoma.sh | bash
```

```bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/64ba4acc55047a53b680c1b3072dd985/raw/6bdf69384da4783cc6dafcb51d281cb3ddcb7ca0/segoeUI.sh | bash
```

### Installing Other Essential Fonts

```bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/d959d3196fb3937b36969013d96740e0/raw/429d8882b7c34e5dbd7b9cbc9d0079de5bd9e3aa/otherFonts.sh | bash
```

## RPM-Fusion

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

```bash
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
```

### Multimedia-Codecs (https://rpmfusion.org/)

```bash
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
```

```bash
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
```

#### AMD (Hardware Codecs)

```bash
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
```

If using i686 compat libraries (for steam or alikes):

```bash
sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
```

### Other Setups

Oh my zsh (https://ohmyz.sh/)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Node version manager (https://github.com/nvm-sh/nvm):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

Add this line to the .zshrc:

```bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```

Personal Note: Download `.rpm` files from protondrive, to install other files that are only available via rpm download.
