export XDG_CONFIG_HOME="$HOME/.config"

export PATH="$HOME/.nvim/bin:$PATH"  # Neovim
export PATH="$HOME/.local/bin:$PATH" # Local scripts

# Use neovim as the default editor.
export EDITOR=nvim
export VISUAL=nvim

# Man pages.
export MANPAGER='nvim +Man!'

# Ripgrep.
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/.ripgreprc"

# fzf setup.
export FZF_DEFAULT_OPTS="--color=fg:#f8f8f2,bg:#0e1419,hl:#e11299,fg+:#f8f8f2,bg+:#44475a,hl+:#e11299,info:#f1fa8c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#a4ffff,header:#6272a4 \
--cycle --pointer=▎ \
--marker=▎ \
--bind=alt-s:toggle"

# If not running interactively, stop here.
[[ $- != *i* ]] && return

if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
    # Let fish whether it's a login shell.
    if ! shopt -q login_shell; then
        exec fish --login
    else
        exec fish
    fi
fi

# Barerepo
alias config='/usr/bin/git --git-dir=/Users/tomapuero/.cfg/ --work-tree=/Users/tomapuero'
