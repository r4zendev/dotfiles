return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<leader>yy"] = {
        desc = "Copy path of file under cursor",
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()
          if not entry or not dir then
            return
          end
          vim.fn.setreg(vim.v.register, dir .. entry.name)
        end,
      },
      ["<leader>yr"] = {
        desc = "Copy relative path of file under cursor",
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()
          if not entry or not dir then
            return
          end
          local relpath = vim.fn.fnamemodify(dir, ":.")
          vim.fn.setreg(vim.v.register, relpath .. entry.name)
        end,
      },
      -- Don't trigger harpoon mark keymaps in oil
      ["<leader>k"] = {
        callback = function() end,
      },
      ["<leader>j"] = {
        callback = function() end,
      },
    },
  },
  keys = {
    { "-", "<CMD>Oil<CR>", mode = "n", desc = "Open parent directory" },
  },
}
