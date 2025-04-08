-- Could be a good alternative if the plugin develops further
--
-- return {
--   "stevalkr/multiplexer.nvim",
--   lazy = false,
--   opts = {
--     float_win = nil,
--     block_if_zoomed = false,
--     muxes = { "nvim", "tmux" },
--   },
--   keys = {
--     {
--       "<c-h>",
--       function()
--         require("multiplexer").activate_pane_left()
--       end,
--       desc = "Activate pane left",
--       mode = { "n", "v", "i" },
--     },
--     {
--       "<c-j>",
--       function()
--         require("multiplexer").activate_pane_down()
--       end,
--       desc = "Activate pane down",
--       mode = { "n", "v", "i" },
--     },
--     {
--       "<c-k>",
--       function()
--         require("multiplexer").activate_pane_up()
--       end,
--       desc = "Activate pane up",
--       mode = { "n", "v", "i" },
--     },
--     {
--       "<c-l>",
--       function()
--         require("multiplexer").activate_pane_right()
--       end,
--       desc = "Activate pane right",
--       mode = { "n", "v", "i" },
--     },
--   },
-- }

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
