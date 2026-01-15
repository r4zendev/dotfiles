local o = vim.o
local opt = vim.opt

o.updatetime = 100
o.timeout = true
o.timeoutlen = 500

o.list = false
o.listchars = "tab:▸ ,lead:·,trail:·,nbsp:␣,extends:▶,precedes:◀,eol:↲" -- bigger dot if desired: •

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

opt.cursorline = true

-- vim.o.showtabline = 2 -- required for bufferline (tab) plugins to work properly (tabby / bufferline / etc)
o.showtabline = 0
opt.title = false
opt.conceallevel = 0

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false
opt.undofile = true
opt.autoread = true

opt.foldenable = true
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldcolumn = "1"
opt.fillchars:append({
  fold = " ",
  foldclose = "▶",
  foldopen = "▼",
  foldsep = " ",
})

-- local diagnostic_icons = require("icons").diagnostics
-- vim.diagnostic.config({
--   virtual_text = {
--     prefix = "●",
--   },
--   signs = true,
--   underline = true,
--   update_in_insert = false,
--   severity_sort = true,
-- })
-- local signs = {
--   [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
--   [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
--   [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
--   [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
-- }
