return {
        "ThePrimeagen/harpoon",
        lazy = false,
        config = function()
            local opts = { noremap = true, silent = true }
            for i = 1, 9 do
                vim.keymap.set("n", "<leader>h" .. i, function()
                    require("harpoon.ui").nav_file(i)
                end, { desc = "Harpoon " .. i .. " file" })
            end
            vim.keymap.set("n", "<leader>hm", function()
                require("harpoon.mark").add_file()
                vim.notify "󱡅  marked file"
            end, opts)
            vim.keymap.set("n", "<leader>ha", function()
                require("harpoon.ui").toggle_quick_menu()
            end, opts)
        end,
    }
