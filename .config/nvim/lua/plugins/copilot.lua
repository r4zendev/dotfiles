return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        jump_prev = "[s",
        jump_next = "]s",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>",
      },
      layout = {
        position = "bottom", -- | top | left | right | bottom |
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      trigger_on_accept = true,
      keymap = {
        -- remapped in init
        accept = false,
        accept_word = "<C-w>",
        accept_line = "<C-l>",
        next = "]]",
        prev = "[[",
        dismiss = "<C-]>",
      },
    },
  },
  keys = {
    { "<leader>ap", "<cmd>Copilot panel<cr>", desc = "Copilot Panel", mode = "n" },
  },
  config = function(_, opts)
    vim.g.copilot_enabled = true

    opts = vim.tbl_deep_extend("force", opts, {
      suggestion = {
        enabled = vim.g.copilot_enabled,
      },
    })

    if vim.g.copilot_enabled then
      vim.keymap.set("i", "<Tab>", function()
        local copilot_suggestion = require("copilot.suggestion")

        if copilot_suggestion.is_visible() then
          copilot_suggestion.accept()
          return
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end, { silent = true })
    end

    require("copilot").setup(opts)
  end,
}
