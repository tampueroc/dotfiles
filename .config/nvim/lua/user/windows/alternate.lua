-- ~/.config/nvim/lua/user/windows/alternate.lua

local M = {}

function M.jump()
  if vim.fn.winnr("$") == 1 then
    return
  end

  local current = vim.api.nvim_get_current_win()

  vim.cmd.wincmd("p")

  if vim.api.nvim_get_current_win() == current then
    vim.cmd.wincmd("w")
  end
end

return M
