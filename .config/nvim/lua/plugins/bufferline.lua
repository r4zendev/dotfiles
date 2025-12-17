return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      show_close_icon = false,
      show_buffer_close_icons = false,
      truncate_names = false,
      separator_style = "slope",
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
    highlights = {
      background = {
        fg = "#545c7e",
        bg = "#1a1b26",
      },
      separator = {
        fg = "#16161e",
        bg = "#1a1b26",
      },

      buffer_selected = {
        fg = "#c0caf5",
        bg = "#24283b",
        bold = true,
        italic = false,
      },
      separator_selected = {
        fg = "#16161e",
        bg = "#24283b",
      },

      buffer_visible = {
        fg = "#787c99",
        bg = "#1f2335",
      },
      separator_visible = {
        fg = "#16161e",
        bg = "#1f2335",
      },

      indicator_selected = {
        fg = "#0DB9D7",
        bg = "#24283b",
      },
      indicator_visible = {
        fg = "#3b4261",
        bg = "#1f2335",
      },

      modified = {
        fg = "#e0af68",
        bg = "#1a1b26",
      },
      modified_visible = {
        fg = "#e0af68",
        bg = "#1f2335",
      },
      modified_selected = {
        fg = "#e0af68",
        bg = "#24283b",
      },

      error = {
        fg = "#db4b4b",
        bg = "#1a1b26",
      },
      error_diagnostic = {
        fg = "#db4b4b",
        bg = "#1a1b26",
      },
      error_selected = {
        fg = "#db4b4b",
        bg = "#24283b",
        bold = true,
      },
      error_diagnostic_selected = {
        fg = "#db4b4b",
        bg = "#24283b",
      },
      error_visible = {
        fg = "#db4b4b",
        bg = "#1f2335",
      },
      error_diagnostic_visible = {
        fg = "#db4b4b",
        bg = "#1f2335",
      },

      warning = {
        fg = "#e0af68",
        bg = "#1a1b26",
      },
      warning_diagnostic = {
        fg = "#e0af68",
        bg = "#1a1b26",
      },
      warning_selected = {
        fg = "#e0af68",
        bg = "#24283b",
        bold = true,
      },
      warning_diagnostic_selected = {
        fg = "#e0af68",
        bg = "#24283b",
      },
      warning_visible = {
        fg = "#e0af68",
        bg = "#1f2335",
      },
      warning_diagnostic_visible = {
        fg = "#e0af68",
        bg = "#1f2335",
      },

      info = {
        fg = "#0db9d7",
        bg = "#1a1b26",
      },
      info_diagnostic = {
        fg = "#0db9d7",
        bg = "#1a1b26",
      },
      info_selected = {
        fg = "#0db9d7",
        bg = "#24283b",
        bold = true,
      },
      info_diagnostic_selected = {
        fg = "#0db9d7",
        bg = "#24283b",
      },
      info_visible = {
        fg = "#0db9d7",
        bg = "#1f2335",
      },
      info_diagnostic_visible = {
        fg = "#0db9d7",
        bg = "#1f2335",
      },

      hint = {
        fg = "#1abc9c",
        bg = "#1a1b26",
      },
      hint_diagnostic = {
        fg = "#1abc9c",
        bg = "#1a1b26",
      },
      hint_selected = {
        fg = "#1abc9c",
        bg = "#24283b",
        bold = true,
      },
      hint_diagnostic_selected = {
        fg = "#1abc9c",
        bg = "#24283b",
      },
      hint_visible = {
        fg = "#1abc9c",
        bg = "#1f2335",
      },
      hint_diagnostic_visible = {
        fg = "#1abc9c",
        bg = "#1f2335",
      },

      duplicate = {
        fg = "#545c7e",
        bg = "#1a1b26",
        italic = true,
      },
      duplicate_selected = {
        fg = "#c0caf5",
        bg = "#24283b",
        italic = true,
      },
      duplicate_visible = {
        fg = "#787c99",
        bg = "#1f2335",
        italic = true,
      },

      pick = {
        fg = "#f7768e",
        bg = "#1a1b26",
        bold = true,
      },
      pick_selected = {
        fg = "#f7768e",
        bg = "#24283b",
        bold = true,
      },
      pick_visible = {
        fg = "#f7768e",
        bg = "#1f2335",
        bold = true,
      },
    },
  },
  keys = {
    { "<leader>bp", vim.cmd.BufferLinePick, desc = "Pick a buffer to open" },
    { "<leader>bc", vim.cmd.BufferLinePickClose, desc = "Select a buffer to close" },
    { "<leader>bo", vim.cmd.BufferLineCloseOthers, desc = "Close other buffers" },
  },
}
