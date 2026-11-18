vim.cmd.highlight("clear")

if vim.fn.exists("syntax_on") == 1 then
  vim.cmd.syntax("reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "scheme"

local c = {
  bg = "#1A1B26",
  bg_dark = "#15161E",
  bg_highlight = "#292E42",
  selection = "#33467C",

  fg = "#C0CAF5",
  fg_dark = "#A9B1D6",
  comment = "#414868",

  red = "#F7768E",
  green = "#9ECE6A",
  yellow = "#E0AF68",
  blue = "#7AA2F7",
  magenta = "#BB9AF7",
  cyan = "#7DCFFF",
  white = "#C0CAF5",
  orange = "#FF9E64",
}

vim.g.terminal_color_0 = c.bg_dark
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.magenta
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.fg_dark
vim.g.terminal_color_8 = c.comment
vim.g.terminal_color_9 = c.red
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.yellow
vim.g.terminal_color_12 = c.blue
vim.g.terminal_color_13 = c.magenta
vim.g.terminal_color_14 = c.cyan
vim.g.terminal_color_15 = c.white
vim.g.terminal_color_background = c.bg
vim.g.terminal_color_foreground = c.fg

local groups = {
  -- Base UI
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { fg = c.fg, bg = c.bg },
  EndOfBuffer = { fg = c.bg, bg = c.bg },
  SignColumn = { bg = c.bg },
  ColorColumn = { bg = c.bg_highlight },
  CursorLine = { bg = c.bg_highlight },
  CursorLineNr = { fg = c.yellow, bold = true },
  LineNr = { fg = c.comment },
  NonText = { fg = c.comment },
  SpecialKey = { fg = c.comment },
  Visual = { bg = c.selection },
  Search = { fg = c.bg, bg = c.yellow },
  CurSearch = { fg = c.bg, bg = c.orange },
  IncSearch = { link = "CurSearch" },
  MatchParen = { fg = c.orange, bold = true },

  -- Status/cmd
  StatusLine = { fg = c.fg, bg = c.bg_dark },
  StatusLineNC = { fg = c.comment, bg = c.bg_dark },
  MsgArea = { fg = c.fg },
  MsgSeparator = { fg = c.comment },

  StatuslineItalic = { fg = c.comment, bg = c.bg_dark, italic = true },
  StatuslineSpinner = { fg = c.green, bg = c.bg_dark, bold = true },
  StatuslineTitle = { fg = c.white, bg = c.bg_dark, bold = true },
  StatuslineModeSeparatorOther = { fg = c.cyan, bg = c.bg_dark },

  -- Syntax
  Comment = { fg = c.comment, italic = true },
  Constant = { fg = c.orange },
  String = { fg = c.green },
  Character = { fg = c.green },
  Number = { fg = c.orange },
  Boolean = { fg = c.orange },
  Float = { fg = c.orange },
  Identifier = { fg = c.fg },
  Function = { fg = c.blue },
  Statement = { fg = c.magenta },
  Conditional = { fg = c.magenta },
  Repeat = { fg = c.magenta },
  Label = { fg = c.magenta },
  Operator = { fg = c.cyan },
  Keyword = { fg = c.magenta },
  Exception = { fg = c.magenta },
  PreProc = { fg = c.cyan },
  Include = { fg = c.magenta },
  Define = { fg = c.magenta },
  Macro = { fg = c.magenta },
  Type = { fg = c.cyan },
  StorageClass = { fg = c.magenta },
  Structure = { fg = c.cyan },
  Typedef = { fg = c.cyan },
  Special = { fg = c.cyan },
  Underlined = { fg = c.blue, underline = true },
  Todo = { fg = c.yellow, bold = true },

  -- Treesitter
  ["@variable"] = { fg = c.fg },
  ["@variable.builtin"] = { fg = c.red },
  ["@variable.parameter"] = { fg = c.orange },
  ["@variable.member"] = { fg = c.cyan },
  ["@constant"] = { fg = c.orange },
  ["@constant.builtin"] = { fg = c.orange },
  ["@constant.macro"] = { fg = c.cyan },
  ["@module"] = { fg = c.yellow },
  ["@label"] = { fg = c.magenta },

  ["@string"] = { fg = c.green },
  ["@string.escape"] = { fg = c.cyan },
  ["@string.regexp"] = { fg = c.red },
  ["@character"] = { fg = c.green },
  ["@boolean"] = { fg = c.orange },
  ["@number"] = { fg = c.orange },
  ["@number.float"] = { fg = c.orange },

  ["@type"] = { fg = c.cyan },
  ["@type.builtin"] = { fg = c.cyan, italic = true },
  ["@constructor"] = { fg = c.cyan },
  ["@property"] = { fg = c.cyan },
  ["@attribute"] = { fg = c.yellow },

  ["@function"] = { fg = c.blue },
  ["@function.builtin"] = { fg = c.cyan },
  ["@function.method"] = { fg = c.blue },
  ["@function.macro"] = { fg = c.blue },

  ["@keyword"] = { fg = c.magenta },
  ["@keyword.function"] = { fg = c.magenta },
  ["@keyword.operator"] = { fg = c.magenta },
  ["@keyword.conditional"] = { fg = c.magenta },
  ["@keyword.repeat"] = { fg = c.magenta },
  ["@keyword.exception"] = { fg = c.magenta },
  ["@keyword.import"] = { fg = c.magenta },

  ["@operator"] = { fg = c.cyan },
  ["@punctuation.delimiter"] = { fg = c.fg_dark },
  ["@punctuation.bracket"] = { fg = c.fg_dark },
  ["@punctuation.special"] = { fg = c.cyan },

  ["@markup.heading"] = { fg = c.magenta, bold = true },
  ["@markup.strong"] = { fg = c.orange, bold = true },
  ["@markup.italic"] = { fg = c.yellow, italic = true },
  ["@markup.link"] = { fg = c.blue, underline = true },
  ["@markup.link.uri"] = { fg = c.cyan, underline = true },
  ["@markup.raw"] = { fg = c.green },
  ["@markup.list"] = { fg = c.cyan },

  -- LSP semantic
  ["@lsp.type.class"] = { fg = c.cyan },
  ["@lsp.type.enum"] = { fg = c.cyan },
  ["@lsp.type.interface"] = { fg = c.cyan },
  ["@lsp.type.struct"] = { fg = c.cyan },
  ["@lsp.type.type"] = { fg = c.cyan },
  ["@lsp.type.function"] = { fg = c.blue },
  ["@lsp.type.method"] = { fg = c.blue },
  ["@lsp.type.property"] = { fg = c.cyan },
  ["@lsp.type.parameter"] = { fg = c.orange },
  ["@lsp.type.variable"] = { fg = c.fg },

  -- Diagnostics
  DiagnosticError = { fg = c.red },
  DiagnosticWarn = { fg = c.yellow },
  DiagnosticInfo = { fg = c.cyan },
  DiagnosticHint = { fg = c.green },
  DiagnosticUnderlineError = { undercurl = true, sp = c.red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
  DiagnosticUnderlineInfo = { undercurl = true, sp = c.cyan },
  DiagnosticUnderlineHint = { undercurl = true, sp = c.green },
  DiagnosticVirtualTextError = { fg = c.red, bg = c.bg_dark },
  DiagnosticVirtualTextWarn = { fg = c.yellow, bg = c.bg_dark },
  DiagnosticVirtualTextInfo = { fg = c.cyan, bg = c.bg_dark },
  DiagnosticVirtualTextHint = { fg = c.green, bg = c.bg_dark },
  LspInlayHint = { fg = c.comment, italic = true },

  -- Completion
  Pmenu = { fg = c.fg, bg = c.bg_dark },
  PmenuSel = { fg = c.bg, bg = c.blue },
  PmenuSbar = { bg = c.bg_dark },
  PmenuThumb = { bg = c.comment },

  BlinkCmpMenu = { fg = c.fg, bg = c.bg_dark },
  BlinkCmpMenuBorder = { fg = c.comment, bg = c.bg_dark },
  BlinkCmpLabelDescription = { fg = c.comment, italic = true },
  BlinkCmpLabelDetail = { fg = c.comment },

  -- Git
  GitSignsAdd = { fg = c.green },
  GitSignsChange = { fg = c.blue },
  GitSignsDelete = { fg = c.red },
  GitSignsCurrentLineBlame = { fg = c.comment },

  DiffAdd = { fg = c.green, bg = c.bg_dark },
  DiffChange = { fg = c.yellow, bg = c.bg_dark },
  DiffDelete = { fg = c.red, bg = c.bg_dark },
  DiffText = { fg = c.orange, bg = c.bg_highlight, bold = true },

  -- Fzf
  FzfLuaBorder = { fg = c.comment },
  FzfLuaHeaderBind = { fg = c.magenta },
  FzfLuaHeaderText = { fg = c.cyan },
  FzfLuaSearch = { fg = c.red, bg = c.bg_dark },
  FzfLuaPreviewTitle = { fg = c.fg },

  -- Tabs
  TabLine = { fg = c.comment, bg = c.bg },
  TabLineFill = { bg = c.bg },
  TabLineSel = { fg = c.bg, bg = c.magenta },

  -- Misc
  Directory = { fg = c.blue },
  Folded = { fg = c.comment, bg = c.bg_dark },
  FoldColumn = { fg = c.comment, bg = c.bg },
  QuickFixLine = { bg = c.bg_highlight },
  WinSeparator = { fg = c.comment, bg = c.bg },
  FloatBorder = { fg = c.comment, bg = c.bg },
  NormalFloat = { fg = c.fg, bg = c.bg },
}

for group, opts in pairs(groups) do
  vim.api.nvim_set_hl(0, group, opts)
end

vim.fn.sign_define("DapBreakpoint", {
  text = "⚪",
  texthl = "DiagnosticError",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("DapStopped", {
  text = "🔴",
  texthl = "DiagnosticWarn",
  linehl = "Visual",
  numhl = "",
})

vim.fn.sign_define("DapBreakpointRejected", {
  text = "⭕",
  texthl = "DiagnosticError",
  linehl = "",
  numhl = "",
})
