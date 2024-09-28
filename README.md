# Dotfiles Archlinux

The following dotfiles are for a fresh install of Arch Linux with the Hyprland desktop. This dotfile configuration expects you to have installed `hyprland` with the use of `archinstall`.

## Dependencies

Install the following packages:
```bash
sudo pacman -S --noconfirm --needed git curl vim zsh unzip 
```

Setup yay AUR Manager:
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -Rf ./yay
```

Install software:
```bash
yay -S --noconfirm --needed gcc make ripgrep fd unzip neovim waybar btop brightnessctl wlogout ttf-ms-win11-auto vscodium-bin thunderbird thunar catppuccin-cursors-macchiato papirus-icon-theme gtk-engine-murrine gnome-themes-extra nwg-look hyprpaper polkit-gnome flatpak chromium vlc shotwell dotnet-sdk luarocks krita gimp inkscape hyprshot docker docker-compose
```

For a regular desktop install
```bash
yay -S --noconfirm --needed gcc make ripgrep fd unzip neovim ttf-ms-win11-auto vscodium-bin megasync-bin thunderbird flatpak chromium vlc shotwell dotnet-sdk luarocks krita gimp inkscape albert docker docker-compose
```

If on Laptop the following is recommended:
```bash
yay -S --noconfirm --needed tlp tlp-rdw
```

Remove dolphin:
```bash
yay -R dolphin
```

## Flatpaks

```bash
flatpak install com.discordapp.Discord org.telegram.desktop com.rawtherapee.RawTherapee com.usebottles.bottles com.github.tchx84.Flatseal org.remmina.Remmina
flatpak update
```

## Fonts

```bash 
mkdir ~/.fonts
cd ~/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Noto.zip
unzip ./JetBrainsMono.zip
unzip ./Noto.zip
rm ./*.zip
cd
```

## Theming

Qogir-Dark Theme
```bash
git clone https://github.com/vinceliuice/Qogir-theme.git
cd Qogir-theme
./install.sh
```

## Configs

Remove old config files, to avoid conflicts.
```bash
rm -R ~/.config/nvim ~/.config/hypr ~/.config/waybar ~/.config/kitty
```

Clone the git files
```bash
cd Downloads
git clone https://github.com/JegenThierry/updated-dotfiles.git
cd updated-dotfiles
```

Move the config files to the corresponding places.
```bash
mv ./btop ~/.config/
mv ./nvim ~/.config/
mv ./kitty ~/.config/
mv ./waybar ~/.config/
mv ./hypr ~/.config/
mv zshrc ~/.zshrc
```

## Additional Tools

Oh my zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> Change theme to lukerandall

Node version manager
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```

## Wallpaper
Copy Wallpaper to the designated place.
```
mkdir ~/Pictures
mv wallpapers ~/Pictures
```

## Final Steps
Open nwg-look and configure the rest of the looks to your liking there.
