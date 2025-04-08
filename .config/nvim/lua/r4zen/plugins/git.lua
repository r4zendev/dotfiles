return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    opts = {
      file_panel = {
        win_config = {
          position = "bottom",
          height = 10,
        },
      },
    },
    keys = {
      {
        "<leader>gd",
        function()
          if require("diffview.lib").get_current_view() then
            vim.cmd.DiffviewClose()
          else
            vim.cmd.DiffviewOpen()
          end
        end,
        noremap = true,
        silent = true,
        desc = "Toggle DiffView",
      },
    },
  },
  {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      enabled = true,
      message_template = " <date> • <author> • <<sha>>",
      date_format = "%d-%m-%Y",
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
      -- message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
      -- date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
    },
    keys = {
      { "<leader>bx", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Git Blame Open Commit URL" },
      { "<leader>by", "<cmd>GitBlameCopySHA<cr>", desc = "Git Blame Copy SHA" },
    },
  },
}
