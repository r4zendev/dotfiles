return {
  "A7Lavinraj/fyler.nvim",
  event = "LazyFile",
  cmd = { "Fyler" },
  dependencies = { "echasnovski/mini.nvim" },
  branch = "main",
  opts = {
    views = {
      finder = {
        close_on_select = true,
        confirm_simple = false,
        default_explorer = false,
        delete_to_trash = false,
        icon = {
          directory_collapsed = nil,
          directory_empty = nil,
          directory_expanded = nil,
        },
        follow_current_file = true,
        watcher = {
          enabled = false,
        },
        git_status = {
          enabled = true,
          symbols = {
            Untracked = "",
            Added = "",
            Modified = "",
            Deleted = "",
            Renamed = "",
            Copied = "󰜥",
            Conflict = "",
            Ignored = "",
          },
        },
        win = {
          border = vim.o.winborder == "" and "single" or vim.o.winborder,
          buf_opts = {
            filetype = "fyler",
            syntax = "fyler",
            buflisted = false,
            buftype = "acwrite",
            expandtab = true,
            shiftwidth = 2,
          },
          -- float | replace | split_left | split_left_most | split_above | split_above_all | split_right | split_right_most | split_below | split_below_all
          kind = "float",
          kinds = {
            -- height | width | top | bottom | left | right | win_opts
            float = {
              height = "85%",
              width = "35%",
              top = "20%",
              left = "100%",
            },
            split_right_most = {
              width = "30%",
              win_opts = {
                winfixwidth = true,
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>ea",
      function()
        require("fyler").toggle()
      end,
      mode = "n",
      desc = "Open Fyler View",
    },
  },
}
