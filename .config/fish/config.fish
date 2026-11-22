source /usr/share/cachyos-fish-config/cachyos-config.fish

# opencode
fish_add_path /home/thierry/.opencode/bin

# Aliases
alias vim='nvim'
abbr -a ytdl 'yt-dlp -f bestaudio -x --audio-format flac --embed-thumbnail --embed-metadata -o "%(title)s.%(ext)s"'
abbr -a proton-sync 'rclone sync protondrive: /home/thierry/ProtonDrive --progress --exclude "/Backups/**"'