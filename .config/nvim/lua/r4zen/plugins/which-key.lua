return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    rules = {
      { pattern = "window", icon = " ", color = "blue" },
    },
  },
  init = function()
    require("which-key").add({
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
      { "<leader>.", icon = { icon = ".", color = "purple" } },
    })
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
}
