-- `biome` & `eslint` are used from LSP,
-- every other formatter is here in conform.
local js_formatters = function()
  return { "biome-organize-imports", "biome-check", "prettierd" }
end

return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  opts = {
    formatters = {
      ["biome-check"] = {
        condition = function(self, ctx)
          return require("lspconfig.util").root_pattern("biome.json")(vim.api.nvim_buf_get_name(0))
        end,
      },
      ["biome-organize-imports"] = {
        condition = function(self, ctx)
          return require("lspconfig.util").root_pattern("biome.json")(vim.api.nvim_buf_get_name(0))
        end,
      },
      -- Handled using LSP capabilities
      -- eslint_d = {
      --   condition = function(self, ctx)
      --     return require("lspconfig.util").root_pattern(
      --       ".eslintrc.js",
      --       ".eslintrc.cjs",
      --       ".eslintrc.yaml",
      --       ".eslintrc.yml",
      --       ".eslintrc.json"
      --     )(vim.api.nvim_buf_get_name(0))
      --   end,
      -- },
      prettierd = {
        -- Only attach if there's a prettier config file
        condition = function()
          return require("lspconfig.util").root_pattern(
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.yaml",
            ".prettierrc.yml",
            ".prettierrc.json"
          )(vim.api.nvim_buf_get_name(0))
        end,
      },
    },
    formatters_by_ft = {
      javascript = js_formatters,
      typescript = js_formatters,
      javascriptreact = js_formatters,
      typescriptreact = js_formatters,
      svelte = js_formatters,
      css = js_formatters,
      html = js_formatters,
      json = js_formatters,
      yaml = js_formatters,
      markdown = js_formatters,
      graphql = js_formatters,
      lua = { "stylua" },
      python = { "isort", "black" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    },
  },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end,
      mode = { "n", "v" },
      desc = "Format file or range (in visual mode)",
    },
  },
}
