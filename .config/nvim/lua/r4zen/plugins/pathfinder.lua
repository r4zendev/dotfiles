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
      "gx",
      function()
        require("pathfinder").gx()
      end,
      desc = "Open next URL",
    },
    {
      "<leader>cp",
      function()
        require("pathfinder").select_file()
      end,
      desc = "Select file to goto",
    },
    {
      "<leader>gx",
      function()
        require("pathfinder").select_url()
      end,
      desc = "Select URL to open",
    },
  },
}
