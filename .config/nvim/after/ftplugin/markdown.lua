-- Remove binding from jghauser/follow-md-links.nvim
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.schedule(function()
      vim.keymap.del("n", "<cr>", { buffer = 0 })
      -- or set your own:
      vim.keymap.set("n", "<cr>", "<your mapping>", { buffer = 0 })
    end)
  end,
})

-- And replace with my own:
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "ge",
  ':lua require("follow-md-links").follow_link()<cr>',
  { noremap = true, silent = true }
)
