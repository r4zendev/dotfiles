return {
  "bluz71/vim-nightfly-guicolors",
  config = function()
    vim.g.nightflyTransparent = true

    local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "nightfly",
      callback = function()
        local colors = require("nightfly").palette

        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })

        -- set color for virtual text
        vim.api.nvim_set_hl(0, "AugmentSuggestionHighlight", { fg = colors.pickle_blue })

        -- Custom highlight groups
        vim.api.nvim_set_hl(
          0,
          "DiagnosticUnnecessary",
          { fg = colors.grey_blue, bg = colors.dark_blue, underline = true }
        )

        vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = colors.white })
        vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = colors.purple })

        vim.api.nvim_set_hl(0, "HarpoonOptionHL", { fg = colors.white })
        vim.api.nvim_set_hl(0, "HarpoonSelectedOptionHL", { fg = colors.green })

        vim.api.nvim_set_hl(0, "CodeCompanionChatTool", { fg = colors.turquoise })
        vim.api.nvim_set_hl(0, "CodeCompanionChatVariable", { fg = colors.turquoise })

        vim.api.nvim_set_hl(0, "MiniCursorword", { bg = colors.plant, underline = false })
        vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = colors.plant, underline = false })

        vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { fg = colors.dark_blue, bg = colors.green })
        vim.api.nvim_set_hl(0, "MiniDiffOverChange", { fg = colors.dark_blue, bg = colors.yellow })
        vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { fg = colors.dark_blue, bg = colors.red })

        vim.api.nvim_set_hl(0, "LineNr", { fg = colors.grey_blue })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.blue })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.black_blue })
      end,
      group = custom_highlight,
    })
  end,
}

-- Palette
--
-- local none = "NONE"
-- -- Background and foreground
-- local black = "#011627"
-- local white = "#c3ccdc"
-- local bg = black
-- if g.nightflyTransparent then
--   bg = none
-- end
-- -- Variations of midnight-blue
-- local black_blue = "#081e2f"
-- local dark_blue = "#092236"
-- local deep_blue = "#0e293f"
-- local slate_blue = "#2c3043"
-- local pickle_blue = "#38507a"
-- local cello_blue = "#1f4462"
-- local regal_blue = "#1d3b53"
-- local steel_blue = "#4b6479"
-- local grey_blue = "#7c8f8f"
-- local graphite_blue = "#768799"
-- local cadet_blue = "#a1aab8"
-- local ash_blue = "#acb4c2"
-- local white_blue = "#d6deeb"
-- -- Core theme colors
-- local red = "#fc514e"
-- local watermelon = "#ff5874"
-- local cinnamon = "#ed9389"
-- local orchid = "#e39aa6"
-- local orange = "#f78c6c"
-- local peach = "#ffcb8b"
-- local tan = "#ecc48d"
-- local yellow = "#e3d18a"
-- local lime = "#85dc85"
-- local green = "#a1cd5e"
-- local emerald = "#21c7a8"
-- local turquoise = "#7fdbca"
-- local malibu = "#87bcff"
-- local blue = "#82aaff"
-- local lavender = "#b0b2f4"
-- local violet = "#c792ea"
-- local purple = "#ae81ff"
-- -- Extra colors
-- local cyan_blue = "#316394"
-- local bay_blue = "#24567f"
-- local kashmir = "#4d618e"
-- local plant = "#2a4e57"
-- local bermuda = "#6e8da6"
