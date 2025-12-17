return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false,
  -- event = "VimEnter",
  -- cmd = {
  --   "MasonToolsInstall",
  --   "MasonToolsInstallSync",
  --   "MasonToolsUpdate",
  --   "MasonToolsUpdateSync",
  --   "MasonToolsClean",
  -- },
  dependencies = {
    {
      "williamboman/mason.nvim",
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
  },
  opts = {
    -- Can be done manually via custom approach (see init function below)
    -- For that to work properly disable two of the options below
    run_on_start = true,
    auto_update = true,
    ensure_installed = {
      "vtsls",
      "tsgo",
      "biome",
      "eslint-lsp",
      "prettierd",
      "typescript-language-server",
      "tailwindcss-language-server",
      "prisma-language-server",
      "graphql-language-service-cli",
      "astro-language-server",
      "svelte-language-server",
      "js-debug-adapter",
      "html-lsp",
      "css-lsp",

      "json-lsp",
      "yaml-language-server",

      "pyright",
      "black",
      "pylint",

      "lua-language-server",
      "stylua",

      "typos-lsp",
      "harper-ls",

      "gopls",
      "bash-language-server",
      "rust-analyzer",
      "clangd",
      "clang-format",
      "codelldb",
    },
  },
  -- init = function()
  --   -- Check once when opening a file
  --   vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
  --     once = true,
  --     callback = function()
  --       vim.cmd("MasonToolsInstall")
  --     end,
  --   })
  -- end,
}
