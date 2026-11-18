local pack = require("pack")

pack.add({
    { src = "nvim-lua/plenary.nvim", name = "plenary", setup = false },
    { src = "b0o/SchemaStore.nvim", setup = false },
})

-- Load completion capabilities before the first buffer can start an LSP client.
require("plugins.blink")

for _, name in ipairs({
    "dap",
    "fzf-lua",
    "fugitive",
    "gitlinker",
    "gitsigns",
    "miniclue",
    "nvim-surround",
    "nvim-ts-autotag",
    "overseer",
    "showkeys",
    "treesitter",
}) do
    require("plugins." .. name)
end
