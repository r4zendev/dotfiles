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

local ts_context_hl_string = [[
  vim.api.nvim_set_hl(0, "TreesitterContext", { bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg })
  vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = false })
]]

local custom_blink_cmp_hl_string = [[
  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1e1e2e", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#1e1e2e", fg = "#89b4fa" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#45475a", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { fg = "#6c7086", strikethrough = true })
  vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#89b4fa", bold = true })
  vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = "#cba6f7" })
  vim.api.nvim_set_hl(0, "BlinkCmpSource", { fg = "#6c7086" })
  vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#6c7086" })

  -- You can also set kind-specific highlights like:
  vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = "#89b4fa" })
  vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = "#f5c2e7" })
  vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = "#f38ba8" })
  vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = "#a6e3a1" })
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
          .. default_harpoon_hl_string
          .. ts_context_hl_string
          .. [[
                vim.api.nvim_set_hl(0, "Comment", { fg = "#737aa2" })
                vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#627E97", bg = "#011423" })
                vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#666666" })
                vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#3DDBD9" })
                vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "#191919" })
                vim.api.nvim_set_hl(0, "Visual", { bg = "#191919" })
             ]],
      },

      -- Alts that are nice to the eye
      {
        name = "Catppuccin",
        colorscheme = "catppuccin-mocha",
        after = transparent_float_hl_string .. ts_context_hl_string,
      },
      {
        name = "Rose Pine",
        colorscheme = "rose-pine",
        after = transparent_winbar_hl_string .. ts_context_hl_string,
      },
      {
        name = "Kanagawa Wave",
        colorscheme = "kanagawa-wave",
        after = transparent_background_hl_string,
      },

      -- Darker themes for late nights
      { name = "Vague", colorscheme = "vague", after = transparent_winbar_hl_string },
      {
        name = "Oxocarbon Dark",
        colorscheme = "oxocarbon",
        after = minicursorword_hl_string .. ts_context_hl_string .. custom_blink_cmp_hl_string,
      },
      { name = "Nightfly", colorscheme = "nightfly", after = ts_context_hl_string },
      { name = "Kanso Zen", colorscheme = "kanso-zen" },
      {
        name = "Default",
        colorscheme = "default",
        after = default_harpoon_hl_string .. minicursorword_hl_string .. ts_context_hl_string,
      },
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
