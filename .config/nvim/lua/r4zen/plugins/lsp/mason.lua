return {
  {
    "williamboman/mason.nvim",
    event = "LazyFile",
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
  {
    "williamboman/mason-lspconfig.nvim",
    event = "LazyFile",
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "LazyFile",
    opts = {
      ensure_installed = {
        "vtsls",
        "ts_ls",
        "eslint",
        "prettierd",
        "tailwindcss",
        "prismals",
        "biome",
        "js-debug-adapter",

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
        "harper_ls",
        "graphql",

        "rust_analyzer",
        "codelldb",
      },
    },
  },
}
