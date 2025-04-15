-- A good nvim-navic alternative
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "LazyFile",
  opts = { mode = "cursor", max_lines = 3, separator = nil },
  -- stylua: ignore
  keys = {
    { "[z", function() require("treesitter-context").go_to_context(vim.v.count1) end, silent = true },
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)

    local tsc = require("treesitter-context")
    Snacks.toggle({
      name = "Treesitter Context",
      get = tsc.enabled,
      set = function(state)
        if state then
          tsc.enable()
        else
          tsc.disable()
        end
      end,
    }):map("<leader>ut", { desc = "Toggle Treesitter Context" })
  end,
}
