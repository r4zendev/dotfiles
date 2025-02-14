return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
      })

      vim.keymap.set("n", "<leader>tt", function()
        local buf_dir = vim.fn.expand("%:p:h") or vim.loop.cwd()
        vim.cmd("ToggleTerm dir=" .. vim.fn.fnameescape(buf_dir)) -- Escape the path to handle spaces
      end, { desc = "Open overlay terminal at current path" })
    end,
  },
}
