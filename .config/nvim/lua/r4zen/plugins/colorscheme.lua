-- Poimanres theme palette
-- https://github.com/olivercederborg/poimandres.nvim/blob/main/lua/poimandres/palette.lua

-- yellow         = '#FFFAC2',
-- teal1          = '#5DE4C7',
-- teal2          = '#5FB3A1',
-- teal3          = '#42675A',
-- blue1          = '#89DDFF',
-- blue2          = '#ADD7FF',
-- blue3          = '#91B4D5',
-- blue4          = '#7390AA',
-- pink1          = '#FAE4FC',
-- pink2          = '#FCC5E9',
-- pink3          = '#D0679D',
-- blueGray1      = '#A6ACCD',
-- blueGray2      = '#767C9D',
-- blueGray3      = '#506477',
-- background1    = '#303340',
-- background2    = '#1B1E28',
-- background3    = '#171922',
-- text           = '#E4F0FB',
-- white          = '#FFFFFF',
-- none           = 'NONE',
-- darkGray       = '#A9A9A9',
-- steelBlue      = '#4682B4',
-- lightSteelBlue = '#B0C4DE',
-- slatePurple    = '#6A5ACD',

return {
  -- {
  --   "bluz71/vim-nightfly-guicolors",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme nightfly]])
  --   end,
  -- },
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      require("tokyonight").setup({
        transparent = true,
        style = "night",
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
      })

      -- Load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])

      vim.highlight.priorities.semantic_tokens = 95

      local comments = "#4682B4"
      vim.api.nvim_set_hl(0, "Comment", { fg = comments })

      local bg_diagnostic_unnecessary = "#011423"
      local fg_diagnostic_unnecessary = "#627E97"
      vim.api.nvim_set_hl(
        0,
        "DiagnosticUnnecessary",
        { fg = fg_diagnostic_unnecessary, bg = bg_diagnostic_unnecessary }
      )

      local cursor_word_hl = "#506477"
      vim.api.nvim_set_hl(0, "MiniCursorword", { bg = cursor_word_hl })
      vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = cursor_word_hl })

      -- local panel_hl = "#7390AA"
      local selected_hl = "#5DE4C7"
      local option_hl = "#89DDFF"
      -- vim.api.nvim_set_hl(0, "HarpoonFilesPanelHL", { bg = panel_hl })
      vim.api.nvim_set_hl(0, "HarpoonSelectedOptionHL", { fg = selected_hl })
      vim.api.nvim_set_hl(0, "HarpoonOptionHL", { fg = option_hl })

      -- Added buffer lines are highlighted with MiniDiffOverAdd highlight group.
      -- MiniDiffOverAdd

      -- Deleted reference lines are shown as virtual text and highlighted with MiniDiffOverDelete highlight group.
      -- MiniDiffOverDelete

      -- Changed reference lines are shown as virtual text and highlighted with MiniDiffOverChange highlight group.
      -- MiniDiffOverChange

      -- "Change" hunks with equal number of buffer and reference lines have special treatment and show "word diff". Reference line is shown next to its buffer counterpart and only changed parts of both lines are highlighted with MiniDiffOverChange. The rest of reference line has MiniDiffOverContext highlighting.
      -- MiniDiffOverChange
      -- rest of the line: MiniDiffOverContext

      local diff_over_change_colors = { fg = "#E4F0FB", bg = "#5FB3A1" }
      vim.api.nvim_set_hl(0, "MiniDiffOverChange", diff_over_change_colors)
    end,
  },
}
