return {
  "mg979/vim-visual-multi",
  config = function()
    vim.keymap.set("n", ",a", "<Plug>(VM-Select-All)")
    vim.keymap.set("v", ",a", "<Plug>(VM-Visual-All)")
  end,
}
