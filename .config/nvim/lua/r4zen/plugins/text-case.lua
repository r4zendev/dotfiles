return {
  "johmsalas/text-case.nvim",
  -- To make the interactive feature of the `Subs` available before the first
  -- executing of it or before a keymap of text-case.nvim has been used, needs to be set to false.
  lazy = false,
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    prefix = "<leader>C",
  },
  keys = { "<leader>C" },
  cmd = {
    -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
    "Subs",
    "TextCaseOpenTelescope",
    "TextCaseOpenTelescopeQuickChange",
    "TextCaseOpenTelescopeLSPChange",
    "TextCaseStartReplacingCommand",
  },
}
