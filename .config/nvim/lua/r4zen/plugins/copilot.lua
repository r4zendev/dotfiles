return {
  "zbirenbaum/copilot.lua",
  version = "*",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          accept_line = "<C-l>",
          accept_word = "<C-w>",
          next = "]]",
          prev = "[[",
        },
      },
    })

    local copilot_suggestion = require("copilot.suggestion")

    vim.keymap.set("i", "<Tab>", function()
      if copilot_suggestion.is_visible() then
        copilot_suggestion.accept()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end, { silent = true })
  end,
}
