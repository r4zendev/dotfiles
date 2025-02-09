-- local function live_grep_visual()
--   local saved_reg = vim.fn.getreg("a")
--   local saved_regtype = vim.fn.getregtype("a")
--
--   vim.cmd('normal! "ay')
--   local text = vim.fn.getreg("a")
--   vim.fn.setreg("a", saved_reg, saved_regtype)
--
--   require("telescope.builtin").live_grep({
--     additional_args = { "--multiline" },
--     default_text = text:gsub("\n", "\\n"):gsub("([%(%).%%%+%-%*%?%[%]%^%$%\\%{%}%|])", "\\%1"):gsub("\\\\n", "\\n"),
--   })
-- end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        -- file_ignore_patterns = {
        --   "node_modules",
        --   "karabiner",
        --   "raycast",
        -- },
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--sortr=modified", "--smart-case", "--hidden" },
        },
        -- Use grug-far instead
        -- live_grep = {
        --   -- default_text = text
        --   --   :gsub("\n", "\\n")
        --   --   :gsub("([%(%).%%%+%-%*%?%[%]%^%$%\\%{%}%|])", "\\%1")
        --   --   :gsub("\\\\n", "\\n"),
        --   find_command = {
        --     "rg",
        --     "--color=never",
        --     "--no-heading",
        --     "--with-filename",
        --     "--line-number",
        --     "--column",
        --     "--smart-case",
        --     "--hidden",
        --     "--trim",
        --     "--multiline",
        --     "--multiline-dotall",
        --   },
        -- },
      },
    })

    telescope.load_extension("fzf")

    -- vim.keymap.set("v", "<leader>fv", live_grep_visual, { desc = "Find visually selected text in cwd" })
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files in cwd" })
    vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })

    -- Use grug-far instead
    -- vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    -- vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
  end,
}
