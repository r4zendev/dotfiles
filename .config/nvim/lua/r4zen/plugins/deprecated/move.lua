return {
  "fedepujol/move.nvim",
  config = function()
    require("move").setup()
    -- require("move").setup({
    --   -- whether to set <C-hjkl> to move lines / blocks up and down
    --   mappings = {
    --     move_line_down = "<C-j>",
    --     move_line_up = "<C-k>",
    --     move_block_up = "<C-h>",
    --     move_block_down = "<C-l>",
    --   },
    --   -- whether to show a message indicating the line has moved
    --   on_move = function()
    --     return
    --   end,
    -- })

    -- -- Visual-mode commands
    vim.keymap.set("v", "<C-j>", ":MoveBlock(1)<CR>")
    vim.keymap.set("v", "<C-k>", ":MoveBlock(-1)<CR>")
    -- vim.keymap.set("v", "<C-h>", ":MoveHBlock(-1)<CR>")
    -- vim.keymap.set("v", "<C-l>", ":MoveHBlock(1)<CR>")
  end,
}
