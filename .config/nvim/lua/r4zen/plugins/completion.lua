return {
  {
    "augmentcode/augment.vim",
    cmd = "Augment",
    event = { "BufReadPre", "BufNewFile" },
    -- Cannot be called on InsertEnter, since plugin would not be loaded at that point.
    -- It initializes and authenticates and only then starts to provide suggestions.
    -- Hopefully will be fixed eventually, as this works as expected in copilot.
    -- event = "InsertEnter",
    keys = {
      { "<leader>Ac", "<cmd>Augment chat<cr>", desc = "Augment: Ask", mode = { "n", "v" } },
      { "<leader>An", "<cmd>Augment chat-new<cr>", desc = "Augment: New Chat" },
      { "<leader>At", "<cmd>Augment chat-toggle<cr>", desc = "Augment: Toggle Chat" },
    },
    init = function()
      -- Add workspaces for better suggestions
      vim.g.augment_workspace_folders = { require("r4zen.utils").workspace_root() }

      -- Disable completion in favor of copilot, but keep the chat available
      -- vim.g.augment_disable_completions = true
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- workspace_folders = { require("r4zen.utils").workspace_root() },
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
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    opts = {
      map_cr = false,
      check_ts = true, -- treesitter
      ts_config = {
        lua = { "string" }, -- avoid pairs in lua strings
        javascript = { "template_string" }, -- don't add pairs in js template_strings
      },
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
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },

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
    init = function()
      -- Overriding vim.lsp.get_clients to filter out Augment Server for completion requests
      local original_get_clients = vim.lsp.get_clients

      --- @diagnostic disable-next-line: duplicate-set-field
      vim.lsp.get_clients = function(opts)
        local clients = original_get_clients(opts)

        if opts and opts.method == "textDocument/completion" then
          return vim.tbl_filter(function(client)
            return client.name ~= "Augment Server"
          end, clients)
        end

        return clients
      end
    end,
  },
}
