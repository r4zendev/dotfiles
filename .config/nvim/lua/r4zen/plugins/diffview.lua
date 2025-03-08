return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  opts = {
    file_panel = {
      win_config = {
        position = "bottom",
        height = 10,
      },
    },
  },
  keys = {
    {
      "<leader>gd",
      function()
        local lib = require("diffview.lib")
        local view = lib.get_current_view()
        if view then
          -- Current tabpage is a Diffview; close it
          vim.cmd.DiffviewClose()
        else
          -- No open Diffview exists: open a new one
          vim.cmd.DiffviewOpen()
        end
      end,
      noremap = true,
      silent = true,
      desc = "Toggle DiffView",
    },
  },
}
