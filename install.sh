#!/usr/bin/env bash
#
# Fedora setup script based on README.md.
#
# Usage:
#   ./install.sh                 # run everything except optional steps
#   ./install.sh --help          # show all flags
#
# Cloning of project repos and SSH key setup are intentionally not handled here.
#
# Optional sections are opt-in; interactive/risky ones are opt-in too:
#   --with-firmware     update device firmware via fwupd
#   --with-xbox         install xone kernel driver for Xbox controllers
#   --with-flatpaks     install flatpak applications
#   --skip-cleanup      skip removal of default KDE applications
#   --yes               do not ask "press enter" questions (reboot prompt etc.)
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Flags
# ---------------------------------------------------------------------------
WITH_FIRMWARE=0
WITH_XBOX=0
WITH_FLATPAKS=0
SKIP_CLEANUP=0
ASSUME_YES=0

usage() {
  sed -n '3,18p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --with-firmware) WITH_FIRMWARE=1 ;;
    --with-xbox)     WITH_XBOX=1 ;;
    --with-flatpaks) WITH_FLATPAKS=1 ;;
    --skip-cleanup)  SKIP_CLEANUP=1 ;;
    --yes|-y)        ASSUME_YES=1 ;;
    --help|-h)       usage ;;
    *) echo "Unknown option: $arg" >&2; usage ;;
  esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${LOG_FILE:-$HOME/fedora-setup-$(date +%Y%m%d-%H%M%S).log}"
STAMP="$(date +%Y%m%d-%H%M%S)"

RED=$'\033[31m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'; BLUE=$'\033[34m'; BOLD=$'\033[1m'; RESET=$'\033[0m'

log()  { printf '%s\n' "$*" | tee -a "$LOG_FILE" >&2; }
info() { log "${BLUE}${BOLD}==>${RESET} $*"; }
ok()   { log "${GREEN}  ok${RESET} $*"; }
warn() { log "${YELLOW}warn${RESET} $*"; }
die()  { log "${RED}error${RESET} $*"; exit 1; }

run() {
  log "    \$ $*"
  "$@" >>"$LOG_FILE" 2>&1 || die "command failed: $*"
}

section() {
  log ""
  log "${BOLD}### $*${RESET}"
}

pause() {
  if [[ $ASSUME_YES -eq 1 ]]; then
    return 0
  fi
  read -r -p "$1 [press Enter to continue]" _ || true
}

maybe_reboot() {
  if [[ $ASSUME_YES -eq 1 ]]; then
    warn "reboot recommended, skipping prompt (--yes)"
    return 0
  fi
  read -r -p "Reboot now? [y/N] " ans || true
  if [[ "${ans,,}" == y* ]]; then
    sudo reboot
  fi
}

# Back up an existing file or directory and replace it with a copy from the repo.
# usage: deploy <repo-relative-source> <destination>
deploy() {
  local src="$SCRIPT_DIR/$1"
  local dest="$2"

  [[ -e "$src" ]] || die "missing in repo: $1"

  mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" || -L "$dest" ]]; then
    local bak="${dest}.bak.${STAMP}"
    mv "$dest" "$bak"
    warn "backed up ${dest/#$HOME/\~} -> ${bak/#$HOME/\~}"
  fi

  cp -R "$src" "$dest"
  ok "${dest/#$HOME/\~}"
}

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
preflight() {
  section "Preflight"

  [[ $EUID -ne 0 ]] || die "run as your normal user, not root (the script calls sudo itself)"
  [[ "$(uname -s)" == Linux ]] || die "this script is for Linux"
  if ! grep -qi '^ID=fedora' /etc/os-release; then
    die "this script targets Fedora (detected: $(grep -oP '^ID=\K.*' /etc/os-release || echo unknown))"
  fi
  command -v sudo >/dev/null || die "sudo not found"
  command -v dnf >/dev/null || die "dnf not found"

  sudo -v
  # keep sudo alive for the whole run
  ( while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done ) &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT

  info "logging to $LOG_FILE"
  ok "Fedora $(rpm -E %fedora) on $(uname -m)"
}

