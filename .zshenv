export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.nvim/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Man pages
export MANPAGER='nvim +Man!'

# Set up neovim as the default editor.
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"

# zsh configuration.
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Disable Apple's save/restore mechanism.
export SHELL_SESSIONS_DISABLE=1

# Ripgrep.
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/.ripgreprc"

export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,bg:#0e1419,hl:#e11299,fg+:#f8f8f2,bg+:#44475a,hl+:#e11299,info:#f1fa8c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#a4ffff,header:#6272a4 --cycle --pointer=▎ --marker=▎"
