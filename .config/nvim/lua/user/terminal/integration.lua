-- lua/user/terminal/integration.lua

local M = {}

local ns_prompt = vim.api.nvim_create_namespace("user.terminal.prompt")

local function config_term_esc(bufnr)
  vim.keymap.set("t", "<C-a><Esc>", [[<C-\><C-N>]], {
    buffer = bufnr,
    desc = "Terminal normal mode",
  })

  -- Map ESC to ESC, so we have a way to send literal ESC.
  vim.keymap.set("t", "<Esc>", "<Esc>", {
    buffer = bufnr,
    desc = "Send ESC to terminal",
  })
end

local function handle_osc133(ev)
  if not ev.data.sequence:match("^\027%]133;A") then
    return false
  end

  local lnum = ev.data.cursor[1]

  -- TermRequest may report line 0 when no terminal cursor position is available.
  -- Extmark rows are zero-based, so converting that value would produce -1.
  if lnum < 1 then
    return true
  end

  vim.api.nvim_buf_set_extmark(ev.buf, ns_prompt, lnum - 1, 0, {
    sign_text = "∙",
  })

  return true
end

local function handle_osc7(ev)
  local dir, n = ev.data.sequence:gsub("^\027%]7;file://[^/]*", "")

  if n == 0 then
    return false
  end

  if vim.fn.isdirectory(dir) == 0 then
    vim.notify("Invalid terminal cwd: " .. dir, vim.log.levels.WARN)
    return true
  end

  vim.b[ev.buf].terminal_cwd = dir

  if vim.api.nvim_get_current_buf() == ev.buf then
    vim.cmd.lcd(vim.fn.fnameescape(dir))
  end

  return true
end

function M.setup()
  vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("user/terminal/open", { clear = true }),
    callback = function(args)
      -- FzfLua uses a terminal buffer but manages its own input.
      if vim.bo[args.buf].filetype == "fzf" then
        return
      end
      vim.opt_local.signcolumn = "auto"
      config_term_esc(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("TermRequest", {
    group = vim.api.nvim_create_augroup("user/terminal/request", { clear = true }),
    callback = function(ev)
      handle_osc133(ev)
      handle_osc7(ev)
    end,
  })
end

return M
