return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  -- Includes conflict resolution functionality, soon to be v2.0.0
  branch = "next",
  cmd = "CodeDiff",
  keys = {
    { "<leader>gd", vim.cmd.CodeDiff, desc = "Show VSCode Git Status" },
  },
}
