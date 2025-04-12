return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    defaults = {},
    rules = {
      { pattern = "window", icon = " ", color = "blue" },
    },
    spec = {
      {
        { "<leader>,", icon = { icon = "󰍉", color = "red" } },
        { "<leader>.", icon = { icon = "󰍉", color = "blue" } },
        { "<leader>/", icon = { icon = "󰍉", color = "red" } },
        { "<leader><leader>", icon = { icon = "󰍉", color = "blue" } },

        { "<leader>A", group = "Aider REPL", icon = { icon = "", color = "green" } },
        { "<leader>Am", group = "Toggle Aider Mode", icon = { icon = "", color = "green" } },
        { "<leader>a", group = "AI", icon = { icon = "", color = "orange" } },
        { "<leader>b", group = "REPL", icon = { icon = "", color = "red" } },
        { "<leader>c", group = "LSP/Format", icon = { icon = "", color = "blue" } },
        { "<leader>d", group = "Debug", icon = { icon = "", color = "red" } },
        { "<leader>f", group = "Files", icon = { icon = "󰈔", color = "blue" } },
        { "<leader>g", group = "Git", icon = { icon = "󰊢", color = "orange" } },
        { "<leader>gB", group = "Git Blame", icon = { icon = "󰊢", color = "orange" } },
        { "<leader>go", desc = "Google it", icon = { icon = "󰊯", color = "blue" } },
        { "<leader>gp", desc = "DuckDuckGo it", icon = { icon = "󰊯", color = "red" } },
        { "<leader>m", group = "Markdown", icon = { icon = "󰍔", color = "grey" } },
        { "<leader>n", group = "Notes (Obsidian)", icon = { icon = "", color = "cyan" } },
        { "<leader>o", group = "Overseer", icon = { icon = "", color = "green" } },
        { "<leader>p", group = "Paste/Pick Color", icon = { icon = "", color = "green" } },
        { "<leader>r", group = "Refactoring", icon = { icon = "", color = "green" } },
        { "<leader>rb", group = "Refactoring: Block", icon = { icon = "", color = "green" } },
        { "<leader>s", group = "Search/Splits", icon = { icon = "󰍉", color = "yellow" } },
        { "<leader>t", group = "Testing", icon = { icon = "󰙨", color = "yellow" } },
        { "<leader>u", group = "Undotree/Colors", icon = { icon = "←", color = "red" } },
        { "<leader>w", group = "Splits", icon = { icon = "", color = "blue" } },
        { "<leader>x", group = "Trouble/Quickfix", icon = { icon = "!", color = "red" } },
        { "<leader>y", group = "Copy Path", icon = { icon = "", color = "yellow" } },
        { "gx", desc = "Open with system app" },
      },
    },
  },
}
