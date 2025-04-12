return {
  "folke/trouble.nvim",
  -- event = "LazyFile",
  cmd = "Trouble",
  -- stylua: ignore
  keys = {
    {
      "<leader>xw",
      function()
        ---@diagnostic disable-next-line: missing-fields
        require("trouble").toggle({
          mode = "diagnostics",
          filter = function(items)
            return vim.tbl_filter(function(item)
              return item.dirname:find(vim.uv.cwd(), 1, true)
            end, items)
          end,
        })
      end,
      desc = "Trouble: Workspace diagnostics",
      silent = true,
    },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Document diagnostics", silent = true },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Toggle loclist", silent = true },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Toggle quickfix", silent = true },
    { "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>", desc = "Trouble: LSP references", silent = true },
  },
  opts = {
    -- NOTE: for reference
    -- keys = {
    --   ["?"] = "help",
    --   r = "refresh",
    --   R = "toggle_refresh",
    --   q = "close",
    --   o = "jump_close",
    --   ["<esc>"] = "cancel",
    --   ["<cr>"] = "jump",
    --   ["<2-leftmouse>"] = "jump",
    --   ["<c-s>"] = "jump_split",
    --   ["<c-v>"] = "jump_vsplit",
    --   -- go down to next item (accepts count)
    --   -- j = "next",
    --   ["}"] = "next",
    --   ["]]"] = "next",
    --   -- go up to prev item (accepts count)
    --   -- k = "prev",
    --   ["{"] = "prev",
    --   ["[["] = "prev",
    --   dd = "delete",
    --   d = { action = "delete", mode = "v" },
    --   i = "inspect",
    --   p = "preview",
    --   P = "toggle_preview",
    --   zo = "fold_open",
    --   zO = "fold_open_recursive",
    --   zc = "fold_close",
    --   zC = "fold_close_recursive",
    --   za = "fold_toggle",
    --   zA = "fold_toggle_recursive",
    --   zm = "fold_more",
    --   zM = "fold_close_all",
    --   zr = "fold_reduce",
    --   zR = "fold_open_all",
    --   zx = "fold_update",
    --   zX = "fold_update_all",
    --   zn = "fold_disable",
    --   zN = "fold_enable",
    --   zi = "fold_toggle_enable",
    -- },
  },
}
