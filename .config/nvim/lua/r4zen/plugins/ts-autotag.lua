return {
  "windwp/nvim-ts-autotag",
  version = "*",
  ft = { "html", "typescript", "typescriptreact", "javascript", "javascriptreact" },
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
}
