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
      env = {
        api_key = "GEMINI_API_KEY",
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

local function save_path()
  local Path = require("plenary.path")
  local p = Path:new(vim.fn.stdpath("data") .. "/codecompanion_chats")
  p:mkdir({ parents = true })
  return p
end

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = supported_adapters,
    strategies = {
      chat = {
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
    },
  },
  keys = {
    { "<leader>ac", ":CodeCompanionChat copilot<CR>", desc = "Codecompanion: Copilot (Claude)" },
    { "<leader>ag", ":CodeCompanionChat gemini<CR>", desc = "Codecompanion: Gemini" },
    { "<leader>aa", ":CodeCompanionChat openrouter_claude<CR>", desc = "Codecompanion: Claude 3.7" },
    { "<leader>ad", ":CodeCompanionChat openrouter_deepseek_r1<CR>", desc = "Codecompanion: DeepSeek R1" },

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
    --- Load a saved codecompanion.nvim chat file into a new CodeCompanion chat buffer.
    --- Usage: CodeCompanionLoad
    vim.api.nvim_create_user_command("CodeCompanionLoad", function()
      local Snacks = require("snacks")

      local function select_adapter(filepath)
        local adapters = vim.tbl_keys(supported_adapters)

        Snacks.picker(adapters, {
          prompt = "Select CodeCompanion Adapter> ",
          actions = {
            ["default"] = function(selected)
              local adapter = selected[1]
              -- Open new CodeCompanion chat with selected adapter
              vim.cmd("CodeCompanionChat " .. adapter)

              -- Read contents of saved chat file
              local lines = vim.fn.readfile(filepath)

              -- Get the current buffer (which should be the new CodeCompanion chat)
              local current_buf = vim.api.nvim_get_current_buf()

              -- Paste contents into the new chat buffer
              vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)
            end,
          },
        })
      end

      local function start_picker()
        local files = vim.fn.glob(save_path() .. "/*", false, true)

        Snacks.picker(files, {
          prompt = "Saved CodeCompanion Chats | <c-r>: remove >",
          previewer = "builtin",
          actions = {
            ["default"] = function(selected)
              if #selected > 0 then
                local filepath = selected[1]
                select_adapter(filepath)
              end
            end,
            ["ctrl-r"] = function(selected)
              if #selected > 0 then
                local filepath = selected[1]
                os.remove(filepath)
                -- Refresh the picker
                start_picker()
              end
            end,
          },
        })
      end

      start_picker()
    end, {})

    --- Save the current codecompanion.nvim chat buffer to a file in the save_folder.
    --- Usage: CodeCompanionSave <filename>.md
    ---@param opts table
    vim.api.nvim_create_user_command("CodeCompanionSave", function(opts)
      local codecompanion = require("codecompanion")
      local success, chat = pcall(function()
        return codecompanion.buf_get_chat(0)
      end)
      if not success or chat == nil then
        vim.notify("CodeCompanionSave should only be called from CodeCompanion chat buffers", vim.log.levels.ERROR)
        return
      end
      if #opts.fargs == 0 then
        vim.notify("CodeCompanionSave requires at least 1 arg to make a file name", vim.log.levels.ERROR)
      end
      local save_name = table.concat(opts.fargs, "-") .. ".md"
      local save_file = save_path():joinpath(save_name)
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      save_file:write(table.concat(lines, "\n"), "w")
    end, { nargs = "*" })
  end,
}
