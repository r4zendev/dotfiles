return {
  {
    "echasnovski/mini.icons",
    version = "*",
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.ai").setup()
      require("mini.pairs").setup()
      require("mini.surround").setup()
      require("mini.move").setup()

      -- A bit later
      -- require("mini.hipatterns").setup()
      -- require("mini.operators").setup()

      require("mini.files").setup()
      vim.keymap.set("n", "=", "<cmd>lua MiniFiles.open()<cr>", { desc = "Open mini.files" })

      -- require("mini.diff").setup()
      -- require("mini.align").setup()
    end,
  },
}
