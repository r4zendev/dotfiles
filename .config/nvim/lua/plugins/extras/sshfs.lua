-- To use sshfs.nvim, you need to have sshfs installed on your system.
-- macOS requires macFUSE: https://macfuse.github.io/
--
-- Run :checkhealth sshfs to verify installation

return {
  "uhs-robert/sshfs.nvim",
  -- Makes the :quit command a bit slower as it will unmount all sshfs mounts,
  -- so I keep it disabled by default and only enable on demand.
  enabled = false,
  event = "VeryLazy",
  opts = {
    hooks = {
      on_exit = {
        auto_unmount = true, -- auto-disconnect all mounts on :q or exit
        clean_mount_folders = true, -- optionally clean up mount folders after disconnect
      },
      on_mount = {
        auto_change_to_dir = false, -- auto-change current directory to mount point
        auto_run = "find", -- "find" (default), "grep", "live_find", "live_grep", "terminal", "none", or a custom function(ctx)
      },
    },
    ui = {
      local_picker = {
        preferred_picker = "auto", -- one of: "auto", "snacks", "fzf-lua", "mini", "telescope", "oil", "neo-tree", "nvim-tree", "yazi", "lf", "nnn", "ranger", "netrw"
      },
      remote_picker = {
        preferred_picker = "snacks",
      },
    },
    lead_prefix = "<leader>m", -- change keymap prefix (default: <leader>m)
    keymaps = {
      mount = "<leader>mm", -- creates an ssh connection and mounts via sshfs
      unmount = "<leader>mu", -- disconnects an ssh connection and unmounts via sshfs
      explore = "<leader>me", -- explore an sshfs mount using your native editor
      change_dir = "<leader>md", -- change dir to mount
      command = "<leader>mo", -- run command on mount
      config = "<leader>mc", -- edit ssh config
      reload = "<leader>mr", -- manually reload ssh config
      files = "<leader>mf", -- browse files using chosen picker
      grep = "<leader>mg", -- grep files using chosen picker
      terminal = "<leader>mt", -- open ssh terminal session
    },
  },
}
