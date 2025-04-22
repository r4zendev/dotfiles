return {
  "ziontee113/icon-picker.nvim",
  cmd = {
    "IconPickerNormal",
    "IconPickerYank",
    "IconPickerInsert",
  },
  opts = {
    disable_legacy_commands = true,
  },
  keys = {
    { "<leader>ip", vim.cmd.IconPickerNormal, desc = "Icon Picker" },
    { "<leader>iy", vim.cmd.IconPickerYank, desc = "Icon Picker Yank" },
    { "<C-h>", vim.cmd.IconPickerInsert, mode = "i", desc = "Icon Picker Insert" },
  },
}
