---@brief
---
--- https://github.com/remoteoss/dexter
---
--- `dexter` is a fast, full-featured Elixir LSP optimized for large codebases.
---
--- `dexter` can be installed via Homebrew, mise, or asdf:
---
--- Via Homebrew:
--- ```sh
--- brew install remoteoss/tap/dexter
--- ```
---
--- Via mise:
--- ```sh
--- mise plugin add dexter https://github.com/remoteoss/dexter.git
--- mise install dexter
--- ```
---
--- Via asdf:
--- ```sh
--- asdf plugin add dexter https://github.com/remoteoss/dexter.git
--- asdf install dexter latest
--- ```
---
--- `dexter` works without compilation by parsing source files directly, providing:
--- - Fast indexing (cold index in ~11s on 57k-file codebases)
--- - Go-to-definition with alias and delegate resolution
--- - Find references across the codebase
--- - Hover documentation and autocompletion
--- - Rename functionality with automatic file renaming
--- - Format on save via persistent Elixir process
---
--- NOTE: stdlibPath must point at an Elixir *source* tree, since dexter parses
--- `.ex`/`.exs` files directly. Homebrew's Elixir formula ships only compiled
--- `.beam` files, so auto-detection fails and stdlib modules (Enum, String, …)
--- won't resolve. We point at a checkout of elixir-lang/elixir matching the
--- installed version:
---
---   git clone --depth 1 --branch v$(elixir -e 'IO.write System.version()') \
---     https://github.com/elixir-lang/elixir.git ~/.local/share/elixir-src/<version>
---   ln -sfn ~/.local/share/elixir-src/<version> ~/.local/share/elixir-src/current
---
--- Configuration example:
--- ```lua
--- vim.lsp.config('dexter', {
---   init_options = {
---     followDelegates = true,  -- jump through defdelegate to the target function
---     -- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
---     -- debug = false,        -- verbose logging to stderr (view with :LspLog)
---   },
--- })
--- vim.lsp.enable('dexter')
--- ```
---

-- Homebrew Elixir ships no stdlib sources, so point dexter at a source checkout
-- that matches the installed Elixir version (see note above).
local stdlib_path = vim.fs.joinpath(vim.env.HOME, '.local', 'share', 'elixir-src', 'current', 'lib')

---@type vim.lsp.Config
return {
  cmd = { 'dexter', 'lsp' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
  root_markers = { '.dexter/dexter.db', '.dexter.db', 'mix.exs', '.git' },
  init_options = {
    followDelegates = true,
    stdlibPath = vim.fn.isdirectory(stdlib_path) == 1 and stdlib_path or nil,
  },
}
