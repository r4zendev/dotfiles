return {
  "github/copilot.vim",
  cmd = "Copilot",
  event = "LazyFile",
  keys = {
    { "<leader>ap", "<cmd>Copilot<cr>", desc = "Copilot: Open Panel" },
    { "<c-w>", "<Plug>(copilot-accept-word)", mode = "i", desc = "Copilot: Accept Word" },
    { "<c-l>", "<Plug>(copilot-accept-line)", mode = "i", desc = "Copilot: Accept Line" },
    { "[[", "<Plug>(copilot-previous)", mode = "i", desc = "Copilot: Previous Suggestion" },
    { "]]", "<Plug>(copilot-next)", mode = "i", desc = "Copilot: Next Suggestion" },
  },
  init = function()
    vim.g.copilot_enabled = false

    -- Workspace folders
    vim.g.copilot_workspace_folders = { require("r4zen.utils").workspace_root() }
    -- Use gpt-4o model
    -- vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
    -- vim.g.copilot_integration_id = "vscode-chat"

    -- NOTE: Hacky workaround to prevent Copilot LSP from hanging
    -- and noice.nvim showing lsp progress forever.
    -- It seemed to me that the panel feature in copilot.lua
    -- is even more broken, so I'm still using tpope
    local DEFER_TIME = 300
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "copilot",
      callback = function()
        vim.api.nvim_create_autocmd("BufWinLeave", {
          buffer = 0,
          once = true,
          callback = function()
            vim.defer_fn(function()
              vim.cmd("silent! Copilot restart")
              vim.defer_fn(function()
                vim.cmd("silent! Copilot restart")
              end, DEFER_TIME)
            end, DEFER_TIME)
          end,
        })
      end,
    })
  end,
}
