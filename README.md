# Dotfiles for Arch (EndeavourOS)

This repository contains my personal dotfiles and a setup script for a fresh install of EndeavourOS Linux with the KDE desktop.

## Quick Start

To set up a new machine, clone this repository and run the setup script:

```bash
git clone https://github.com/thierryjegen/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

### What the script does:
1.  **System Update:** Runs `yay -Syu`.
2.  **Package Installation:** Installs core packages (fish, fnm, neovim, etc.) via pacman/AUR.
3.  **Modern CLI Tools:** Installs `starship`, `zoxide`, `eza`, `bat`.
4.  **Flatpaks:** Installs a predefined list of Flatpak applications.
5.  **Extra Tools:** Installs Zed and JetBrains Toolbox.
6.  **Fonts:** Installs JetBrainsMono and FiraCode Nerd Fonts.
7.  **Appearance:** Installs Colloid icon and cursor themes.
8.  **Editor:** Clones the Kickstart Neovim configuration.
9.  **Automation:** Symlinks dotfiles using **GNU Stow**.
10. **Shell:** Installs [Fisher](https://github.com/jorgebucaran/fisher), syncs plugins from `fish/.config/fish/fish_plugins`, and sets fish as the default login shell.
11. **Docker:** Enables and configures Docker for the current user.
12. **Optimizations:** Disables `NetworkManager-wait-online.service`.

## Repository Structure

Managed with [GNU Stow](https://www.gnu.org/software/stow/):

- `fish/`: Fish shell configuration (`config.fish`, `fish_plugins`)
- `zed/`: Zed editor settings
- `git/`: Global git configuration and ignore files
- `ssh/`: SSH client configuration

## Post-Installation

### SSH Keys

Ensure your SSH keys are in `~/.ssh` and have the correct permissions:

```bash
chmod 600 ~/.ssh/key1 ~/.ssh/key2
chmod 644 ~/.ssh/key1.pub ~/.ssh/key2.pub
```

### Clone Projects

Once SSH is configured, you can clone your development projects:

```bash
mkdir -p ~/Documents/programming
cd ~/Documents/programming
git clone ssh://git@codeberg.org/thierryjegen/docker-containers.git
git clone ssh://git@codeberg.org/thierryjegen/proton-auth-converter.git
git clone ssh://git@codeberg.org/thierryjegen/playgrounds.git
git clone ssh://git@codeberg.org/thierryjegen/tiny-emitter-cve-fixes.git
git clone ssh://git@codeberg.org/thierryjegen/server-config.git
git clone ssh://git@codeberg.org/thierryjegen/budget-planner.git
```

## Other distros

The `old/` directory holds setup scripts for other systems I use on and off:

- `old/fedora/` — Fedora (GNOME). Kept in sync with this Arch setup where it makes sense; differences are intentional (RPM Fusion, multimedia codec swaps, `gnome-tweaks`, `com.mattjakeman.ExtensionManager`, gaming-prompt-gated `steam`/`bottles`/i686 mesa swaps).
- `old/pop-os/`, `old/windows/` — older, not actively maintained.
