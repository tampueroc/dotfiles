vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Show line numbers.
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")


-- Keeping the cursor centered.
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })


-- Indent while remaining in visual mode.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<leader>L', '<cmd>packupdate<cr>', { desc = 'Review plugin updates' })

-- Mark management.
vim.keymap.set('c', 'dm', 'delmarks', { desc = 'Delete marks' })

vim.keymap.set("n", "<leader>bb", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })

vim.keymap.set("n", "<leader>bd", function()
  require("user.buffers.delete").delete(false)
end, { desc = "Delete buffer, keep window" })

vim.keymap.set("n", "<leader>bD", function()
  require("user.buffers.delete").delete(true)
end, { desc = "Force delete buffer, keep window" })

vim.keymap.set("n", "<C-b>", function()
  if vim.v.count > 0 then
    vim.cmd.buffer(vim.v.count)
    return
  end

  local more = vim.o.more
  vim.o.more = false
  vim.cmd.ls()
  vim.o.more = more
  vim.api.nvim_feedkeys(":buffer ", "n", false)
end, { desc = "Jump to buffer" })

vim.keymap.set("n", "<leader><Tab>", function()
  require("user.windows.alternate").jump()
end, { desc = "Jump to alternate window" })

vim.keymap.set("n", "<C-a><Tab>", function()
  require("user.windows.alternate").jump()
end, { desc = "Jump to alternate window" })

vim.keymap.set("n", "<C-a>h", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-a>j", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-a>k", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-a>l", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-a><Left>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-a><Down>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-a><Up>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-a><Right>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<C-a>z", function()
  require("user.windows.zoom").toggle()
end, { desc = "Toggle window zoom" })

vim.keymap.set("n", "<leader>z", function()
  require("user.windows.zoom").toggle()
end, { desc = "Toggle window zoom" })

vim.keymap.set("n", "<leader>w=", function()
  require("user.windows.resize").equalize()
end, { desc = "Equalize windows" })

vim.keymap.set("n", "<leader>w|", function()
  require("user.windows.resize").set_width()
end, { desc = "Set/maximize window width" })

vim.keymap.set("n", "<leader>w_", function()
  require("user.windows.resize").set_height()
end, { desc = "Set/maximize window height" })

vim.keymap.set({ "n", "t" }, "<C-s>", function()
  require("user.terminal.shell").toggle()
end, { desc = "Toggle persistent shell" })

require("user.tabs").setup()
