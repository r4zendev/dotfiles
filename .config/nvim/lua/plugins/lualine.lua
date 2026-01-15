return {
  "nvim-lualine/lualine.nvim",
  event = "LazyFile",
  dependencies = {
    "echasnovski/mini.nvim",
  },
  config = function()
    local git_blame = require("gitblame")

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
          {
            "filename",
            cond = function()
              return not vim.api.nvim_buf_get_name(0):match("^oil://")
            end,
          },
          {
            function()
              local original_text = git_blame.get_current_blame_text()
              local separator = "•"
              local split_text = vim.split(original_text, separator)
              return (#split_text >= 2)
                  and (table.concat({ split_text[1], split_text[2] }, separator))
                or original_text
            end,
            cond = function()
              return git_blame.is_blame_text_available()
                and not vim.api.nvim_buf_get_name(0):match("^oil://")
            end,
          },
        },
        lualine_x = (function()
          local components = {
            { "overseer" },
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          }

          local ok, noice = pcall(require, "noice")
          if ok then
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
  end,
}
