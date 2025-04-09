return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    rules = {
      { pattern = "window", icon = " ", color = "blue" },
    },
  },
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>go", ":Google<space>", { desc = "Google it" })
    map("n", "<leader>gp", ":DuckDuckGo<space>", { desc = "DuckDuckGo it" })

    require("which-key").add({
      { "<leader>go", desc = "Google it", icon = { icon = "󰊯", color = "blue" } },
      { "<leader>gp", desc = "DuckDuckGo it", icon = { icon = "󰊯", color = "red" } },

      { "<leader>a", group = "AI", icon = { icon = "", color = "orange" } },
      { "<leader>A", group = "Copilot", icon = { icon = "", color = "green" } },
      { "<leader>s", group = "Search/Splits", icon = { icon = "󰍉", color = "yellow" } },
      { "<leader>f", group = "Files", icon = { icon = "󰈔", color = "blue" } },
      { "<leader>g", group = "Git", icon = { icon = "󰊢", color = "orange" } },
      { "<leader>b", group = "Git Blame", icon = { icon = "", color = "red" } },
      { "<leader>y", group = "Copy Path", icon = { icon = "", color = "yellow" } },
      { "<leader>c", group = "Code Actions", icon = { icon = "", color = "purple" } },
      { "<leader>r", group = "LSP", icon = { icon = "", color = "blue" } },
      { "<leader>m", group = "Markdown", icon = { icon = "󰍔", color = "grey" } },
      { "<leader>p", group = "Paste (.)", icon = { icon = "", color = "green" } },
      { "<leader>w", group = "Splits", icon = { icon = "", color = "blue" } },
      { "<leader>,", icon = { icon = "󰍉", color = "red" } },
      { "<leader><leader>", icon = { icon = "󰍉", color = "blue" } },
      { "<leader>.", icon = { icon = "󰍉", color = "blue" } },
      { "<leader>/", icon = { icon = "󰍉", color = "red" } },
    })
  end,
}
