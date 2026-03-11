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

## Installing programs

Basic programs:

```bash
sudo apt install -y \
  ubuntu-restricted-extras ubuntu-restricted-addons \
  git curl dotnet-sdk-8.0 golang zsh shotwell \
```

Installing neovim

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update -y
sudo apt install -y make gcc ripgrep unzip git xclip neovim luarocks fzf ripgrep
```

Installing docker

```bash
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Installing Zed as a main Text-Editor

```bash
curl -f https://zed.dev/install.sh | sh
```

Installing flatpaks

```bash
flatpak install \
  com.discordapp.Discord \
  com.github.tchx84.Flatseal \
  org.remmina.Remmina \
  md.obsidian.Obsidian \
  com.usebottles.bottles \
  com.spotify.Client \
  io.dbeaver.DBeaverCommunity \
  com.usebruno.Bruno \
  org.signal.Signal
```

## Setting up fonts

Create a directory for fonts and download both JetBrainsMono and FiraCode extract the `.zip` files and remove the `.zip` files after extraction.

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

## Setting up tools

Setting up `Oh my zsh` (https://ohmyz.sh/)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Setting up `Node version manager` (https://github.com/nvm-sh/nvm):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.zshrc && \
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
```

Setting up `Kickstart nvim` (https://github.com/nvim-lua/kickstart.nvim):

```bash
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

## Not included in this repo:

Instruction for installing the following software:
 - JetBrains Toolbox
 - Steam
