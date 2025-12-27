return {
  "ninetyfive-gg/ninetyfive.nvim",
  -- version = "*", -- use stable version
  cmd = { "Ninetyfive" },
  event = "InsertEnter",
  opts = {
    mappings = {
      enabled = true,
      accept = "<Tab>",
      accept_word = "<C-w>",
      accept_line = "<C-l>",
      reject = "<C-]>",
    },
  },
}
