return {
  "augmentcode/augment.vim",
  config = function()
    vim.keymap.set({ "n", "v" }, "<leader>Ac", function()
      vim.cmd("Augment chat")
    end, { desc = "Augment: Ask" })

    vim.keymap.set({ "n", "v" }, "<leader>An", function()
      vim.cmd("Augment chat-new")
    end, { desc = "Augment: New Chat" })

    vim.keymap.set({ "n", "v" }, "<leader>At", function()
      vim.cmd("Augment chat-toggle")
    end, { desc = "Augment: Toggle Chat" })
  end,
}
