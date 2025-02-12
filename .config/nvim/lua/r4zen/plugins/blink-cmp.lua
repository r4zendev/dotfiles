return {
  "saghen/blink.cmp",
  lazy = true,
  dependencies = {
    "rafamadriz/friendly-snippets",
    "echasnovski/mini.nvim",
  },
  version = "*",
  opts = {
    keymap = {
      preset = "enter",

      ["<C-n>"] = {},
      ["<C-p>"] = {},
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },

      cmdline = {
        preset = "default",

        ["<C-n>"] = {},
        ["<C-p>"] = {},
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
    },
    completion = {
      menu = {
        draw = {
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              -- Optionally, you may also use the highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
      -- kind_icons = {
      --   Text = "󰉿",
      --   Method = "󰊕",
      --   Function = "󰊕",
      --   Constructor = "󰒓",
      --
      --   Field = "󰜢",
      --   Variable = "󰆦",
      --   Property = "󰖷",
      --
      --   Class = "󱡠",
      --   Interface = "󱡠",
      --   Struct = "󱡠",
      --   Module = "󰅩",
      --
      --   Unit = "󰪚",
      --   Value = "󰦨",
      --   Enum = "󰦨",
      --   EnumMember = "󰦨",
      --
      --   Keyword = "󰻾",
      --   Constant = "󰏿",
      --
      --   Snippet = "󱄽",
      --   Color = "󰏘",
      --   File = "󰈔",
      --   Reference = "󰬲",
      --   Folder = "󰉋",
      --   Event = "󱐋",
      --   Operator = "󰪚",
      --   TypeParameter = "󰬛",
      -- },
    },
    signature = {
      enabled = true,
      trigger = {
        -- Show the signature help automatically
        enabled = true,
        -- Show the signature help window after typing any of alphanumerics, `-` or `_`
        show_on_keyword = false,
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        -- Show the signature help window after typing a trigger character
        show_on_trigger_character = true,
        -- Show the signature help window when entering insert mode
        show_on_insert = true,
        -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,
      },
      window = {
        min_width = 1,
        max_width = 100,
        max_height = 10,
        border = "padded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
        scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
        -- Which directions to show the window,
        -- falling back to the next direction when there's not enough space,
        -- or another window is in the way
        direction_priority = { "n", "s" },
        -- Disable if you run into performance issues
        treesitter_highlighting = true,
        show_documentation = true,
      },
    },
  },
}
