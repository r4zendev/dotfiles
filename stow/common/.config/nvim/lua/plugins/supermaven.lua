return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  cmd = {
    "SupermavenStart",
    "SupermavenStop",
    "SupermavenRestart",
    "SupermavenToggle",
    "SupermavenStatus",
    "SupermavenUseFree",
    "SupermavenUsePro",
    "SupermavenLogout",
    "SupermavenShowLog",
    "SupermavenClearLog",
  },
  opts = {
    keymaps = {
      accept_suggestion = "<Tab>",
      clear_suggestion = "<C-]>",
      accept_word = "<C-l>",
    },
    condition = function()
      return not vim.g.supermaven_enabled
    end,
  },
  init = function()
    vim.g.supermaven_enabled = true
  end,
}
