-- ~/.config/nvim/lua/user/windows/zoom.lua

local M = {}

function M.toggle()
  if vim.fn.winnr("$") == 1 then
    return
  end

  if vim.t.zoom_restore then
    vim.cmd(vim.t.zoom_restore)
    vim.t.zoom_restore = nil
    return
  end

  vim.t.zoom_restore = vim.fn.winrestcmd()

  vim.cmd.wincmd("|")
  vim.cmd.wincmd("_")
end

return M
