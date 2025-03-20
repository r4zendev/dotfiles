return {
  {
    "augmentcode/augment.vim",
    keys = {
      { "<leader>Ac", "<cmd>Augment chat<cr>", desc = "Augment: Ask", mode = { "n", "v" } },
      { "<leader>An", "<cmd>Augment chat-new<cr>", desc = "Augment: New Chat" },
      { "<leader>At", "<cmd>Augment chat-toggle<cr>", desc = "Augment: Toggle Chat" },
    },
    config = function()
      -- Remove tab binding in favor of copilot
      vim.g.augment_disable_tab_mapping = true
      -- Add cwd to workspace for better Augment suggestions
      vim.g.augment_workspace_folders = { vim.fn.getcwd() }
      -- To make it not attach the LSP and add completion source to blink
      vim.g.augment_job_command = "> /dev/null 2>&1"
      -- Disable completion, but keep the chat
      vim.cmd([[Augment disable]])
    end,
  },
  {
    "github/copilot.vim",
    dependencies = {
      -- Making sure this loads first and unmaps tab,
      -- then copilot will map it back
      "augmentcode/augment.vim",
    },
    lazy = false,
    cmd = "Copilot",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>ap", "<cmd>Copilot<cr>", desc = "Copilot Panel" },
    },
    init = function()
      vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
      vim.g.copilot_no_tab_map = false

      -- Use gpt-4o
      vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
      vim.g.copilot_integration_id = "vscode-chat"
    end,
  },
  {
    "saghen/blink.cmp",
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
    version = "*",
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
