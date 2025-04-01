return {
  "zaldih/themery.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    themes = {
      "catppuccin",
      "kanagawa",
      "tokyonight",
      "default",
      "nightfly",
    },
    livePreview = true,
    -- Transparency
    globalBefore = [[ 
      vim.api.nvim_command("autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE")
      vim.api.nvim_command("autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE")
      vim.api.nvim_command("autocmd ColorScheme * highlight LineNr guibg=NONE ctermbg=NONE")
      vim.api.nvim_command("autocmd ColorScheme * highlight SignColumn guibg=NONE ctermbg=NONE")
      vim.api.nvim_command("autocmd ColorScheme * highlight EndOfBuffer guibg=NONE ctermbg=NONE")
    ]],
    -- Transparent floats & default notify background
    globalAfter = [[ 
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })
    ]],
  },
  keys = {
    { "<leader>uc", "<cmd>Themery<cr>", desc = "Colorscheme (persist)" },
  },
  config = function(_, opts)
    require("themery").setup(opts)

    -- Use these by default for themes where they are not set
    vim.api.nvim_set_hl(0, "HarpoonSelectedOptionHL", { fg = "#5DE4C7" })
    vim.api.nvim_set_hl(0, "HarpoonOptionHL", { fg = "#89DDFF" })
  end,
}
