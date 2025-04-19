return {
  "augmentcode/augment.vim",
  cmd = "Augment",
  event = "LazyFile",
  keys = {
    {
      "<leader>au",
      function()
        local mode = vim.api.nvim_get_mode().mode
        local start_line, end_line

        if mode == "v" or mode == "V" then -- visual mode
          start_line = vim.fn.line("'<")
          end_line = vim.fn.line("'>")
        end

        -- Use vim.ui.input
        vim.ui.input({ prompt = "Augment Chat: " }, function(input)
          if not input or input == "" then
            return
          end

          if start_line and end_line then -- visual mode
            vim.cmd(string.format("%d,%dAugment chat %s", start_line, end_line, input))
          else -- normal mode
            vim.cmd("Augment chat " .. input)
          end
        end)
      end,
      desc = "Augment Chat",
      mode = { "n", "v" },
    },
  },
  init = function()
    vim.g.augment_workspace_folders = { require("r4zen.utils").workspace_root() }

    -- Disable completion, but keep the chat available
    -- vim.g.augment_disable_completions = true
    -- vim.g.augment_disable_tab_mapping = true
  end,
}
