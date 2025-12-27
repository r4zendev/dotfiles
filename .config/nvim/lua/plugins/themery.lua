local transparent_background_hl_string = [[
  vim.api.nvim_set_hl(0, "NonText", { bg = "NONE" })
  pcall(vim.api.nvim_set_hl, 0, "StatusColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
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

local minicursorword_hl_string = [[
  vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#506477" })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#506477" })
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
      {
        name = "Oxocarbon",
        colorscheme = "oxocarbon",
        after = transparent_background_hl_string
          .. transparent_winbar_hl_string
          .. transparent_float_hl_string
          .. minicursorword_hl_string
          .. [[
                vim.api.nvim_set_hl(0, "Comment", { fg = "#737aa2" })
                vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#627E97", bg = "#011423" })
             ]],
      },

      -- Alts that are nice to the eye
      { name = "Catppuccin", colorscheme = "catppuccin-mocha", after = transparent_float_hl_string },
      { name = "Rose Pine", colorscheme = "rose-pine", after = transparent_winbar_hl_string },
      { name = "Kanagawa Wave", colorscheme = "kanagawa-wave", after = transparent_background_hl_string },

      -- Darker themes for late nights
      { name = "Vague", colorscheme = "vague", after = transparent_winbar_hl_string },
      { name = "Oxocarbon Dark", colorscheme = "oxocarbon" },
      { name = "Nightfly", colorscheme = "nightfly" },
      { name = "Kanso Zen", colorscheme = "kanso-zen" },
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
