return {
  {
    "nvim-lualine/lualine.nvim",
    -- Currently using custom UI implementation, but the lualine implementation is also viable
    -- dependencies = {
    --   "nvim-tree/nvim-web-devicons",
    --   {
    --     dir = vim.fn.stdpath("config") .. "/lua/r4zen/plugins/lualine_extras/lualine_harpoon",
    --     dependencies = {
    --       "ThePrimeagen/harpoon",
    --     },
    --   },
    -- },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
        sections = {
          -- lualine_c = { "lualine_harpoon" },
          lualine_c = { "filename" },
          lualine_x = {
            {

              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              -- lazy_status.updates,
              -- cond = lazy_status.has_updates,
              color = { fg = "#ff9e64" },
            },
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          },
        },
      })
    end,
  },
}
