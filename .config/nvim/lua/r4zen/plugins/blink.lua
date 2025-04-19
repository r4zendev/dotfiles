return {
  -- Beneficial for plugins that want nvim-cmp, like obsidian.nvim
  {
    "saghen/blink.compat",
    version = "*",
    opts = {
      impersonate_nvim_cmp = true,
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      -- "fang2hou/blink-copilot",
      "rafamadriz/friendly-snippets",
      {
        "xzbdmw/colorful-menu.nvim",
        opts = {
          ls = {
            ts_ls = {
              -- false means do not include any extra info,
              -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
              extra_info_hl = "HarpoonSelectedOptionHL",
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
            columns = { { "kind_icon", "label", "label_description", gap = 1 } },
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
              label_description = {
                width = { min = 20, max = 50 },

                highlight = function(ctx)
                  return ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel"
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
          obsidian = {
            name = "obsidian",
            module = "blink.compat.source",
            score_offset = 100,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
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
        -- trigger = {
        --   enabled = true,
        -- },
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
