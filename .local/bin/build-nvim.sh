#!/usr/bin/env bash
set -euo pipefail

if (( $# > 1 )); then
    printf 'Usage: %s [git-ref]\n' "${0##*/}" >&2
    exit 2
fi

repo="$HOME/Code/Forks/neovim"
install_dir="$HOME/.nvim"

if ! git -C "$repo" rev-parse --show-toplevel >/dev/null; then
    printf 'Neovim checkout not found at %s\n' "$repo" >&2
    exit 1
fi

if (( $# == 0 )); then
    git -C "$repo" fetch upstream refs/heads/master
    ref=FETCH_HEAD
else
    ref=$1
fi
commit=$(git -C "$repo" rev-parse --verify --end-of-options "${ref}^{commit}")

# Build outside the working checkout so local edits and branches are untouched.
workdir=$(mktemp -d "${TMPDIR:-/tmp}/build-nvim.XXXXXXXX")
worktree="$workdir/neovim"
worktree_added=0
cleanup() {
    if (( worktree_added )); then
        git -C "$repo" worktree remove --force "$worktree" || return
    fi
    rmdir "$workdir"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

git -C "$repo" worktree add --detach "$worktree" "$commit"
worktree_added=1
printf 'Building Neovim at %s for %s\n' "$commit" "$install_dir"
make -C "$worktree" CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$install_dir" install

"$install_dir/bin/nvim" --version
