-- Only really used for LSP progress and notifications handling
return {
  {
    "rcarriga/nvim-notify",
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
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    event = { "VeryLazy" },
    opts = {
      cmdline = {
        enabled = false,
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
