return {
  {
    "folke/ts-comments.nvim",
    version = "*",
    ft = { "html", "javascript", "typescript", "jsx", "tsx" },
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    version = "*",
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
