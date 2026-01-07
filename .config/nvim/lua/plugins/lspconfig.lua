return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { "neovim/nvim-lspconfig", "b0o/schemastore.nvim" },
  opts = {
    automatic_enable = {
      exclude = {
        "ts_ls",
        "vtsls",
        -- "tsgo",
        "harper_ls",
      },
    },
  },
}
