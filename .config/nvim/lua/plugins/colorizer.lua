return {
  "catgoose/nvim-colorizer.lua",
  event = "VeryLazy",
  opts = {
    filetypes = { "*", "!oil", "!snacks_picker_input" },
    buftypes = {},
    lazy_load = true,
    user_default_options = {
      -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn, oklch_fn
      css = true,
      -- rgb_fn, hsl_fn, oklch_fn
      css_fn = true,
      -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
      tailwind = "both",
      tailwind_opts = {
        update_names = true,
      },
    },
  },
}
