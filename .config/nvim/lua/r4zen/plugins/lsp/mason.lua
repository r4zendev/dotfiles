return {
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "ts_ls",
        "eslint",
        "prettierd",
        "tailwindcss",
        "prismals",
        "biome",

        "html",
        "cssls",
        "svelte",

        "jsonls",
        "yamlls",

        "pyright",
        "black",
        "pylint",

        "lua_ls",
        "stylua",

        "clang-format",
        "typos_lsp",
        "graphql",
      },
    },
  },
}
