-- ~/.config/nvim/lua/user/workflows/presentation/slides.lua

local M = {}

local ns = vim.api.nvim_create_namespace("user_slides")
local state = {
  active = false,
  saved = {},
}

local function is_h1(line)
  return line:match("^#%s+")
end

local function slide_bounds()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local start_line = 1
  local end_line = #lines

  for i = cursor, 1, -1 do
    if is_h1(lines[i] or "") then
      start_line = i
      break
    end
  end

  for i = cursor + 1, #lines do
    if is_h1(lines[i] or "") then
      end_line = i - 1
      break
    end
  end

  return start_line, end_line
end

local function render()
  if not state.active then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local start_line, end_line = slide_bounds()

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  if start_line > 1 then
    vim.api.nvim_buf_set_extmark(bufnr, ns, 0, 0, {
      end_row = start_line - 1,
      conceal = " ",
    })
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)

  if end_line < line_count then
    vim.api.nvim_buf_set_extmark(bufnr, ns, end_line, 0, {
      end_row = line_count,
      conceal = " ",
    })
  end

  vim.cmd.normal({ args = { "zt" }, bang = true })
end

function M.next()
  vim.fn.search("^#\\s\\+", "W")
  render()
end

function M.prev()
  vim.fn.search("^#\\s\\+", "bW")
  render()
end

function M.start()
  if state.active then
    return
  end

  state.active = true
  state.saved.conceallevel = vim.wo.conceallevel
  state.saved.number = vim.wo.number
  state.saved.relativenumber = vim.wo.relativenumber
  state.saved.signcolumn = vim.wo.signcolumn
  state.saved.cursorline = vim.wo.cursorline

  vim.wo.conceallevel = 3
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.cursorline = false

  vim.keymap.set("n", "n", M.next, { buffer = true, desc = "Next slide" })
  vim.keymap.set("n", "p", M.prev, { buffer = true, desc = "Previous slide" })
  vim.keymap.set("n", "q", M.stop, { buffer = true, desc = "Stop slides" })

  render()
end

function M.stop()
  if not state.active then
    return
  end

  state.active = false

  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  vim.wo.conceallevel = state.saved.conceallevel
  vim.wo.number = state.saved.number
  vim.wo.relativenumber = state.saved.relativenumber
  vim.wo.signcolumn = state.saved.signcolumn
  vim.wo.cursorline = state.saved.cursorline
end

return M
