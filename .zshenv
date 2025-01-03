# XDG base directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export PATH="$HOME/nvim/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export SHELL_SESSIONS_DISABLE=1

export MANPAGER='nvim +Man!'

export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"

# Disable Apple's save/restore mechanism.
export SHELL_SESSIONS_DISABLE=1

export GHOSTTY_SHELL_INTEGRATION_NO_CURSOR=1

