-- ~/.config/nvim/lua/user/buffers/delete.lua

local M = {}

local function is_visible_in_current_tab(buf)
  return vim.tbl_contains(vim.fn.tabpagebuflist(), buf)
end

local function is_valid_target(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].buflisted
    and buf ~= vim.api.nvim_get_current_buf()
    and not is_visible_in_current_tab(buf)
    and vim.bo[buf].buftype == ""
end

local function find_replacement_buffer()
  local alternate = vim.fn.bufnr("#")

  if is_valid_target(alternate) then
    return alternate
  end

  for buf = vim.fn.bufnr("$"), 1, -1 do
    if is_valid_target(buf) then
      return buf
    end
  end
end

function M.delete(force)
  local current = vim.api.nvim_get_current_buf()

  if vim.bo[current].modified and not force then
    vim.notify("Buffer has unsaved changes. Use force delete to discard.", vim.log.levels.WARN)
    return
  end

  local replacement = find_replacement_buffer()

  if replacement then
    vim.api.nvim_set_current_buf(replacement)
  else
    vim.cmd.enew()
  end

  if vim.api.nvim_buf_is_valid(current) then
    vim.cmd.bdelete({ args = { tostring(current) }, bang = true })
  end
end

return M
