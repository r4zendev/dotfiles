local supported_adapters = {
  copilot = function()
    return require("codecompanion.adapters").extend("copilot", {
      schema = {
        model = {
          default = "claude-3.7-sonnet",
        },
      },
    })
  end,
  gemini = function()
    return require("codecompanion.adapters").extend("gemini", {
      schema = {
        model = {
          default = "gemini-2.5-pro-exp-03-25",
        },
      },
      env = {
        api_key = "GEMINI_API_KEY",
      },
    })
  end,
  gemini_flash = function()
    return require("codecompanion.adapters").extend("gemini", {
      schema = {
        model = {
          default = "models/gemini-2.0-flash",
        },
      },
      env = {
        api_key = "GEMINI_API_KEY",
      },
    })
  end,
  openrouter_o3mini = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      env = {
        url = "https://openrouter.ai/api",
        api_key = "OPENROUTER_API_KEY",
        chat_url = "/v1/chat/completions",
      },
      schema = {
        model = {
          default = "openai/o3-mini-high",
        },
      },
    })
  end,
  openrouter_claude = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      env = {
        url = "https://openrouter.ai/api",
        api_key = "OPENROUTER_API_KEY",
        chat_url = "/v1/chat/completions",
      },
      schema = {
        model = {
          default = "anthropic/claude-3.7-sonnet",
        },
      },
    })
  end,
  openrouter_deepseek_r1 = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      env = {
        url = "https://openrouter.ai/api",
        api_key = "OPENROUTER_API_KEY",
        chat_url = "/v1/chat/completions",
      },
      schema = {
        model = {
          default = "deepseek/deepseek-r1:free",
        },
      },
    })
  end,
}

