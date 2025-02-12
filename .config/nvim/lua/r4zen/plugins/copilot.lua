return {
  "zbirenbaum/copilot.lua",
  version = "*",
  opts = {
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<Tab>",
        accept_line = "<C-l>",
        accept_word = "<C-w>",
        next = "]]",
        prev = "[[",
      },
    },
  },
}
