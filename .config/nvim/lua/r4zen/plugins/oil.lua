local get_path_under_cursor = function(relative)
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  local dir = oil.get_current_dir()
  if not entry or not dir then
    error("Could not get path under cursor")
  end

  if relative then
    return vim.fn.fnamemodify(dir .. entry.name, ":.")
  end

  return dir .. entry.name
end

return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "ThePrimeagen/harpoon",
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<leader>yy"] = {
        desc = "Copy path of file under cursor",
        callback = function()
          vim.fn.setreg(vim.v.register, get_path_under_cursor())
        end,
      },
      ["<leader>yr"] = {
        desc = "Copy relative path of file under cursor",
        callback = function()
          vim.fn.setreg(vim.v.register, get_path_under_cursor(true))
        end,
      },

      -- Don't trigger harpoon mark keymaps in oil
      ["<leader>k"] = {
        callback = function()
          local path = get_path_under_cursor(true)

          -- load buffer into memory
          local bufnr = vim.api.nvim_create_buf(true, false)
          vim.api.nvim_buf_set_name(bufnr, path)
          vim.api.nvim_buf_call(bufnr, vim.cmd.edit)

          local list = require("harpoon"):list()
          local list_items = list.items
          table.insert(list_items, {
            context = { col = 0, row = 1 },
            value = path,
          })
          list.items = list_items

          require("harpoon.extensions").extensions:emit("ADD")
        end,
        desc = "Harpoon add",
      },
      ["<leader>j"] = {
        callback = function()
          local path = get_path_under_cursor(true)

          local list = require("harpoon"):list()
          local list_items = list.items
          for i, item in ipairs(list_items) do
            if item.value == path then
              table.remove(list_items, i)
              break
            end
          end
          list.items = list_items

          require("harpoon.extensions").extensions:emit("REMOVE")
        end,
        desc = "Harpoon remove",
      },

      -- Allow navigation between panes
      ["<C-h>"] = {
        callback = function()
          vim.cmd("TmuxNavigateLeft")
        end,
      },
      ["<C-l>"] = {
        callback = function()
          vim.cmd("TmuxNavigateRight")
        end,
      },
    },
  },
  keys = {
    { "-", "<CMD>Oil<CR>", mode = "n", desc = "Open parent directory" },
  },
}
