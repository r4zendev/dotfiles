return {
  {
    "xzbdmw/colorful-menu.nvim",
    config = function()
      require("colorful-menu").setup({
        ls = {
          ts_ls = {
            extra_info_hl = "@comment.hint",
          },
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "xzbdmw/colorful-menu.nvim",
      "echasnovski/mini.nvim",
    },
    version = "*",
    opts = {
      keymap = {
        preset = "none",
        ["<C-f>"] = { "accept", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

        cmdline = {
          preset = "none",
          ["<C-f>"] = { "accept", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        },
      },
      completion = {
        trigger = {
          show_on_trigger_character = true,
        },
        documentation = {
          auto_show = true,
        },
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,

                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      signature = {
        enabled = true,
        trigger = {
          enabled = true,
        },
      },
    },
  },
}
