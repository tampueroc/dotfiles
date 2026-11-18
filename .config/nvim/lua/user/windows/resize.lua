-- ~/.config/nvim/lua/user/windows/resize.lua

local M = {}

function M.equalize()
  vim.cmd.wincmd("=")
end

function M.maximize_width()
  vim.cmd.wincmd("|")
end

function M.maximize_height()
  vim.cmd.wincmd("_")
end

function M.set_width()
  local count = vim.v.count
  if count > 0 then
    vim.cmd("vertical resize " .. count)
  else
    vim.cmd.wincmd("|")
  end
end

function M.set_height()
  local count = vim.v.count
  if count > 0 then
    vim.cmd("resize " .. count)
  else
    vim.cmd.wincmd("_")
  end
end

return M
