return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    require("which-key").add({
      { "<leader>a", group = "AI" },
      { "<leader>A", group = "Augment" },
      { "<leader>s", group = "Search/Splits" },
      { "<leader>f", group = "Files" },
      { "<leader>g", group = "Git" },
      { "<leader>b", group = "Git Blame" },
      { "<leader>y", group = "Copy Path" },
      { "<leader>c", group = "Code Actions" },
      { "<leader>r", group = "LSP" },
      { "<leader>m", group = "Markdown" },
      { "<leader>p", group = "Paste (.)" },
    })
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
}
