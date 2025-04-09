return {
  "mbbill/undotree",
  keys = {
    { "<leader>uu", vim.cmd.UndotreeToggle, desc = "Toggle undo tree" },
  },
  init = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
