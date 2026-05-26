# Setup Arch (EndeavourOS)

The following dotfiles are for a fresh install of EndeavourOS Linux with the KDE desktop. Do note this is my personal way of configuring EndeavourOS and may differ from your personal preferences.

## Update

Ensure you have all updates installed

```bash
yay
```

Reboot your PC if any updates have been installed.

## Installing Software

**AUR + Pacman:**

```bash
yay -S \
  zsh \
  ghostty \
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
  brave-bin \
  bat
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
sudo systemctl disable NetworkManager-wait-online.service
```
