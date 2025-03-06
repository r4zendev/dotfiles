return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  opts = {
    views = {
      cmdline_popup = {
        position = {
          row = 7,
          col = "55%",
        },
      },
      cmdline_popupmenu = {
        position = {
          row = 7,
          col = "55%",
        },
      },
    },
  },
}
