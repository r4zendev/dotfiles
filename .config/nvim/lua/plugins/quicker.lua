return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  keys = {
    {
      "<leader>xq",
      function()
        require("quicker").toggle()
      end,
      desc = "Toggle quickfix",
    },
    {
      "<leader>xl",
      function()
        require("quicker").toggle({ loclist = true })
      end,
      desc = "Toggle loclist list",
    },
    {
      "<leader>xd",
      function()
        local quicker = require("quicker")

        if quicker.is_open() then
          quicker.close()
        else
          vim.diagnostic.setqflist()
        end
      end,
      desc = "Toggle diagnostics",
    },
    {
      ">",
      function()
        local quicker = require("quicker")

        if quicker.is_open() then
          quicker.expand({ before = 2, after = 2, add_to_existing = true })
          return
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(">", true, false, true), "n", false)
      end,
      desc = "Expand context",
    },
    {
      "<",
      function()
        local quicker = require("quicker")

        if quicker.is_open() then
          quicker.collapse()
          return
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<", true, false, true), "n", false)
      end,
      desc = "Collapse context",
    },
  },
}
