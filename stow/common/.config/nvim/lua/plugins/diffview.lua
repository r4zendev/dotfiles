-- More capable alternative to lightweight vscode-diff.nvim (which is enough for me)
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
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
        if require("diffview.lib").get_current_view() then
          vim.cmd.DiffviewClose()
        else
          vim.cmd.DiffviewOpen()
        end
      end,
      noremap = true,
      silent = true,
      desc = "Toggle DiffView",
    },
  },
}
