return {
  { "banjo/contextfiles.nvim" },
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "MCPHub",
    build = "npm install -g mcp-hub@latest",
    opts = {
      port = 37373,
      config = vim.fn.expand("~/.config/mcpservers.json"),

      auto_approve = false,
      auto_toggle_mcp_servers = false,

      log = {
        level = vim.log.levels.WARN,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
      },
    },
    keys = {
      { "<leader>ah", ":MCPHub<CR>", desc = "Open MCP Hub" },
    },
    init = function()
      local root_dir = require("r4zen.utils").workspace_root()
      if root_dir ~= nil then
        -- Set the environment variable before loading the config
        -- Used by MCP servers that require project's root path as an argument
        vim.fn.setenv("MCP_PROJECT_ROOT_PATH", root_dir)
      end
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    branch = "v18",
    cmd = { "CodeCompanion", "CodeCompanionChat" },
    event = { "LazyFile" },
    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
        },
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            expiration_days = 0,
            picker = "snacks",
            chat_filter = nil, -- function(chat_data) return boolean end
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            auto_generate_title = true,
            title_generation_opts = {
              adapter = "copilot",
              -- Should be enabled in Github Copilot settings
              -- model = "claude-4.5-sonnet",
              refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
              max_refreshes = 3,
              format_title = function(original_title)
                return original_title
              end,
            },
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            enable_logging = false,

            summary = {
              create_summary_keymap = "gcs",
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = nil, -- defaults to current chat adapter
                model = nil, -- defaults to current chat model
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },
            -- Memory system (requires VectorCode CLI)
            memory = {
              auto_create_memories_on_summary_generation = true,
              vectorcode_exe = "vectorcode",
              tool_opts = {
                default_num = 10,
              },
              notify = true,
              index_on_startup = false,
            },
          },
        },
      },
      adapters = {
        -- Should be enabled in Github Copilot settings
        -- copilot = function()
        --   return require("codecompanion.adapters").extend("copilot", {
        --     schema = { model = { default = "claude-4.5-opus" } },
        --   })
        -- end,
        openrouter_grok = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = { model = { default = "x-ai/grok-4.1-fast:free" } },
          })
        end,
        claude_code = function()
          return require("codecompanion.adapters").extend("claude_code", {
            env = {
              CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "claude_code",
        },
        inline = {
          adapter = "copilot",
        },
      },
      display = {
        -- chat = {
        --   show_settings = true,
        -- },

        action_palette = {
          provider = "default",
        },

        diff = {
          provider = "mini_diff",
        },
      },
      prompt_library = {
        -- https://github.com/olimorris/codecompanion.nvim/blob/main/doc/RECIPES.md
        ["Code review"] = {
          strategy = "chat",
          description = "Code review",
          opts = {
            short_name = "review",
          },
          prompts = {
            {
              role = "system",
              content = [[Analyze the code for:

### CODE QUALITY
* Function and variable naming (clarity and consistency)
* Code organization and structure
* Documentation and comments
* Consistent formatting and style

### RELIABILITY
* Error handling and edge cases
* Resource management
* Input validation

### MAINTAINABILITY
* Code duplication (but don't overdo it with DRY, some duplication is fine)
* Single responsibility principle
* Modularity and dependencies
* API design and interfaces
* Configuration management

### PERFORMANCE
* Algorithmic efficiency
* Resource usage
* Caching opportunities
* Memory management

### SECURITY
* Input sanitization
* Authentication/authorization
* Data validation
* Known vulnerability patterns

### TESTING
* Unit test coverage
* Integration test needs
* Edge case testing
* Error scenario coverage

### POSITIVE HIGHLIGHTS
* Note any well-implemented patterns
* Highlight good practices found
* Commend effective solutions

Format findings as markdown and with:
- Issue: [description]
- Impact: [specific impact]
- Suggestion: [concrete improvement with code example/suggestion]

              ]],
            },
            {
              role = "user",
              content = "Please review provided code.\n" .. "#buffer #lsp",
            },
          },
        },
        ["With Context Files"] = {
          strategy = "chat",
          description = "Chat with context files",
          opts = {
            short_name = "context",
          },
          prompts = {
            {
              role = "user",
              opts = { contains_code = true },
              content = function(context)
                local ctx = require("contextfiles.extensions.codecompanion")

                local ctx_opts = {
                  -- ...
                }
                local format_opts = {
                  -- ...
                }

                return ctx.get(context.filename, ctx_opts, format_opts)
              end,
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>ai",
        require("r4zen.utils").create_input_cmd_visual_callback("CodeCompanion"),
        desc = "Codecompanion: Inline assistant",
        mode = { "n", "v" },
      },
      { "<leader>aa", ":CodeCompanionChat adapter=auggie<CR>", desc = "Codecompanion: Auggie" },
      { "<leader>ac", ":CodeCompanionChat adapter=claude_code<CR>", desc = "Codecompanion: Claude Code" },
      -- Should be enabled in Github Copilot settings
      -- { "<leader>aC", ":CodeCompanionChat adapter=copilot<CR>", desc = "Codecompanion: Copilot (Claude)" },
      { "<leader>ag", ":CodeCompanionChat adapter=openrouter_grok<CR>", desc = "Codecompanion: Grok 4.1 Fast" },
      -- { "<leader>af", ":lua require('codecompanion').prompt('context')<CR>", desc = "Codecompanion: With Context Files" },
      { "<leader>at", ":CodeCompanionChat Toggle<CR>", desc = "Codecompanion: toggle" },
    },
  },
}
