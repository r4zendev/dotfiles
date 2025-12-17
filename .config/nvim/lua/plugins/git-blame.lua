return {
  "f-person/git-blame.nvim",
  event = "LazyFile",
  opts = {
    enabled = true,
    delay = 0,
    message_template = " <date> • <author> • <<sha>>",
    date_format = "%d-%m-%Y",
    virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    -- message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
    -- date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
  },
  keys = {
    { "<leader>gBx", vim.cmd.GitBlameOpenCommitURL, desc = "Git Blame Open Commit URL" },
    { "<leader>gBy", vim.cmd.GitBlameCopySHA, desc = "Git Blame Copy SHA" },
  },
}
