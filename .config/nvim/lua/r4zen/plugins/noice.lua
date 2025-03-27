return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        render = "compact",
        stages = "fade",
        fps = 60,
      },
      config = function(_, opts)
        require("notify").setup(opts)

        vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#B31E1E" })
        vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#E37C1E" })
        vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#5CD3DB" })
      end,
    },
  },
  lazy = true,
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
    {
      "<leader>cm",
      function()
        vim.cmd("NoiceAll")
      end,
      desc = "See messages history",
    },
  },
}
