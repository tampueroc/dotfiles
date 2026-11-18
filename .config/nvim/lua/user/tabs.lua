-- lua/user/tabs.lua

local M = {}

function M.setup()
    vim.opt.tabclose = "uselast"

    vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", {
        desc = "New tab",
    })

    vim.keymap.set("n", "<C-a>c", "<cmd>tabnew<cr>", {
        desc = "New tab",
    })

    vim.keymap.set("n", "<leader>tt", "<cmd>tab split<cr>", {
        desc = "Move current window to tab",
    })

    vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", {
        desc = "Close tab",
    })

    vim.keymap.set("n", "<leader>th", "gT", {
        desc = "Previous tab",
    })

    vim.keymap.set("n", "<leader>tl", "gt", {
        desc = "Next tab",
    })

    for i = 1, 9 do
        vim.keymap.set("n", ("<C-a>%d"):format(i), ("<cmd>%dtabnext<cr>"):format(i), {
            desc = ("Go to tab %d"):format(i),
        })
    end
end

return M
