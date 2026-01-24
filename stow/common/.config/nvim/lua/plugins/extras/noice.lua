return {
  -- {
  --   "rcarriga/nvim-notify",
  --   enabled = false,
  --   opts = {
  --     timeout = 3000,
  --     max_width = nil,
  --     max_height = nil,
  --     -- "fade" | "slide" | "slide_out" | "fade_in_slide_out" | "static",
  --     stages = "static",
  --     -- "default" | "minimal" | "simple"
  --     render = "minimal",
  --     minimum_width = 30,
  --     fps = 60,
  --     top_down = false,
  --     merge_duplicates = true,
  --     icons = require("icons").diagnostics,
  --   },
  -- },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
    },
    event = { "VeryLazy" },
    opts = {
      -- routes = {
      --   {
      --     filter = { event = "msg_show", kind = "", find = "%d+L, %d+B" },
      --     opts = { skip = true },
      --   },
      --   {
      --     filter = { event = "msg_show", kind = "", find = "change[s]?; before" },
      --     opts = { skip = true },
      --   },
      --   {
      --     filter = { event = "msg_show", kind = "", find = "change[s]?; after" },
      --     opts = { skip = true },
      --   },
      --   {
      --     filter = { event = "msg_show", find = "Already at" },
      --     opts = { skip = true },
      --   },
      --   {
      --     filter = { event = "msg_show", find = "lines yanked" },
      --     opts = { skip = true },
      --   },
      -- },
      cmdline = {
        enabled = true,
      },
      messages = {
        enabled = true,
      },
      notify = {
        enabled = true,
      },
      views = {
        cmdline_popup = {
          position = {
            row = "30%",
            col = "50%",
          },
        },
      },
      lsp = {
        progress = {
          enabled = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    init = function(plugin)
      if plugin.opts.messages.enabled then
        vim.keymap.set("n", "<leader>cm", vim.cmd.NoiceAll, { desc = "See messages history" })
      end

      if plugin.opts.notify.enabled then
        vim.keymap.set("n", "<leader>cc", vim.cmd.NoiceDismiss, { desc = "Dismiss notifications" })
      end
    end,
  },
}
