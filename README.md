# updated-dotfiles
My updated dotfiles for Archlinux and Hyprland Notification daemon still missing

# Dependencies
Note: this list may not be exhaustive and may need to be extended

Install the follwing dependencies:

```
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Noto.zip
mkdir ~/.fonts
unzip ./*.zip
mv *.ttf ~/.fonts
```

> yay
```
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

> Other dependencies:
```
yay -S waybar btop brighnessctl wlogout
```

# Installation
Move the files you want to your ```.config/``` folder.
