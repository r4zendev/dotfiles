return {
  "kristijanhusak/vim-dadbod-ui",
  enabled = false,
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  keys = {
    { "<leader>du", vim.cmd.DBUIToggle, desc = "Toggle DBUI" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
