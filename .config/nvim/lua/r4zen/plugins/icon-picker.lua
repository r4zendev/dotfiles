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
    { "<leader>ip", vim.cmd.IconPickerNormal },
    { "<leader>iy", vim.cmd.IconPickerYank },
    { "<C-h>", vim.cmd.IconPickerInsert, mode = "i" },
  },
}
