return {
  "stevearc/oil.nvim",
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  -- Optional dependencies
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local oil = require("oil")

    oil.setup({
      view_options = {
        show_hidden = true,
      },
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
