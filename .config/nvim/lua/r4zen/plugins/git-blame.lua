return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
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
}
