return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    -- default
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
  keys = {
    { "<leader>ap", "<cmd>Copilot panel<cr>", desc = "Copilot Panel", mode = "n" },
  },
}
