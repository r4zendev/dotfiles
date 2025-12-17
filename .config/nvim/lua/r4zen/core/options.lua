local o = vim.o
local opt = vim.opt

-- TODO: remove this when authors update their plugins
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

o.updatetime = 100
o.timeout = true
o.timeoutlen = 500

-- required to make `vim-tmux-navigator` work.
-- if this affects my workflow in any way, i will remove it
-- and find another way to integrate with tmux panes
o.shell = "/bin/zsh"

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
-- vim.o.showtabline = 2 -- required for bufferline (tab) plugins to work properly (tabby / bufferline / etc)
o.showtabline = 0
opt.title = false
opt.conceallevel = 2

opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- persistent undo
opt.undofile = true

-- update file on external changes
opt.autoread = true

-- sign column & folding
opt.signcolumn = "number"
-- opt.signcolumn = "yes:1" -- both sign & number

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

opt.statuscolumn = "%{%v:lua.require('r4zen.statuscolumn').get_statuscolumn()%}"
-- o.qftf = "{info -> v:lua.require('r4zen.core.qftf').qftf(info)}"
