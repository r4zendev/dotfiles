return {
  {
    "augmentcode/augment.vim",
    keys = {
      { "<leader>Ac", "<cmd>Augment chat<cr>", desc = "Augment: Ask", mode = { "n", "v" } },
      { "<leader>An", "<cmd>Augment chat-new<cr>", desc = "Augment: New Chat" },
      { "<leader>At", "<cmd>Augment chat-toggle<cr>", desc = "Augment: Toggle Chat" },
    },
    config = function()
      vim.g.augment_disable_tab_mapping = true
      vim.g.augment_workspace_folders = { vim.fn.getcwd() }
      -- Currently using copilot, but want to have access to the chat
      vim.cmd([[Augment disable]])
    end,
  },
  {
    "github/copilot.vim",
    dependencies = {
      -- Making sure this loads first and unmaps tab,
      -- then copilot will map it back
      "augmentcode/augment.vim",
    },
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    -- event = { "InsertEnter" },
    init = function()
      vim.g.copilot_workspace_folders = { vim.fn.getcwd() }

      -- Use gpt-4o
      vim.g.copilot_no_tab_map = false
      vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
      vim.g.copilot_integration_id = "vscode-chat"

      vim.keymap.set("n", "<leader>ap", "<cmd>Copilot<cr>", {
        desc = "Copilot Panel",
        noremap = true,
        silent = true,
      })
    end,
  },
}
