return {
  {
    "augmentcode/augment.vim",
    cmd = "Augment",
    event = "InsertEnter",
    keys = {
      { "<leader>Ac", "<cmd>Augment chat<cr>", desc = "Augment: Ask", mode = { "n", "v" } },
      { "<leader>An", "<cmd>Augment chat-new<cr>", desc = "Augment: New Chat" },
      { "<leader>At", "<cmd>Augment chat-toggle<cr>", desc = "Augment: Toggle Chat" },
    },
    config = function()
      -- Add cwd to workspace for better Augment suggestions
      vim.g.augment_workspace_folders = { vim.fn.getcwd() }

      -- Disable completion in favor of copilot, but keep the chat available
      -- vim.g.augment_disable_completions = true
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- Figure out how to use this properly
      -- workspace_folders = { vim.fn.getcwd() },
      copilot_model = "gpt-4o-copilot", -- gpt-35-turbo | gpt-4o-copilot

      panel = {
        enabled = true,
        auto_refresh = true,
      },

      suggestion = {
        -- Trying out AugmentCode, keeping the copilot panel for now
        -- Copilot is also used in codecompanion for access to its chat models
        enabled = false,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          accept_line = "<C-l>",
          accept_word = "<C-w>",
          prev = "[[",
          next = "]]",
        },
      },
    },
    keys = {
      { "<leader>Ap", "<cmd>Copilot panel<cr>", desc = "Copilot panel" },
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      -- "fang2hou/blink-copilot",
      "rafamadriz/friendly-snippets",
      "echasnovski/mini.nvim",
      {
        "xzbdmw/colorful-menu.nvim",
        opts = {
          ls = {
            ts_ls = {
              extra_info_hl = "@comment.hint",
            },
          },
        },
      },
    },
    opts = {
      keymap = {
        preset = "none",
        ["<C-f>"] = { "accept", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

        -- ["<M-space>"] = {
        --   function(cmp)
        --     cmp.show({ providers = { "minuet" } })
        --   end,
        -- },
      },
      cmdline = {
        keymap = {
          preset = "none",
          ["<C-f>"] = { "accept", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        },
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
      completion = {
        -- Whether to show brackets in completion
        -- accept = { auto_brackets = { enabled = true } },
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

        -- copilot.vim as a source
        --
        -- default = { "copilot", "lsp", "path", "buffer" },
        -- providers = {
        --   copilot = {
        --     name = "copilot",
        --     module = "blink-copilot",
        --     score_offset = 100,
        --     async = true,
        --   },
        -- },

        -- minuet.nvim as a source
        --
        -- default = { "minuet", "lsp", "path", "buffer" },
        -- providers = {
        --   minuet = {
        --     name = "minuet",
        --     module = "minuet.blink",
        --     score_offset = 100,
        --   },
        -- },
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
