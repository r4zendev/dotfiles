return {
  "christoomey/vim-tmux-navigator",
  config = function()
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", opts)
    vim.keymap.set("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", opts)
    vim.keymap.set("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", opts)
    vim.keymap.set("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", opts)
  end,
}
