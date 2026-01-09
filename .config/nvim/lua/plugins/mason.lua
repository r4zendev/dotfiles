return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  cmd = {
    "MasonToolsInstall",
    "MasonToolsInstallSync",
    "MasonToolsUpdate",
    "MasonToolsUpdateSync",
    "MasonToolsClean",
  },
  event = "VeryLazy",
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
    -- Done manually via custom approach (see init function below).
    -- That is to avoid having to disable lazy-load for mason-tool-installer
    -- which increases startup time significantly at times.
    run_on_start = false,
    auto_update = false,
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

      "marksman",
      "json-lsp",
      "yaml-language-server",

      "pylsp",
      "pyright",
      "black",
      "pylint",

      "lua-language-server",
      "stylua",

      "typos-lsp",
      "harper-ls",

      "zls",
      "gopls",
      "rust-analyzer",
      "bash-language-server",
      "clangd",
      "clang-format",
      "codelldb",
    },
  },
  init = function()
    -- Check once when opening a file
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
      once = true,
      callback = function()
        vim.cmd("MasonToolsUpdate")
        vim.cmd("MasonToolsInstall")
      end,
    })
  end,
}
