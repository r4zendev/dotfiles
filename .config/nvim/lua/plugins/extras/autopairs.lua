return {
  "windwp/nvim-autopairs",
  enabled = false,
  event = { "InsertEnter" },
  opts = {
    map_cr = true,
    check_ts = true, -- treesitter
    ts_config = {
      lua = { "string" }, -- avoid pairs in lua strings
      javascript = { "template_string" }, -- don't add pairs in js template_strings
    },
  },
  init = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    npairs.add_rule(Rule("|", "|", "zig"))
  end,
}
