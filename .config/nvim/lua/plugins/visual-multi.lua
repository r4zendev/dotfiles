return {
  "mg979/vim-visual-multi",
  event = "LazyFile",
  init = function()
    vim.keymap.set("n", "<C-w>", "<C-e>", { silent = true, noremap = true })

    vim.g.VM_leader = "<C-x>"
    vim.g.VM_maps = {
      ["Mouse Cursor"] = "<C-LeftMouse>",
      ["Mouse Word"] = "<C-RightMouse>",
      ["Mouse Column"] = "<M-C-RightMouse>",
      ["Undo"] = "u",
      ["Redo"] = "<C-r>",
    }
  end,
}
