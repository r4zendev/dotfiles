return {
  "gbprod/yanky.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    highlight = {
      timer = 150,
    },
    textobj = {
      enabled = true,
    },
  },
  keys = {
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after (with global register)" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before (with global register)" },

    { "<c-p>", "<Plug>(YankyPreviousEntry)", mode = "n", desc = "Previous entry" },
    { "<c-n>", "<Plug>(YankyNextEntry)", mode = "n", desc = "Next entry" },

    {
      "iy",
      function()
        require("yanky.textobj").last_put()
      end,
      mode = { "o", "x" },
      desc = "In put (yank)",
    },
    {
      "ay",
      function()
        require("yanky.textobj").last_put()
      end,
      mode = { "o", "x" },
      desc = "At put (yank)",
    },
  },
}
