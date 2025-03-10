return {
  "augmentcode/augment.vim",
  event = "VeryLazy",
  keys = {
    { "<leader>Ac", "<cmd>Augment chat<cr>", desc = "Augment: Ask", mode = { "n", "v" } },
    { "<leader>An", "<cmd>Augment chat-new<cr>", desc = "Augment: New Chat" },
    { "<leader>At", "<cmd>Augment chat-toggle<cr>", desc = "Augment: Toggle Chat" },
  },
}
