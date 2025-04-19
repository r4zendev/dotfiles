return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
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
  event = "LazyFile",
  cmd = {
    "MasonToolsInstall",
    "MasonToolsInstallSync",
    "MasonToolsUpdate",
    "MasonToolsUpdateSync",
    "MasonToolsClean",
  },
  opts = {
    -- Done manually via custom approach
    run_on_start = false,
    auto_update = false,
    ensure_installed = {
      "vtsls",
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

      "bash-language-server",
      "rust-analyzer",
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
        vim.cmd("MasonToolsInstall")
      end,
    })
  end,
}
