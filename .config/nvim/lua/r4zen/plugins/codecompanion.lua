return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.5-sonnet",
              },
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = os.getenv("GEMINI_API_KEY"),
            },
          })
        end,
      },
      strategies = {
        chat = {
          slash_commands = {
            ["file"] = {
              -- Location to the slash command in CodeCompanion
              callback = "strategies.chat.slash_commands.file",
              description = "Select a file using Telescope",
              opts = {
                provider = "snacks", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
                contains_code = true,
              },
            },
          },
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
    })

    vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Code Companion" })
  end,
}
