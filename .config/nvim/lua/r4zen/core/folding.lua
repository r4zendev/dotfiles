local o = vim.o
local opt = vim.opt
local ac = vim.api.nvim_create_autocmd

-- sign column
opt.signcolumn = "number"
-- opt.signcolumn = "yes:1" -- both sign & number

-- folding
o.foldenable = true
o.foldlevel = 99
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""
opt.foldcolumn = "1" -- Changed to 1 to show fold icons
opt.fillchars:append({
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
