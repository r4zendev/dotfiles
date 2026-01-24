return {
  "nvim-neo-tree/neo-tree.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>ea",
      function()
        local manager = require("neo-tree.sources.manager")
        local state = manager.get_state("filesystem")

        if state.winid and vim.api.nvim_win_is_valid(state.winid) then
          require("neo-tree.command").execute({ action = "close" })
          return
        end

        local reveal_file = vim.fn.expand("%:p")
        if reveal_file == "" then
          reveal_file = vim.fn.getcwd()
        else
          local stat = vim.loop.fs_stat(reveal_file)
          if not stat then
            reveal_file = vim.fn.getcwd()
          end
        end

        require("neo-tree.command").execute({
          action = "focus",
          source = "filesystem",
          position = "left",
          reveal_file = reveal_file,
          reveal_force_cwd = true,
        })
      end,
      desc = "Toggle Neo Tree",
    },
  },
  opts = function(_, opts)
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })

    opts.filesystem = vim.tbl_deep_extend("force", opts.filesystem or {}, {
      hijack_netrw_behavior = "disabled",
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_ignored = true,
      },
    })
  end,
}
