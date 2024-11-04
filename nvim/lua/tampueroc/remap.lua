vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton game_of_life<CR>");
vim.keymap.set("n", "<C-u>", "<C-u>zz");
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz");
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz");
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz");
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz");
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]]);
vim.keymap.set({"t"}, "<leader><esc>", "<C-\\><C-n>");
vim.keymap.set('t', '<leader><ESC>', '<C-\\><C-n>', { noremap = true });
vim.keymap.set("x", "<leader>p", [["_dP]]);
