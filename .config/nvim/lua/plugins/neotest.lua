return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "stevearc/overseer.nvim",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-go",
    "lawrence-laz/neotest-zig",
  },
  opts = {
    status = { virtual_text = true },
    output = { open_on_run = true },
  },
  config = function(_, opts)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
        end,
      },
    }, neotest_ns)

    opts.adapters = {
      require("neotest-jest")({ cwd = function() return vim.fn.getcwd() end }),
      require("neotest-vitest"),
      require("neotest-go")({ args = { "-v", "-race", "-count=1" } }),
      require("neotest-zig"),
      require("rustaceanvim.neotest"),
    }

    opts.consumers = { overseer = require("neotest.consumers.overseer") }

    require("neotest").setup(opts)
  end,
  -- stylua: ignore
  keys = {
    { "<leader>t", "", desc = "+test" },
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Output Panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Watch" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
  },
}
