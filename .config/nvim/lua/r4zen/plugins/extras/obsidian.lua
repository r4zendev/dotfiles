return {
  "epwalsh/obsidian.nvim",
  version = "*",
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "echasnovski/mini.nvim",
  },
  opts = {
    picker = {
      name = "mini.pick",
    },
    workspaces = {
      { name = "main", path = "~/vault/main" },
    },
  },
  keys = {
    {
      "<leader>nf",
      function()
        Snacks.picker.files({ cwd = vim.fn.expand("~/vault/main"), exclude = { ".obsidian" } })
      end,
      desc = "Find Obsidian Notes",
    },
  },
}
