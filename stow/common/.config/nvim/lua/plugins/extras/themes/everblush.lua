-- {
--   name = "Everblush",
--   colorscheme = "everblush",
--   after = function()
--     transparent_winbar()
--
--     local palette = require("everblush.palette")
--     local comment_color = "#6c7086"
--     vim.api.nvim_set_hl(0, "@comment", { fg = comment_color })
--     vim.api.nvim_set_hl(0, "Comment", { fg = comment_color })
--     vim.api.nvim_set_hl(0, "LineNr", { fg = comment_color })
--     vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.color4, bold = true })
--     vim.api.nvim_set_hl(
--       0,
--       "SnacksPickerListCursorLine",
--       { bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg, fg = "NONE" }
--     )
--   end,
-- },

return {
  "Everblush/nvim",
  name = "everblush",
  opts = {
    transparent_background = true,
    override = {
      -- Normal = { fg = "#ffffff", bg = "comment" }, <-- can use theme's color names
    },
  },
}

-- color0 = '#232a2d',
-- color1 = '#e57474',
-- color2 = '#8ccf7e',
-- color3 = '#e5c76b',
-- color4 = '#67b0e8',
-- color5 = '#c47fd5',
-- color6 = '#6cbfbf',
-- color7 = '#b3b9b8',
-- color8 = '#2d3437',
-- color9 = '#ef7e7e',
-- color10 = '#96d988',
-- color11 = '#f4d67a',
-- color12 = '#71baf2',
-- color13 = '#ce89df',
-- color14 = '#67cbe7',
-- color15 = '#bdc3c2',
-- comment = '#404749',
-- contrast = '#161d1f',
-- background = '#141b1e',
-- foreground = '#dadada',
-- cursorline = '#2c3333',
-- none = 'NONE',
