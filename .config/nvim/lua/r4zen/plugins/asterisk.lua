return {
  "haya14busa/vim-asterisk",
  init = function()
    vim.g["asterisk#keeppos"] = 1
  end,
  keys = {
    { "*", "<Plug>(asterisk-z*)", silent = true },
    { "#", "<Plug>(asterisk-z#)", silent = true },

    { "g*", "<Plug>(asterisk-g*)", silent = true },
    { "g#", "<Plug>(asterisk-g#)", silent = true },

    { "z*", "<Plug>(asterisk-*)", silent = true },
    { "z#", "<Plug>(asterisk-#)", silent = true },

    { "gz*", "<Plug>(asterisk-gz*)", silent = true },
    { "gz#", "<Plug>(asterisk-gz#)", silent = true },
  },
}
