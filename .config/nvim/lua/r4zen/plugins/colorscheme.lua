return {
  "catppuccin/nvim",
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = true,
    no_italic = true,
    integrations = {
      noice = true,
      notify = true,
      mason = true,
      which_key = true,
      mini = {
        enabled = true,
        indentscope_color = "sky",
      },
    },
    color_overrides = {
      mocha = {},
    },
    custom_highlights = function(colors)
      return {
        -- Comment = { fg = colors.sky },
        DiagnosticUnnecessary = { fg = colors.surface2, bg = colors.crust, underline = true },

        HarpoonOptionHL = { fg = colors.text },
        HarpoonSelectedOptionHL = { fg = colors.green },

        -- MiniCursorword = { bg = colors.surface2, underline = false },
        -- MiniCursorwordCurrent = { bg = colors.surface2, underline = false },

        MiniDiffOverAdd = { fg = colors.text, bg = colors.green },
        MiniDiffOverChange = { fg = colors.text, bg = colors.yellow },
        MiniDiffOverDelete = { fg = colors.text, bg = colors.red },

        LineNr = { fg = colors.surface2 },
        CursorLineNr = { fg = colors.blue },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd([[colorscheme catppuccin]])
    vim.hl.priorities.semantic_tokens = 95

    -- for some reason if declaring this in custom_highlights it does not remove underline
    vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#585b70", underline = false })
    vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#585b70", underline = false })
  end,
}
