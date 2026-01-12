return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  opts = {
    options = {
      use_icons_from_diagnostic = false,
      set_arrow_to_diag_color = true,
      add_messages = {
        messages = true,
        display_count = true,
        use_max_severity = true,
        show_multiple_glyphs = true,
      },
      show_diags_only_under_cursor = true,
      multilines = {
        enabled = true,
      },
      virt_texts = {
        priority = 9999,
      },
      override_open_float = true,
    },
  },
  init = function()
    vim.diagnostic.config({ virtual_text = false })
  end,
}
