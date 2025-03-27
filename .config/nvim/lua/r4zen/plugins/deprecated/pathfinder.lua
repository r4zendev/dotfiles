return {
  "HawkinsT/pathfinder.nvim",
  opts = { remap_default_keys = false },
  keys = {
    { "gf", "<cmd>lua require('pathfinder').gf()<CR>" },
    { "gF", "<cmd>lua require('pathfinder').gF()<CR>" },
    { "<leader>cp", "<cmd>lua require('pathfinder').select_file()<CR>", desc = "Pathfinder: Select file" },
  },
}
