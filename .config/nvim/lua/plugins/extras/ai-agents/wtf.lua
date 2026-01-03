return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim",
  },
  opts = {
    popup_type = "popup",
    provider = "copilot",
    providers = {
      copilot = {
        model_id = "claude-sonnet-4.5",
      },
    },
    language = "english",
    -- search_engine = "google" | "duck_duck_go" | "stack_overflow" | "github" | "phind" | "perplexity",
    search_engine = "google",
    picker = "snacks",
    hooks = {
      request_started = nil,
      request_finished = nil,
    },
  },
  keys = {
    {
      "<leader>Wd",
      mode = { "n", "x" },
      function()
        require("wtf").diagnose()
      end,
      desc = "Debug diagnostic with AI",
    },
    {
      "<leader>Wf",
      mode = { "n", "x" },
      function()
        require("wtf").fix()
      end,
      desc = "Fix diagnostic with AI",
    },
    {
      mode = { "n", "x" },
      "<leader>Ws",
      function()
        require("wtf").search()
      end,
      desc = "Search diagnostic with Web",
    },
    {
      mode = { "n" },
      "<leader>Wp",
      function()
        require("wtf").pick_provider()
      end,
      desc = "Pick provider",
    },
    {
      mode = { "n" },
      "<leader>Wh",
      function()
        require("wtf").history()
      end,
      desc = "Quickfix chat history",
    },
    {
      mode = { "n" },
      "<leader>Wg",
      function()
        require("wtf").grep_history()
      end,
      desc = "Grep previous chat history",
    },
  },
}
