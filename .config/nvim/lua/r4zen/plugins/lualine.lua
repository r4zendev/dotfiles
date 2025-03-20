local utils = require("r4zen.utils")

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "f-person/git-blame.nvim",
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

        local harpoon = require("harpoon")
        local current_file_path = vim.api.nvim_buf_get_name(0)
        local root_dir = harpoon:list().config:get_root_dir()
        local harpoon_items = harpoon:list().items

        local found = false
        for i = 1, #harpoon_items do
          local harpoon_item = harpoon_items[i]

          if not harpoon_item then
            break
          end

          local path = harpoon_item.value

          if utils.is_relative_path(path) then
            path = utils.get_full_path(root_dir, path)
          end

          if path == current_file_path then
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
        options = {
          theme = "tokyonight",
        },
        sections = {
          lualine_c = {
            harpoon_aware_fname,
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          },
          lualine_x = {
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
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
