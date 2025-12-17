return {
  "catgoose/nvim-colorizer.lua",
  event = "VeryLazy",
  opts = {
    filetypes = { "*" },
    buftypes = {},
    lazy_load = true,
    user_default_options = {
      css = true,
      -- rgb_fn, hsl_fn, oklch_fn
      css_fn = true,
      -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
      tailwind = "both",
      tailwind_opts = {
        update_names = true,
      },

      -- Expects a table of color name to #RRGGBB value pairs.  # is optional
      -- Example: { cool = "#107dac", ["notcool"] = "ee9240" }
      -- Set to false to disable, for example when setting filetype options
      -- names_custom = false, -- Custom names to be highlighted: table|function|false
      -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn, oklch_fn
      -- sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
      -- xterm = false, -- Enable xterm 256-color codes (#xNN, \e[38;5;NNNm)
      -- -- Highlighting mode.  'background'|'foreground'|'virtualtext'
      -- mode = "background",
    },
  },
}
