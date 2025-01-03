if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test -n "$GHOSTTY_RESOURCES_DIR"
    source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
end

abbr -a nv nvim

set -U fish_greeting
fzf --fish | source
