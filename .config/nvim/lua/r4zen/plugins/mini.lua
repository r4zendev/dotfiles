local utils = require("r4zen.utils")

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
      require("mini.animate").setup({
        scroll = {
          enable = false,
        },
      })

      utils.remap("n", "gx", "<leader>ox")
      utils.remap("x", "gx", "<leader>ox")
      require("mini.operators").setup()

      require("mini.move").setup({
        mappings = {
          left = "H",
          down = "J",
          up = "K",
          right = "L",
        },
      })

      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })

      require("mini.files").setup()
      vim.keymap.set("n", "=", "<cmd>lua MiniFiles.open()<cr>", { desc = "Open mini.files" })

      -- require("mini.diff").setup()
      -- require("mini.align").setup()
    end,
  },
}
