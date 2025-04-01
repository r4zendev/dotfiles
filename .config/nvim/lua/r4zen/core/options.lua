local opt = vim.opt
local o = vim.o
local ac = vim.api.nvim_create_autocmd

o.updatetime = 100

-- required to make `vim-tmux-navigator` work.
-- if this affects my workflow in any way, i will remove it
-- and find another way to integrate with tmux panes
o.shell = "/bin/bash"

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
-- vim.o.showtabline = 2 -- required for bufferline (tab) plugins to work properly (tabby / bufferline / etc)
-- opt.conceallevel = 2
vim.o.showtabline = 0
opt.title = false
opt.conceallevel = 0

opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- use system clipboard as default register
vim.schedule(function()
  opt.clipboard:append("unnamedplus")
end)

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- persistent undo
opt.undofile = true

-- update file on external changes
opt.autoread = true

-- sign column
opt.signcolumn = "number"
-- opt.signcolumn = "yes:1" -- both sign & number

-- folding
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.opt.foldcolumn = "1" -- Changed to 1 to show fold icons
vim.opt.fillchars:append({
  fold = " ",
  foldclose = "▶",
  foldopen = "▼",
  foldsep = " ",
})

-- Set custom statuscolumn that includes line numbers and fold icons
opt.statuscolumn = "%{%v:lua.require('r4zen.core.statuscolumn').fold_column()%}%=%{v:relnum?v:relnum:v:lnum} "

ac("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
