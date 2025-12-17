return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  -- Includes conflict resolution functionality
  branch = "next",
  cmd = "CodeDiff",
  keys = {
    { "<leader>gd", vim.cmd.CodeDiff, desc = "Show VSCode Git Status" },
  },
}
