return {
  {
    "nvim-lualine/lualine.nvim",
    event = "LazyFile",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.nvim",
      -- Currently using custom UI implementation, but the lualine one is also viable
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

      -- Harpooned files special icon extension
      local harpoon_aware_fname = require("lualine.components.filename"):extend()

      function harpoon_aware_fname:init(options)
        harpoon_aware_fname.super.init(self, options)
      end

      function harpoon_aware_fname:update_status()
        local data = harpoon_aware_fname.super.update_status(self)

        local current_file_path = vim.api.nvim_buf_get_name(0)
        local harpoon_items = require("harpoon"):list().items

        local found = false
        for i = 1, #harpoon_items do
          local harpoon_item = harpoon_items[i]
          local path = harpoon_item.value

          if vim.uv.fs_realpath(path) == vim.uv.fs_realpath(current_file_path) then
            found = true
            break
          end
        end

        if found then
          return " " .. data
        end

        return data
      end

      require("lualine").setup({
        sections = {
          lualine_c = {
            {
              harpoon_aware_fname,
              cond = function()
                return not vim.api.nvim_buf_get_name(0):match("^oil://")
              end,
            },
            {
              git_blame.get_current_blame_text,
              cond = function()
                return git_blame.is_blame_text_available() and not vim.api.nvim_buf_get_name(0):match("^oil://")
              end,
            },
          },
          lualine_x = {
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
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
