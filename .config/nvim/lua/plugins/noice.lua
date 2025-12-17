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
      enabled = true,
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    keys = {
      { "<leader>cm", vim.cmd.NoiceAll, desc = "See messages history", mode = { "n", "v" } },
      { "<leader>cd", vim.cmd.NoiceDismiss, desc = "Dismiss notifications", mode = { "n", "v" } },
    },
  },
}
