# Nothing to do if not inside an interactive shell.
if not status is-interactive
    return 0
end

if test -n "$GHOSTTY_RESOURCES_DIR"
    source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
end

abbr -a nv nvim
abbr -a nvo --set-cursor "cd % && nvim"
abbr -a nvp nvim +Man!

set -U fish_greeting
fzf --fish | source
