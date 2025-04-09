return {
  "HawkinsT/pathfinder.nvim",
  opts = { remap_default_keys = false },
  keys = {
    {
      "gf",
      function()
        require("pathfinder").gf()
      end,
      desc = "Goto next file entry",
    },
    {
      "gF",
      function()
        require("pathfinder").gF()
      end,
      desc = "Goto file (line)",
    },
    {
      "<leader>cp",
      function()
        require("pathfinder").select_file()
      end,
      desc = "Select file to goto",
    },
  },
}
