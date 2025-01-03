setopt auto_cd

setopt SHARE_HISTORY
# Ignore duplicated commands history list.
setopt hist_ignore_dups

# Load nvm and set up bash completions.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Execute fish if it's not the parent process.
if ! ps -p $PPID | grep -q fish; then
  fish
fi
