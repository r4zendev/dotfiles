return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      show_close_icon = false,
      show_buffer_close_icons = false,
      truncate_names = false,
      separator_style = "slope",
      indicator = {
        icon = nil,
        style = "icon",
      },
      close_command = function(bufnr)
        require("mini.bufremove").delete(bufnr, false)
      end,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = require("icons").diagnostics
        local indicator = (diag.error and icons.ERROR .. " " or "") .. (diag.warning and icons.WARN or "")
        return vim.trim(indicator)
      end,
    },
  },
  keys = {
    { "<leader>bp", vim.cmd.BufferLinePick, desc = "Pick a buffer to open" },
    { "<leader>bc", vim.cmd.BufferLinePickClose, desc = "Select a buffer to close" },
    { "<leader>bo", vim.cmd.BufferLineCloseOthers, desc = "Close other buffers" },
  },
}
