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
      "ts_ls",
      "tailwindcss",
      "prismals",
      "graphql",
      "astro",
      "svelte",
      "js-debug-adapter",

      "html-lsp",
      "css-lsp",

      "marksman",
      "jsonls",
      "yamlls",

      "pylsp",
      "pyright",
      "black",
      "pylint",

      { "lua_ls", version = "3.16.4" },

      "stylua",

      "typos_lsp",
      "harper-ls",

      "zls",
      "gopls",
      "rust_analyzer",
      "bashls",
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
