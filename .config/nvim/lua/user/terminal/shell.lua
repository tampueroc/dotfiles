-- ~/.config/nvim/lua/user/terminal/shell.lua

local M = {}

local shell_buf = nil
local previous_win = nil

local function shell_exists()
  return shell_buf and vim.api.nvim_buf_is_valid(shell_buf)
end

local function find_shell_window()
  if not shell_exists() then
    return nil
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == shell_buf then
      return win
    end
  end
end

local function open_shell_window()
  vim.cmd("botright 15split")

  if shell_exists() then
    vim.api.nvim_win_set_buf(0, shell_buf)
  else
    vim.cmd.terminal()
    shell_buf = vim.api.nvim_get_current_buf()
    vim.bo[shell_buf].buflisted = false
  end

  vim.cmd.startinsert()
end

function M.toggle()
  local current_win = vim.api.nvim_get_current_win()

  if shell_exists() and vim.api.nvim_get_current_buf() == shell_buf then
    if previous_win and vim.api.nvim_win_is_valid(previous_win) then
      vim.api.nvim_set_current_win(previous_win)
    else
      vim.cmd.wincmd("p")
    end
    return
  end

  previous_win = current_win

  local shell_win = find_shell_window()

  if shell_win then
    vim.api.nvim_set_current_win(shell_win)
    vim.cmd.startinsert()
  else
    open_shell_window()
  end
end

return M
