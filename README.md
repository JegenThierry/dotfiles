# Dotfiles

I have explored different Distros for myself one stable distro I always came back to was Fedora, but recently constant struggle with media playback got on my nerves. So I decided to switch again. After exploring `NIX OS` for a while I came to the conclusion that yes it is a really nice distro but does not match how I use my system, the pardim does not match how I use my Linux system. `Ubuntu` and its derivatives also did not catch my eyes, most of them ship software that is not up to date enough for my taste.

That is why I landed on `Cachy OS` the defaults fit my use case quite well and I only needed smaller tweaks for the System to feel more in line with what I want of my distro. 


## Software

This is a mix of gaming and development packages that I use on my machine.

**Packages:**

```bash
sudo pacman -S proton-mail-bin cachyos-gaming-meta vscodium mangohud steam flatpak gcc go git ripgrep fd unzip neovim luarocks fzf docker docker-compose curl 7zip shotwell thunderbird yt-dlp runc rclone mpv opencode zed
```

Normally I would use `kitty` as my terminal emulator but during the setup of cachy os it installed alacritty with fish shell. So I am currently exploring that.

**Flatpaks:**

Since I did not have the time yet to replace some flatpaks with package manager packages the list of flatpaks remains unchanged.

Note this may not be necessary installing flatpak on `Arch` also pulls flathub remote.

```bash
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

```bash
flatpak install flathub com.discordapp.Discord com.github.tchx84.Flatseal org.remmina.Remmina md.obsidian.Obsidian moe.launcher.the-honkers-railway-launcher io.dbeaver.DBeaverCommunity com.usebruno.Bruno org.signal.Signal com.usebottles.bottles
```

If you care about modding your games [Amethyst](https://github.com/ChrisDKN/Amethyst-Mod-Manager) may be the solution for you:

```bash
flatpak install --user https://chrisdkn.github.io/Amethyst-Mod-Manager/amethyst.flatpakref
```

**JetBrains Toolbox: (Note: the provided version may be outdated)**

```bash
mkdir ~/Applications
cd ~/Applications
curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-3.9.1.89198.tar.gz" -o "jetbrains-toolbox.tar.gz"
tar -xzf ./jetbrains-toolbox.tar.gz
rm ./jetbrains-toolbox.tar.gz
```

**Fish shell Plugins:**

Note that `fisher` is already installed on the cachy os preset.

```bash
fisher install jorgebucaran/nvm.fish
```

## Fonts

Download and extract `JetBrains Mono` and `Fira Code`:

```bash
mkdir ~/.fonts
cd ~/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
unzip ./JetBrainsMono.zip
rm README.md OFL.txt LICENSE
unzip ./FiraCode.zip
rm ./*.zip README.md OFL.txt LICENSE
```

You may safely ignore that one of those files hast not been found for deletion: `README.md` `OFL.txt` `LICENSE`

## Configurations

**Kickstart nvim config:**

```bash
git clone https://github.com/nvim-lua/kickstart.nvim.git ~/.config/nvim
```

**SSH Keys:**

```bash
chmod 600 id_ed25519 server_default rs2000
chmod 644 id_ed25519.pub server_default.pub rs2000.pub
```

Once the keys are set up you can clone all the projects:

```bash
cd ~/Documents
mkdir GitHub
cd GitHub
git clone git@github.com:JegenThierry/docker-containers.git
git clone git@github.com:JegenThierry/proton-authenticator-to-bitwarden.git
git clone git@github.com:JegenThierry/playgrounds.git
git clone git@github.com:JegenThierry/server-config.git
git clone git@github.com:JegenThierry/centsible.git
git clone git@github.com:JegenThierry/dotfiles.git
git clone git@github.com:JegenThierry/yt-dlp-web.git
git clone git@github.com:JegenThierry/personal-homepage.git
git clone git@github.com:JegenThierry/liquid.git
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
