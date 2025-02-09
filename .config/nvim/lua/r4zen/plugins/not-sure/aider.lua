return {
  "joshuavial/aider.nvim",
  config = function()
    require("aider").setup({
      auto_manage_context = true,
      default_bindings = false,
      debug = true,
    })

    vim.keymap.set("n", "<leader>ao", ":AiderOpen<CR>", { desc = "Open Aider" })
    vim.keymap.set("n", "<leader>am", ":AiderAddModifiedFiles<CR>", { desc = "Add Modified Files to Aider" })
  end,
}