return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "MCPHub",
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    opts = {
      port = 3333,
      config = vim.fn.expand("~/.config/mcpservers.json"),

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
    config = function(_, opts)
      local root_dir = require("r4zen.utils").workspace_root()
      if root_dir ~= nil then
        -- Set the environment variable before loading the config
        -- Used by MCP servers that require project's root path as an argument
        vim.fn.setenv("MCP_PROJECT_ROOT_PATH", root_dir)
      end

      require("mcphub").setup(opts)
    end,
  },
  { "banjo/contextfiles.nvim", lazy = true },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = supported_adapters,
      strategies = {
        chat = {
          tools = {
            ["mcp"] = {
              -- calling it in a function would prevent mcphub from being loaded before it's needed
              callback = function()
                return require("mcphub.extensions.codecompanion")
              end,
              description = "Call tools and resources from the MCP Servers",
              opts = { requires_approval = true },
            },
          },

          slash_commands = {
            ["file"] = {
              opts = {
                provider = "snacks",
                contains_code = true,
              },
            },

            ["buffer"] = {
              opts = {
                provider = "snacks",
              },
            },

            ["help"] = {
              opts = {
                provider = "snacks",
              },
            },

            ["symbols"] = {
              opts = {
                provider = "snacks",
              },
            },
          },

          adapter = "copilot",
        },

        inline = {
          adapter = "copilot",
        },
      },
      display = {
        chat = {
          show_settings = true,
        },

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
    keys = {
      { "<leader>ac", ":CodeCompanionChat copilot<CR>", desc = "Codecompanion: Copilot (Claude)" },
      {
        "<leader>aC",
        ":lua require('codecompanion').prompt('context')<CR>",
        desc = "Codecompanion: With Context Files",
      },
      { "<leader>ag", ":CodeCompanionChat gemini_flash<CR>", desc = "Codecompanion: Gemini Flash" },
      { "<leader>aG", ":CodeCompanionChat gemini<CR>", desc = "Codecompanion: Gemini" },
      { "<leader>aa", ":CodeCompanionChat openrouter_claude<CR>", desc = "Codecompanion: Claude 3.7" },
      { "<leader>ad", ":CodeCompanionChat openrouter_deepseek_r1<CR>", desc = "Codecompanion: DeepSeek R1" },
      { "<leader>ao", ":CodeCompanionChat openrouter_o3mini<CR>", desc = "Codecompanion: OpenAI o3-mini" },

      { "<leader>at", ":CodeCompanionChat Toggle<CR>", desc = "Codecompanion: toggle" },
      {
        "<leader>aS",
        function()
          local name = vim.fn.input("Save as: ")
          if name and name ~= "" then
            vim.cmd("CodeCompanionSave " .. name)
          end
        end,
        desc = "Codecompanion: Save chat",
      },
      { "<leader>aL", ":CodeCompanionLoad<CR>", desc = "Codecompanion: Load chat" },
      { "<leader>aP", ":CodeCompanionActions<CR>", desc = "Codecompanion: Prompts" },
    },
    init = function()
      -- Initialize storage for CodeCompanion chats
      local Path = require("plenary.path")
      local save_folder = Path:new(vim.fn.stdpath("data"), "codecompanion_chats")

      -- Ensure the save directory exists
      if not save_folder:exists() then
        save_folder:mkdir({ parents = true })
      end

      -----------------------------------------------------------
      -- Chat Management Functions
      -----------------------------------------------------------

      -- Common utility functions for codecompanion chat management
      local chat_utils = {}

      --- Check if the current buffer is a CodeCompanion chat
      --- @return table|nil chat The chat object if successful, nil otherwise
      function chat_utils.get_current_chat()
        local codecompanion = require("codecompanion")
        local success, chat = pcall(function()
          return codecompanion.buf_get_chat(0)
        end)

        if not success or chat == nil then
          return nil
        end
        return chat
      end

      --- Load chat content into a CodeCompanion window
      --- @param file_path string Path to the chat file
      function chat_utils.load_content(file_path)
        local codecompanion = require("codecompanion")
        local chat_content = Path:new(file_path):read()

        -- Get current CodeCompanion window or open a new one
        local current_win = vim.api.nvim_get_current_win()
        local current_buf = vim.api.nvim_win_get_buf(current_win)
        local success, chat = pcall(function()
          return codecompanion.buf_get_chat(current_buf)
        end)

        if not success or chat == nil then
          -- Not in a CodeCompanion window, open a new one
          vim.cmd("CodeCompanionChat")
          -- Wait a moment for the buffer to initialize
          vim.defer_fn(function()
            local lines = vim.split(chat_content, "\n")
            vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
          end, 100)
        else
          -- Already in a CodeCompanion window
          local lines = vim.split(chat_content, "\n")
          vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)
        end
      end

      --- Get all saved chat files
      --- @return table List of file paths
      function chat_utils.get_saved_chats()
        return vim.fn.glob(save_folder:absolute() .. "/*.md", false, true)
      end

      --- Delete a chat file
      --- @param file_path string Path to the chat file to delete
      --- @return boolean success Whether the deletion was successful
      function chat_utils.delete_chat(file_path)
        local file_name = vim.fn.fnamemodify(file_path, ":t:r")
        local success, err = pcall(function()
          os.remove(file_path)
        end)

        if success then
          vim.notify("Deleted: " .. file_name, vim.log.levels.INFO)
          return true
        else
          vim.notify("Failed to delete: " .. file_name .. " (" .. err .. ")", vim.log.levels.ERROR)
          return false
        end
      end

      --- Display the chat selection UI
      --- @param is_delete_mode boolean Whether the UI is in delete mode
      function chat_utils.show_selection_ui(is_delete_mode)
        local files = chat_utils.get_saved_chats()

        if #files == 0 then
          vim.notify("No saved chats found", vim.log.levels.INFO)
          return
        end

        local chat_items = {}
        local file_paths = {}

        -- Add chats to the selection list
        for _, file_path in ipairs(files) do
          local file_name = vim.fn.fnamemodify(file_path, ":t:r")

          if is_delete_mode then
            table.insert(chat_items, "DELETE: " .. file_name)
          else
            table.insert(chat_items, file_name)
          end

          table.insert(file_paths, file_path)
        end

        -- Add manage/back option at the bottom
        if is_delete_mode then
          table.insert(chat_items, "== BACK TO CHAT LIST ==")
          table.insert(file_paths, "back")
        else
          table.insert(chat_items, "== MANAGE SAVED CHATS ==")
          table.insert(file_paths, "manage")
        end

        local prompt_text = is_delete_mode and "SELECT CHAT TO DELETE" or "CodeCompanion Saved Chats"

        -- Show the selection menu
        vim.ui.select(chat_items, {
          prompt = prompt_text,
        }, function(choice, idx)
          if not choice then
            return
          end

          if is_delete_mode then
            -- Handle delete mode selections
            if choice == "== BACK TO CHAT LIST ==" then
              chat_utils.show_selection_ui(false)
            else
              -- Delete the selected chat
              local file_path = file_paths[idx]
              chat_utils.delete_chat(file_path)

              -- Return to delete mode if there are still files
              local remaining = chat_utils.get_saved_chats()
              if #remaining > 0 then
                chat_utils.show_selection_ui(true)
              else
                vim.notify("No more saved chats", vim.log.levels.INFO)
              end
            end
          else
            -- Handle regular mode selections
            if choice == "== MANAGE SAVED CHATS ==" then
              chat_utils.show_selection_ui(true)
            else
              -- Load the selected chat
              chat_utils.load_content(file_paths[idx])
            end
          end
        end)
      end

      -----------------------------------------------------------
      -- User Commands
      -----------------------------------------------------------

      -- Command to load saved chats
      vim.api.nvim_create_user_command("CodeCompanionLoad", function()
        chat_utils.show_selection_ui(false)
      end, {})

      -- Command to save current chat
      -- Usage: CodeCompanionSave foo bar baz -> saves as 'foo-bar-baz.md'
      vim.api.nvim_create_user_command("CodeCompanionSave", function(opts)
        local chat = chat_utils.get_current_chat()

        if not chat then
          vim.notify("CodeCompanionSave should only be called from CodeCompanion chat buffers", vim.log.levels.ERROR)
          return
        end

        if #opts.fargs == 0 then
          vim.notify("CodeCompanionSave requires at least 1 arg to make a file name", vim.log.levels.ERROR)
          return
        end

        local save_name = table.concat(opts.fargs, "-") .. ".md"
        local save_path = Path:new(save_folder, save_name)
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        save_path:write(table.concat(lines, "\n"), "w")
        vim.notify("Chat saved as: " .. save_name, vim.log.levels.INFO)
      end, { nargs = "*" })
    end,
  },
}
