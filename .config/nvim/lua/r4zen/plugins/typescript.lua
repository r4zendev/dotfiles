return {
  {
    "folke/ts-comments.nvim",
    version = "*",
    after = "nvim-treesitter",
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    version = "*",
    after = "nvim-treesitter",
    ft = { "html", "javascript", "typescript", "jsx", "tsx" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      per_filetype = {
        ["html"] = {
          enable_close = false,
        },
      },
    },
  },
}
