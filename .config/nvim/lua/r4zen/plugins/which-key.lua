return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    rules = {
      { pattern = "window", icon = " ", color = "blue" },
    },
  },
  init = function()
    local Icons = require("mini.icons")

    require("which-key").add({
      { "<leader>a", group = "AI", icon = { icon = Icons.get("lsp", "event"), color = "orange" } },
      { "<leader>A", group = "Copilot", icon = { icon = Icons.get("lsp", "snippet"), color = "green" } },
      { "<leader>s", group = "Search/Splits", icon = { icon = "󰍉", color = "yellow" } },
      { "<leader>f", group = "Files", icon = { icon = Icons.get("file", "default"), color = "blue" } },
      { "<leader>g", group = "Git", icon = { icon = Icons.get("file", ".git"), color = "orange" } },
      { "<leader>b", group = "Git Blame", icon = { icon = Icons.get("lsp", "reference"), color = "red" } },
      { "<leader>y", group = "Copy Path", icon = { icon = Icons.get("lsp", "text"), color = "yellow" } },
      { "<leader>c", group = "Code Actions", icon = { icon = Icons.get("lsp", "method"), color = "purple" } },
      { "<leader>C", group = "Text Case", icon = { icon = Icons.get("lsp", "text"), color = "purple" } },
      { "<leader>r", group = "LSP", icon = { icon = Icons.get("lsp", "interface"), color = "blue" } },
      { "<leader>m", group = "Markdown", icon = { icon = Icons.get("filetype", "markdown"), color = "grey" } },
      { "<leader>p", group = "Paste (.)", icon = { icon = Icons.get("lsp", "field"), color = "green" } },
      { "<leader>w", group = "Splits", icon = { icon = "", color = "blue" } },
      { "<leader>.", icon = { icon = ".", color = "purple" } },
      --
      -- -- Marks
      -- {
      --   "<leader>k",
      --   group = "Marks",
      --   icon = { icon = Icons.get("lsp", "bookmark") and Icons.get("lsp", "bookmark"), color = "red" },
      -- },
    })
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
}
