return {
  "nvim-lualine/lualine.nvim",
  event = "LazyFile",
  dependencies = {
    "echasnovski/mini.nvim",
  },
  config = function()
    local git_blame = require("gitblame")

    require("lualine").setup({
      sections = {
        lualine_c = {
          { "filename" },
          {
            function()
              local original_text = git_blame.get_current_blame_text()
              local separator = "•"
              local split_text = vim.split(original_text, separator)
              return (#split_text >= 2) and (table.concat({ split_text[1], split_text[2] }, separator)) or original_text
            end,
            cond = function()
              return git_blame.is_blame_text_available() and not vim.api.nvim_buf_get_name(0):match("^oil://")
            end,
          },
        },
        lualine_x = {
          {
            require("noice").api.status.mode.get,
            cond = require("noice").api.status.mode.has,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
