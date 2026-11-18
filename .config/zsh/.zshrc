setopt auto_cd

# Manage dotfiles through the bare repository.
alias config='git --git-dir="$HOME/.cfg" --work-tree="$HOME"'

# When deleting with <C-w>, delete file names at a time.
WORDCHARS=${WORDCHARS/\/}

# Delete duplicates first when HISTFILE size exceeds HISTSIZE.
setopt hist_expire_dups_first

setopt SHARE_HISTORY
# Ignore duplicated commands history list.
setopt hist_ignore_dups

# Load nvm and set up bash completions.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# fnm
FNM_PATH="/Users/tomapuero/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/tomapuero/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
