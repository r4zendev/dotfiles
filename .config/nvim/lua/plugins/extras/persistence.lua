return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    {
      "<leader>zs",
      function()
        require("persistence").load()
      end,
      desc = "Restore Session",
    },
    {
      "<leader>zS",
      function()
        require("persistence").select()
      end,
      desc = "Select Session",
    },
  },
}
