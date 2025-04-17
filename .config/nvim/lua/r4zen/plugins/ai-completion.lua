return {
  -- {
  --   "reachingforthejack/cursortab.nvim",
  --   build = "go install .",
  --   event = "InsertEnter",
  -- },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- workspace_folders = { require("r4zen.utils").workspace_root() },
      copilot_model = "gpt-4o-copilot", -- gpt-35-turbo | gpt-4o-copilot

      panel = {
        enabled = true,
        auto_refresh = true,
      },

      suggestion = {
        -- Trying out other completion plugins, keeping the copilot panel for now
        -- Copilot is also used in codecompanion for access to its chat models
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          accept_line = "<C-l>",
          accept_word = "<C-w>",
          prev = "[[",
          next = "]]",
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>ap", function() vim.cmd("Copilot panel") end, desc = "Copilot Panel" },
    },
  },
  {
    "augmentcode/augment.vim",
    cmd = "Augment",
    -- Cannot be called on InsertEnter, since plugin would not be loaded at that point.
    -- It initializes and authenticates and only then starts to provide suggestions.
    -- Hopefully will be fixed eventually, as this works fine in copilot.
    event = "LazyFile",
    -- stylua: ignore
    keys = {
      { "<leader>au", function() vim.cmd("Augment chat") end, desc = "Augment Chat", mode = { "n", "v" } },
      -- { "<leader>an", function() vim.cmd("Augment chat-new") end, desc = "Augment: New Chat" },
      -- { "<leader>at", function() vim.cmd("Augment chat-toggle") end, desc = "Augment: Toggle Chat" },
    },
    init = function()
      -- Add workspaces for better suggestions
      vim.g.augment_workspace_folders = { require("r4zen.utils").workspace_root() }

      -- Disable completion in favor of minuet, but keep the chat available
      vim.g.augment_disable_completions = true
      vim.g.augment_disable_tab_mapping = true
    end,
  },
}
