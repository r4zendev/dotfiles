return {
  "numToStr/Navigator.nvim",
  cmd = {
    "NavigatorLeft",
    "NavigatorDown",
    "NavigatorUp",
    "NavigatorRight",
    "NavigatorPrevious",
  },
  opts = {
    auto_save = nil,
  },
  keys = {
    { "<c-h>", vim.cmd.NavigatorLeft },
    { "<c-j>", vim.cmd.NavigatorDown },
    { "<c-k>", vim.cmd.NavigatorUp },
    { "<c-l>", vim.cmd.NavigatorRight },
  },
}

-- return {
--   "christoomey/vim-tmux-navigator",
--   cmd = {
--     "TmuxNavigateLeft",
--     "TmuxNavigateDown",
--     "TmuxNavigateUp",
--     "TmuxNavigateRight",
--     "TmuxNavigatePrevious",
--     "TmuxNavigatorProcessList",
--   },
--   keys = {
--     { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
--     { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
--     { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
--     { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
--     { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
--   },
-- }
