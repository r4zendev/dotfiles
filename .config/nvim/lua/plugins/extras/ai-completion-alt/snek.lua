-- Pretty interesting autocompletion option
return {
  "4tyone/snek-nvim",
  event = "LazyFile",
  config = function()
    require("snek-nvim").setup({
      api_key = vim.env.CEREBRAS_API_KEY,
      model = "qwen-3-235b-a22b-instruct-2507",
      -- Doesn't work as expected
      condition = function()
        return false
        -- return vim.g.enable_snek
      end,
      disable_keymaps = true,
    })

    -- Doesn't work
    -- vim.g.enable_snek = true
    -- Snacks.toggle({
    --   name = "Snek",
    --   get = function()
    --     return vim.g.enable_snek
    --   end,
    --   set = function(state)
    --     vim.g.enable_snek = state
    --   end,
    -- }):map("<leader>un")

    local suggestion = require("snek-nvim.completion_preview")

    vim.keymap.set("i", "<Tab>", function()
      if suggestion.has_suggestion() then
        suggestion.on_accept_suggestion()
        return
      end

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end, { desc = "Accept Snek suggestion" })

    vim.keymap.set("i", "<C-[>", function()
      if suggestion.has_suggestion() then
        suggestion.on_dispose_inlay()
        return
      end
    end, { desc = "Clear Snek suggestion" })

    vim.keymap.set("i", "<C-w>", function()
      if suggestion.has_suggestion() then
        suggestion.on_accept_suggestion_word()
        return
      end
    end, { desc = "Accept Snek suggestion word" })
  end,
}
