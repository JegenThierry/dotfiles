export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="lukerandall"

# SSH configuration
zstyle :omz:plugins:ssh-agent lifetime 4h
zstyle :omz:plugins:ssh-agent identities id_ed25519 server_default

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 5

# Date format
HIST_STAMPS="dd.mm.yyyy"

# Plugins
plugins=(
  git
  fzf
  ssh-agent
  zsh-autosuggestions
  you-should-use
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export PATH=$HOME/.local/bin:$PATH

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# fzf - One Dark Theme
export FZF_DEFAULT_OPTS=" \
  --border='rounded' \
  --preview-window='border-rounded' \
  --prompt='❯ ' \
  --marker='❯ ' \
  --pointer='➜ ' \
  --separator='─' \
  --scrollbar='│' \
  --color='fg:#abb2bf,fg+:#ffffff,bg:#282c34,bg+:#31353f' \
  --color='hl:#e06c75,hl+:#e5c07b,info:#61afef' \
  --color='marker:#98c379,prompt:#61afef,spinner:#c678dd,pointer:#c678dd' \
  --color='header:#e5c07b,border:#61afef,label:#61afef' \
  --color='separator:#3e4451,scrollbar:#61afef' \
"

# Aliases
alias ytdl='yt-dlp -f bestaudio -x --audio-format flac --embed-thumbnail --embed-metadata -o "%(title)s.%(ext)s"'
alias vim='nvim'
