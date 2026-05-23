if not status is-interactive
    return
end

if set -q SSH_CONNECTION
    set -gx EDITOR vim
else
    set -gx EDITOR nvim
end

fish_add_path -g $HOME/.local/bin

set -gx FZF_DEFAULT_OPTS "
  --height=60%
  --layout=reverse
  --border=rounded
  --margin=5%
  --padding=1
  --info=inline
  --prompt='  🔍 '
  --pointer='  '
  --marker='✓ '
  --header='Search Files and Commands'
  --color='bg:-1,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4'
  --color='hl:#f38ba8,hl+:#f38ba8,header:#585b70'
  --color='info:#cba6f7,prompt:#bac2de,pointer:#f5e0dc'
  --color='marker:#a6e3a1,spinner:#f5e0dc,border:#585b70'
"

alias ytdl='yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata -o "%(title)s.%(ext)s"'
alias proton-sync='rclone sync "Proton Drive:" /home/thierry/ProtonDrive --progress'
alias ls='eza --icons'
alias ll='eza -lh --icons --git'
alias la='eza -a --icons'
alias lt='eza --tree --icons'

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q fnm
    fnm env --use-on-cd --shell fish | source
end
