return {
  "haya14busa/vim-asterisk",
  init = function()
    vim.g["asterisk#keeppos"] = 1
  end,
  keys = {
    { "*", "<Plug>(asterisk-z*)", silent = true, mode = { "n", "v" } },
    { "#", "<Plug>(asterisk-z#)", silent = true, mode = { "n", "v" } },

    { "g*", "<Plug>(asterisk-g*)", silent = true, mode = { "n", "v" } },
    { "g#", "<Plug>(asterisk-g#)", silent = true, mode = { "n", "v" } },

    { "z*", "<Plug>(asterisk-*)", silent = true, mode = { "n", "v" } },
    { "z#", "<Plug>(asterisk-#)", silent = true, mode = { "n", "v" } },

    { "gz*", "<Plug>(asterisk-gz*)", silent = true, mode = { "n", "v" } },
    { "gz#", "<Plug>(asterisk-gz#)", silent = true, mode = { "n", "v" } },
  },
}
