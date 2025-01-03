setopt auto_cd

setopt SHARE_HISTORY

zstyle ':completion:*' menu select

# Execute fish if it's not the parent process.
if ! ps -p $PPID | grep -q fish; then
  fish
fi
