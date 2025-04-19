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
  event = "VeryLazy",
  cmd = { "Oil" },
  dependencies = { "echasnovski/mini.nvim" },
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

          require("harpoon"):list():add({
            context = { col = 0, row = 1 },
            value = path,
          })
        end,
        desc = "Harpoon add",
      },
      ["<leader>j"] = {
        callback = function()
          local path = get_path_under_cursor(true)

          local list = require("harpoon"):list()

          for _, item in ipairs(list.items) do
            if item.value == path then
              list:remove(item)
              break
            end
          end
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
    { "-", vim.cmd.Oil, mode = "n", desc = "Open parent directory" },
  },
}
