return {
  "mg979/vim-visual-multi",
  config = function()
    -- vim.keymap.set("n", "", "<Plug>(VM-Find-Under)")
    vim.keymap.set("n", ",a", "<Plug>(VM-Select-All)")
    vim.keymap.set("n", ",j", "<Plug>(VM-Add-Cursor-Down)")
    vim.keymap.set("n", ",k", "<Plug>(VM-Add-Cursor-Up)")

    vim.keymap.set("v", ",a", "<Plug>(VM-Visual-All)")
  end,
}
