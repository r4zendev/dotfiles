return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "f-person/git-blame.nvim",
      -- Currently using custom UI implementation, but the lualine implementation is also viable
      -- {
      --   dir = vim.fn.stdpath("config") .. "/lua/r4zen/plugins/lualine_extras/lualine_harpoon",
      --   dependencies = {
      --     "ThePrimeagen/harpoon",
      --   },
      -- },
    },
    config = function()
      local git_blame = require("gitblame")
      vim.g.gitblame_display_virtual_text = 0
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
        sections = {
          -- lualine_c = { "lualine_harpoon" },
          -- lualine_c = { "filename" },
          lualine_c = {
            "filename",
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          },
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
