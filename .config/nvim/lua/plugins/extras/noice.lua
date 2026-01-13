return {
  {
    "rcarriga/nvim-notify",
    enabled = false,
    opts = {
      timeout = 3000,
      max_width = nil,
      max_height = nil,
      -- "fade" | "slide" | "slide_out" | "fade_in_slide_out" | "static",
      stages = "static",
      -- "default" | "minimal" | "simple"
      render = "minimal",
      minimum_width = 30,
      fps = 60,
      top_down = false,
      merge_duplicates = true,
      icons = require("icons").diagnostics,
    },
  },
  {
    "folke/noice.nvim",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    event = { "VeryLazy" },
    opts = {
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "%d+L, %d+B" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", kind = "", find = "change[s]?; before" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", kind = "", find = "change[s]?; after" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", find = "Already at" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", find = "lines yanked" },
          opts = { skip = true },
        },
      },
      cmdline = {
        enabled = true,
        -- view = "cmdline",
      },
      views = {
        cmdline_popup = {
          position = {
            row = "95%",
            col = "50%",
          },
        },
      },
      lsp = {
        enabled = true,
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        -- bottom_search = true,
        -- command_palette = true,
        long_message_to_split = true,
      },
    },
    keys = {
      { "<leader>cm", vim.cmd.NoiceAll, desc = "See messages history", mode = { "n", "v" } },
      { "<leader>cc", vim.cmd.NoiceDismiss, desc = "Dismiss notifications", mode = { "n", "v" } },
    },
  },
}
