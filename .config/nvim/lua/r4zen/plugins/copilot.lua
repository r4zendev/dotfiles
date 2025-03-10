return {
  "zbirenbaum/copilot.lua",
  branch = "create-pull-request/update-copilot-dist",
  -- version = "*",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
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
  },
  config = function(_, opts)
    local new_opts = vim.tbl_extend("force", opts, {
      server_opts_overrides = {
        cmd = {
          "node",
          vim.api.nvim_get_runtime_file("copilot/dist/language-server.js", false)[1],
          "--stdio",
        },
        init_options = {
          copilotIntegrationId = "vscode-chat",
        },
      },
    })

    require("copilot").setup(new_opts)

    local util = require("copilot.util")
    local orig_get_editor_configuration = util.get_editor_configuration

    util.get_editor_configuration = function()
      local config = orig_get_editor_configuration()

      return vim.tbl_extend("force", config, {
        github = {
          copilot = {
            selectedCompletionModel = "gpt-4o-copilot",
          },
        },
      })
    end

    return new_opts
  end,
}
