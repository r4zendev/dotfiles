local transparent_background_hl_string = [[
  vim.api.nvim_set_hl(0, "NonText", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
]]

local default_harpoon_hl_string = [[
  vim.api.nvim_set_hl(0, "HarpoonOptionHL", { fg = "#89DDFF" })
  vim.api.nvim_set_hl(0, "HarpoonSelectedOptionHL", { fg = "#5DE4C7" })
]]

local transparent_winbar_hl_string = [[
  vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
]]

local transparent_float_hl_string = [[
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })
]]

return {
  "zaldih/themery.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    themes = {
      -- Main
      {
        name = "Tokyo Night",
        colorscheme = "tokyonight",
        after = transparent_winbar_hl_string .. transparent_float_hl_string,
      },

      -- Alts
      { name = "Rose Pine", colorscheme = "rose-pine", after = transparent_winbar_hl_string },
      { name = "Kanagawa Wave", colorscheme = "kanagawa-wave", after = transparent_background_hl_string },
      { name = "Catppuccin", colorscheme = "catppuccin-mocha" },

      -- Some extra good ones
      { name = "Nightfly", colorscheme = "nightfly" },
      { name = "Default", colorscheme = "default", after = default_harpoon_hl_string },
    },
    livePreview = true,
  },
  keys = {
    { "<leader>uc", vim.cmd.Themery, desc = "Colorscheme (persist)" },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "themery",
      callback = function(event)
        vim.b[event.buf].miniindentscope_disable = true
      end,
    })
  end,
}
