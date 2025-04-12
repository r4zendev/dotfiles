return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  opts = {
    keys = {
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>xq", function() require("quicker").toggle() end, desc = "Quicker: Toggle quickfix" },
    { "<leader>xl", function() require("quicker").toggle({ loclist = true }) end, desc = "Quicker: Toggle loclist" },
  },
}
