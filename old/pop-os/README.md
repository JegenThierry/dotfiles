# Dotfiles Pop-OS

The following dotfiles are used for my setup on a fresh installation of Pop-OS. Opinionated setup that may not appeal to the general public and focuses on personal preferences.

## Update

Update system packages and upgrade installed software.

```bash
sudo apt update && sudo apt upgrade -y
```

## Remove bloatware

Uninstall unnecessary applications and services to optimize system performance.

```bash
sudo apt remove -y libreoffice-* \
  simple-scan \
  yelp \
  popsicle
```

Clean up dangling packages.

```bash
sudo apt autoremove -y
```

## Installing Software

**APT:**

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y \
  zsh \
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
  dotnet-sdk-8.0 \
  luarocks \
  fzf \
  docker.io \
  docker-compose \
  curl \
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

## Docker

```bash
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```
