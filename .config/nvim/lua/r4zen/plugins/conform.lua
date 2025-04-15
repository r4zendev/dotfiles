-- `biome` & `eslint` are used from LSP,
-- every other formatter is here in conform.
local js_formatters = function()
  return { "biome-organize-imports", "biome-check", "prettierd" }
end

return {
  "stevearc/conform.nvim",
  event = "LazyFile",
  opts = {
    formatters = {
      ["biome-check"] = {
        condition = function()
          return require("lspconfig.util").root_pattern("biome.json")(vim.api.nvim_buf_get_name(0))
        end,
      },
      ["biome-organize-imports"] = {
        condition = function()
          return require("lspconfig.util").root_pattern("biome.json")(vim.api.nvim_buf_get_name(0))
        end,
      },
      prettierd = {
        condition = function()
          local fname = vim.api.nvim_buf_get_name(0)
          local util = require("lspconfig.util")

          local prettier_root_file = {
            -- https://prettier.io/docs/en/configuration.html
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            ".prettierrc.toml",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
          }

          prettier_root_file = util.insert_package_json(prettier_root_file, "prettier", fname)
          return util.root_pattern(prettier_root_file)(fname)
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
      c = { "clang_format" },
      cpp = { "clang_format" },
      rust = { "rustfmt" },
    },

    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      return { timeout_ms = 1500, lsp_fallback = true }
    end,
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
    {
      "<leader>ct",
      function()
        if vim.g.disable_autoformat or vim.b.disable_autoformat then
          vim.cmd("FormatEnable")
          vim.notify("Autoformat enabled", vim.log.levels.INFO, { title = "Conform" })
        else
          vim.cmd("FormatDisable")
          vim.notify("Autoformat disabled", vim.log.levels.INFO, { title = "Conform" })
        end
      end,
      mode = { "n", "v" },
      desc = "Toggle formatting",
    },
  },
  init = function()
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Re-enable autoformat-on-save" })
  end,
}
