local gemini_prompt = [[
You are the backend of an AI-powered code completion engine. Your task is to
provide code suggestions based on the user's input. The user's code will be
enclosed in markers:

- `<contextAfterCursor>`: Code context after the cursor
- `<cursorPosition>`: Current cursor location
- `<contextBeforeCursor>`: Code context before the cursor
]]

local gemini_few_shots = {}

gemini_few_shots[1] = {
  role = "user",
  content = [[
# language: python
<contextBeforeCursor>
def fibonacci(n):
    <cursorPosition>
<contextAfterCursor>

fib(5)]],
}

local gemini_chat_input_template =
  "{{{language}}}\n{{{tab}}}\n<contextBeforeCursor>\n{{{context_before_cursor}}}<cursorPosition>\n<contextAfterCursor>\n{{{context_after_cursor}}}"

return {
  "milanglacier/minuet-ai.nvim",
  event = "LazyFile",
  opts = function()
    gemini_few_shots[2] = require("minuet.config").default_few_shots[2]

    return {
      provider = "gemini",
      notify = "error",
      request_timeout = 2,
      throttle = 2000,
      -- blink = {
      --   enable_auto_complete = true,
      -- },
      virtualtext = {
        auto_trigger_ft = { "*" },
        -- auto_trigger_ignore_ft = {},
        keymap = {
          -- remapped in `init`
          accept = false,
          accept_line = "<C-l>",
          -- accept n lines (prompts for number)
          -- e.g. "C-w 2 CR" will accept 2 lines
          accept_n_lines = "<C-w>",
          prev = "[[",
          next = "]]",
        },
        show_on_completion_menu = true,
      },
      provider_options = {
        codestral = {
          optional = {
            stop = { "\n\n" },
            max_tokens = 256,
          },
        },
        gemini = {
          model = "gemini-2.0-flash",
          api_key = "GEMINI_API_KEY",
          system = {
            prompt = gemini_prompt,
          },
          few_shots = gemini_few_shots,
          chat_input = {
            template = gemini_chat_input_template,
          },
          optional = {
            generationConfig = {
              maxOutputTokens = 256,
              topP = 0.9,
            },
            safetySettings = {
              { category = "HARM_CATEGORY_DANGEROUS_CONTENT", threshold = "BLOCK_NONE" },
              { category = "HARM_CATEGORY_HATE_SPEECH", threshold = "BLOCK_NONE" },
              { category = "HARM_CATEGORY_HARASSMENT", threshold = "BLOCK_NONE" },
              { category = "HARM_CATEGORY_SEXUALLY_EXPLICIT", threshold = "BLOCK_NONE" },
            },
          },
        },
        openai = {
          model = "gpt-4o-mini",
          api_key = "OPENAI_API_KEY",
          optional = {
            max_tokens = 256,
            top_p = 0.9,
          },
        },
        openai_fim_compatible = {
          model = "deepseek-chat",
          end_point = "https://api.deepseek.com/beta/completions",
          api_key = "DEEPSEEK_API_KEY",
          -- template = {
          --   prompt = "See [Prompt Section for default value]",
          --   suffix = "See [Prompt Section for default value]",
          -- },
          optional = {
            stop = { "\n\n" },
            max_tokens = 256,
          },
        },
        -- openai_compatible = {
        --   api_key = "OPENROUTER_API_KEY",
        --   end_point = "https://openrouter.ai/api/v1/chat/completions",
        --   model = "meta-llama/llama-3.3-70b-instruct",
        --   name = "Openrouter",
        --   optional = {
        --     max_tokens = 128,
        --     top_p = 0.9,
        --     provider = {
        --       -- Prioritize throughput for faster completion
        --       sort = "throughput",
        --     },
        --   },
        -- },
      },
    }
  end,
  init = function()
    vim.keymap.set("i", "<Tab>", function()
      local virtual_text = require("minuet.virtualtext").action

      if virtual_text.is_visible() then
        virtual_text.accept()
        return
      end

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end, { silent = true })
  end,
}
