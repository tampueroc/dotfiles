-- lua/user/tabline.lua

local M = {}

local function tab_label(tabnr)
  local tab_cwd = vim.fn.getcwd(-1, tabnr)
  local global_cwd = vim.fn.getcwd(-1, -1)

  if tab_cwd ~= global_cwd then
    return ("󰉋 %s/"):format(vim.fn.fnamemodify(tab_cwd, ":t"))
  end

  local buflist = vim.fn.tabpagebuflist(tabnr)
  local winnr = vim.fn.tabpagewinnr(tabnr)
  local bufnr = buflist[winnr]
  local name = vim.api.nvim_buf_get_name(bufnr)

  if name == "" then
    return "[No Name]"
  end

  local is_dir = vim.fn.isdirectory(name) == 1
  local label = vim.fn.fnamemodify(name, is_dir and ":h:t" or ":t")

  if is_dir then
    label = label .. "/"
  end

  if #label > 20 then
    label = label:sub(1, 20) .. "…"
  end

  return label
end

function M.render()
  local parts = {}

  for i = 1, vim.fn.tabpagenr("$") do
    local hl = i == vim.fn.tabpagenr() and "%#TabLineSel#" or "%#TabLine#"
    table.insert(parts, ("%s%%%dT %d %s "):format(hl, i, i, tab_label(i)))
  end

  table.insert(parts, "%#TabLineFill#%T")
  return table.concat(parts)
end

function M.setup()
  vim.o.showtabline = 1
  vim.o.tabline = "%!v:lua.require'user.tabline'.render()"
end

return M
