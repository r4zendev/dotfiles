return {
  "nvim-lualine/lualine.nvim",
  event = "LazyFile",
  dependencies = {
    "nvim-mini/mini.nvim",
  },
  config = function()
    local function get_theme()
      package.loaded["lualine.themes.auto"] = nil
      local theme = require("lualine.themes.auto")
      theme.normal.c.bg = "None"
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
      return theme
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        require("lualine").setup({ options = { theme = get_theme() } })
      end,
    })

    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
      callback = function()
        require("lualine").refresh()
      end,
    })

    require("lualine").setup({
      options = {
        theme = get_theme(),
      },
      sections = {
        lualine_c = {
          -- {
          --   "filename",
          --   -- 0: fname; 1: relpath; 2: abspath; 3: abspath (~); 4: fname + parent (~);
          --   path = 1,
          --   cond = function()
          --     return not vim.api.nvim_buf_get_name(0):match("^oil://")
          --   end,
          -- },
        },
        lualine_x = (function()
          local components = {
            { "overseer" },
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          }

          local nova_ok, nova = pcall(require, "nova")
          if nova_ok then
            table.insert(components, 1, nova.status.lualine())
          end

          local noice_ok, noice = pcall(require, "noice")
          if noice_ok then
            table.insert(components, 1, {
              noice.api.status.mode.get,
              cond = noice.api.status.mode.has,
              color = { fg = "#ff6b6b" },
            })
          else
            table.insert(components, 1, {
              function()
                return "recording @" .. vim.fn.reg_recording()
              end,
              cond = function()
                return vim.fn.reg_recording() ~= ""
              end,
              color = { fg = "#ff6b6b" },
            })
          end

          return components
        end)(),
      },
    })

    if vim.env.TMUX then
      vim.api.nvim_create_autocmd({ "FocusGained", "ColorScheme" }, {
        callback = function()
          vim.defer_fn(function()
            vim.opt.laststatus = 0
          end, 0)
        end,
      })

      vim.o.laststatus = 0
    end
  end,
}
