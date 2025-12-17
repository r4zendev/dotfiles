return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    { "<leader>gd", vim.cmd.CodeDiff, desc = "Show VSCode Git Status" },
  },
}
