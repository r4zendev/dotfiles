return {
  "github/copilot.vim",
  lazy = false,
  cmd = "Copilot",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    { "<leader>ap", "<cmd>Copilot<cr>", desc = "Copilot Panel" },
  },
  init = function()
    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
    vim.g.copilot_no_tab_map = false

    -- Use gpt-4o
    vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
    vim.g.copilot_integration_id = "vscode-chat"
  end,
}