# ---------------------------------------------------------------------------
# Steps
# ---------------------------------------------------------------------------
cleanup_kde() {
  section "Cleanup default KDE applications"

  local pkgs=(kmail korganizer kaddressbook akregator konversation neochat dragon
              kmines kpat mediawriter krdc krfb kdeconnectd plasma-discover
              kmahjongg kleopatra kmouth kdebugsettings plasma-welcome plasma-welcome-fedora)

  local installed=()
  for p in "${pkgs[@]}"; do
    rpm -q "$p" >/dev/null 2>&1 && installed+=("$p")
  done

  if [[ ${#installed[@]} -eq 0 ]]; then
    ok "nothing to remove"
    return 0
  fi

  info "removing: ${installed[*]}"
  run sudo dnf remove -y "${installed[@]}"
  run sudo dnf autoremove -y
}

setup_rpmfusion() {
  section "RPM Fusion repositories"

  local rel
  rel="$(rpm -E %fedora)"
  run sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${rel}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${rel}.noarch.rpm"

  run sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
  run sudo dnf update @core -y

  # glob is expanded by dnf, not the shell
  run sudo dnf install -y 'rpmfusion-*-appstream-data'
}

setup_multimedia() {
  section "Multimedia codecs"

  if lspci 2>/dev/null | grep -qiE 'VGA.*(AMD|ATI|Radeon)|Display.*(AMD|ATI|Radeon)'; then
    info "AMD GPU detected, installing freeworld drivers"
    run sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
    run sudo dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y

    run sudo dnf install mesa-va-drivers-freeworld -y
    run sudo dnf swap mesa-vulkan-drivers mesa-vulkan-drivers-freeworld -y
    # 32-bit builds are only available on multilib-enabled systems
    if [[ $(rpm -q --qf '%{ARCH}\n' mesa-vulkan-drivers 2>/dev/null | grep -c '^i686$') -gt 0 ]]; then
      run sudo dnf install mesa-va-drivers-freeworld.i686 -y
      run sudo dnf swap mesa-vulkan-drivers.i686 mesa-vulkan-drivers-freeworld.i686 -y
    else
      warn "i686 multilib not available, skipping 32-bit mesa"
    fi
  else
    info "no AMD GPU detected, using rpmfusion ffmpeg build"
    run sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
    run sudo dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
  fi

  run sudo dnf install rpmfusion-free-release-tainted -y
  run sudo dnf install libdvdcss -y
  run sudo dnf install rpmfusion-nonfree-release-tainted -y
  run sudo dnf --repo=rpmfusion-nonfree-tainted install '*-firmware' -y
}

update_system() {
  section "System updates"

  run sudo dnf4 group update core -y
  # dnf4 is optional; @core group is already installed above, so a missing
  # dnf4 binary is not fatal
  if command -v dnf4 >/dev/null 2>&1; then
    run sudo dnf4 group install core -y
  else
    warn "dnf4 not installed, skipping dnf4 group install"
  fi
  run sudo dnf update -y
  pause "Update done. A reboot is recommended before continuing."
}

update_firmware() {
  section "Firmware updates (fwupd)"

  run sudo fwupdmgr refresh --force
  log "Devices:"
  fwupdmgr get-devices 2>&1 | tee -a "$LOG_FILE" >&2 || warn "fwupdmgr get-devices failed"
  if fwupdmgr get-updates >>"$LOG_FILE" 2>&1; then
    run sudo fwupdmgr update -y
  else
    ok "no firmware updates available"
  fi
}

install_packages() {
  section "Software packages"

  local packages=(
    zsh flatpak gcc make golang git ripgrep fd unzip neovim luarocks fzf
    docker docker-compose curl 7zip shotwell thunderbird yt-dlp runc
    kitty mpv nextcloud-client steam
  )

  run sudo dnf install -y "${packages[@]}"
}

install_flatpaks() {
  section "Flatpak applications"

  run sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  run flatpak install -y flathub \
    com.discordapp.Discord \
    com.github.tchx84.Flatseal \
    org.remmina.Remmina \
    md.obsidian.Obsidian \
    moe.launcher.the-honkers-railway-launcher \
    io.dbeaver.DBeaverCommunity \
    com.usebruno.Bruno \
    org.signal.Signal \
    com.usebottles.bottles
}

install_helium() {
  section "Helium browser (COPR)"

  run sudo dnf copr enable imput/helium -y
  run sudo dnf install helium-bin -y
}

install_vscode() {
  section "Visual Studio Code"

  run sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  printf '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n' \
    | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
  # check-update exits 100 when updates exist, which is not an error
  sudo dnf check-update >>"$LOG_FILE" 2>&1 || true
  run sudo dnf install code -y
}

install_zed() {
  section "Zed editor"

  run bash -c 'curl -f https://zed.dev/install.sh | sh'
}

install_opencode() {
  section "opencode"

  run bash -c 'curl -fsSL https://opencode.ai/v2/install | bash'
}

install_nvm() {
  section "Node Version Manager"

  run bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash'
}

install_jetbrains_toolbox() {
  section "JetBrains Toolbox"

  local version="3.9.1.89198"
  local url="https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz"
  local apps="$HOME/Applications"

  mkdir -p "$apps"
  run curl -fL "$url" -o "$apps/jetbrains-toolbox.tar.gz"

  if ! tar -tzf "$apps/jetbrains-toolbox.tar.gz" >/dev/null 2>&1; then
    rm -f "$apps/jetbrains-toolbox.tar.gz"
    warn "download for version ${version} looks invalid; check https://www.jetbrains.com/toolbox-app/ for a newer URL"
    return 0
  fi

  run tar -xzf "$apps/jetbrains-toolbox.tar.gz" -C "$apps"
  rm -f "$apps/jetbrains-toolbox.tar.gz"
  ok "$apps"
}

install_xbox() {
  section "Xbox controller driver (xone)"

  run sudo dnf install -y kernel-devel kernel-headers cabextract dkms

  local dir="$HOME/Documents/xone"
  if [[ -d "$dir/.git" ]]; then
    run git -C "$dir" pull --ff-only
  else
    mkdir -p "$(dirname "$dir")"
    run git clone https://github.com/medusalix/xone.git "$dir"
  fi

  run sudo bash -c "cd '$dir' && ./install.sh"
  run sudo xone-get-firmware.sh
  warn "reboot or reload modules for the driver to take effect"
}

install_fonts() {
  section "Fonts (JetBrains Mono Nerd Font, Fira Code Nerd Font)"

  local fonts="$HOME/.fonts"
  mkdir -p "$fonts"

  local urls=(
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"
  )

  local zip
  for u in "${urls[@]}"; do
    zip="$fonts/$(basename "$u")"
    run curl -fL "$u" -o "$zip"
    run unzip -o "$zip" -d "$fonts"
  done

  # matches the README cleanup; zip archives contain these at their root
  rm -f "$fonts"/*.zip "$fonts"/README.md "$fonts"/OFL.txt "$fonts"/LICENSE

  run fc-cache -f
}

install_ohmyzsh() {
  section "Oh My Zsh"

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    run bash -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
  else
    ok "already installed"
  fi

  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  mkdir -p "$custom/plugins"

  clone_plugin() {
    local url="$1" name="$2"
    if [[ -d "$custom/plugins/$name/.git" ]]; then
      run git -C "$custom/plugins/$name" pull --ff-only
    else
      run git clone "$url" "$custom/plugins/$name"
    fi
  }

  clone_plugin https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
  clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting
  clone_plugin https://github.com/MichaelAquilina/zsh-you-should-use.git you-should-use

  local zsh_bin
  zsh_bin="$(command -v zsh || echo /usr/bin/zsh)"
  if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_bin" ]]; then
    info "changing login shell to $zsh_bin"
    run sudo chsh -s "$zsh_bin" "$USER"
  fi
}

install_nvim_kickstart() {
  section "Neovim (kickstart.nvim)"

  local dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  if [[ -d "$dir" && -n "$(ls -A "$dir" 2>/dev/null)" ]]; then
    local bak="${dir}.bak.${STAMP}"
    mv "$dir" "$bak"
    warn "backed up existing nvim config -> ${bak/#$HOME/\~}"
  fi

  if [[ -d "$dir/.git" ]]; then
    run git -C "$dir" pull --ff-only
  else
    run git clone https://github.com/nvim-lua/kickstart.nvim.git "$dir"
  fi
}

deploy_dotfiles() {
  section "Dotfiles (copy into \$HOME)"

  deploy .zshrc                  "$HOME/.zshrc"
  deploy .ssh/config             "$HOME/.ssh/config"
  deploy .config/kitty           "$HOME/.config/kitty"
  deploy .config/zed             "$HOME/.config/zed"

  # opencode config: copy the directory, but leave skills/ alone if present
  deploy .config/opencode/cli.json "$HOME/.config/opencode/cli.json"
  if [[ -d "$HOME/.config/opencode/skills" ]]; then
    warn "~/.config/opencode/skills exists, not copied"
  else
    deploy .config/opencode/skills "$HOME/.config/opencode/skills"
  fi

  chmod 700 "$HOME/.ssh"
  chmod 600 "$HOME/.ssh/config"
}

setup_docker() {
  section "Docker"

  run sudo systemctl enable --now docker
  run sudo usermod -aG docker "$USER"
  warn "log out and back in for docker group membership to apply"
}

optimize() {
  section "Optimizations"

  run sudo systemctl disable NetworkManager-wait-online.service
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  preflight

  [[ $SKIP_CLEANUP -eq 0 ]] && cleanup_kde

  setup_rpmfusion
  setup_multimedia
  update_system

  [[ $WITH_FIRMWARE -eq 1 ]] && update_firmware

  install_packages
  [[ $WITH_FLATPAKS -eq 1 ]] && install_flatpaks

  install_helium
  install_vscode
  install_zed
  install_opencode
  install_nvm
  install_jetbrains_toolbox
  [[ $WITH_XBOX -eq 1 ]] && install_xbox

  install_fonts

  install_ohmyzsh
  install_nvim_kickstart
  deploy_dotfiles

  setup_docker
  optimize

  section "Done"
  ok "see $LOG_FILE for the full log"
  maybe_reboot
}

main "$@"
