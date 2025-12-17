-- This is the worst option of all the autocompletes I've tried
return {
  "Exafunction/windsurf.nvim",
  name = "codeium",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = "LazyFile",
  opts = {
    enable_cmp_source = false,
    virtual_text = {
      enabled = true,
      manual = false,
      filetypes = {},
      default_filetype_enabled = true,
      idle_delay = 75,
      virtual_text_priority = 65535,
      -- Defaults to \t normally or <c-n> when a popup is showing.
      accept_fallback = nil,
      key_bindings = {
        accept = "<Tab>",
        accept_line = "<C-l>",
        accept_word = "<C-w>",
        -- accept_word = false,
        -- accept_line = false,
        clear = false,
        next = "]]",
        prev = "[[",
      },
    },
    workspace_root = {
      use_lsp = true,
      find_root = require("utils").workspace_root,
      paths = {
        ".bzr",
        ".git",
        ".hg",
        ".svn",
        "_FOSSIL_",
        "package.json",
      },
    },
  },
  keys = {
    {
      "<leader>Ac",
      function()
        vim.cmd("Codeium Chat")
      end,
      mode = { "n", "v" },
      desc = "Codeium Chat",
    },
  },
}
