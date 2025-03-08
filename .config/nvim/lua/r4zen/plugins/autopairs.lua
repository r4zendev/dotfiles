-- Until mini.pairs has better defaults
-- and supports the same feature set
-- that nvim-autopairs does by default,
-- I will continue using nvim-autopairs.

return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  opts = {
    check_ts = true, -- treesitter
    ts_config = {
      lua = { "string" }, -- avoid pairs in lua strings
      javascript = { "template_string" }, -- don't add pairs in js template_strings
    },
  },
}
