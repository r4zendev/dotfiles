return {
  -- "folke/lazydev.nvim",
  -- TODO: Fixes nightly warning locally until it's fixed upstream
  dir = vim.fn.stdpath("data") .. "/lazy/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "mini.nvim", words = { "Mini" } },
      { path = "wezterm-types", mods = { "wezterm" } },
    },
  },
}
