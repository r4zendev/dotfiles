return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    prompt_func_return_type = {
      go = false,
      java = false,

      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    prompt_func_param_type = {
      go = false,
      java = false,

      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
    show_success_message = true, -- shows a message with information about the refactor on success
  },
  keys = {
    {
      "<leader>re",
      function()
        return require("refactoring").refactor("Extract Function")
      end,
      desc = "Refactoring: Extract Function",
      expr = true,
      mode = { "n", "x" },
    },
    {
      "<leader>rf",
      function()
        return require("refactoring").refactor("Extract Function To File")
      end,
      desc = "Refactoring: Extract Function To File",
      expr = true,
      mode = { "n", "x" },
    },
    {
      "<leader>rv",
      function()
        return require("refactoring").refactor("Extract Variable")
      end,
      desc = "Refactoring: Extract Variable",
      expr = true,
      mode = { "n", "x" },
    },
    {
      "<leader>rI",
      function()
        return require("refactoring").refactor("Inline Function")
      end,
      desc = "Refactoring: Inline Function",
      expr = true,
      mode = { "n", "x" },
    },
    {
      "<leader>ri",
      function()
        return require("refactoring").refactor("Inline Variable")
      end,
      desc = "Refactoring: Inline Variable",
      expr = true,
      mode = { "n", "x" },
    },

    {
      "<leader>rbb",
      function()
        return require("refactoring").refactor("Extract Block")
      end,
      desc = "Refactoring: Extract Block",
      expr = true,
      mode = { "n", "x" },
    },
    {
      "<leader>rbf",
      function()
        return require("refactoring").refactor("Extract Block To File")
      end,
      desc = "Refactoring: Extract Block To File",
      expr = true,
      mode = { "n", "x" },
    },

    {
      "<leader>rr",
      function()
        return require("refactoring").select_refactor()
      end,
      desc = "Refactoring: Select refactoring type",
      mode = { "n", "x" },
    },
  },
}
