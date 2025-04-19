local map = vim.keymap.set

return {
  enabled = false,
  init_options = { hostInfo = "neovim" },
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  on_attach = function(client, bufnr)
    local lsp_utils = require("r4zen.lsp_utils")
    lsp_utils.on_attach(client, bufnr)

    local opts = function(desc)
      return { desc = desc, buffer = bufnr, silent = true, noremap = true }
    end

    map("n", "<leader>ci", lsp_utils.lsp_action["source.organizeImports"], opts("Organize Imports"))
    map("n", "<leader>cT", function()
      lsp_utils.toggle_ts_server(client)
    end, opts("Toggle vtsls"))
  end,
}
