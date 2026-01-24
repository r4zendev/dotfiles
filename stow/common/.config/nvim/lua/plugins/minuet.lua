return {
  "milanglacier/minuet-ai.nvim",
  cmd = "Minuet",
  event = "LazyFile",
  opts = function()
    local minuet_cfg = require("minuet.config")
    local has_vc, vc_config = pcall(require, "vectorcode.config")
    local vc_cacher = has_vc and vc_config.get_cacher_backend() or nil

    local function get_repo_context()
      if not vc_cacher then
        return ""
      end
      local files = vc_cacher.query_from_cache(0)
      if #files == 0 then
        return ""
      end
      local prompt = ""
      for _, file in ipairs(files) do
        prompt = prompt .. "<|file_sep|>" .. file.path .. "\n" .. file.document
      end
      return vim.fn.strcharpart(prompt, 0, 8000)
    end

    local qwen_fim = function(pref, suff, opts)
      local vc_ctx = get_repo_context()
      local file_ctx = opts and opts.filepath and ("<|file_sep|>" .. opts.filepath .. "\n") or ""
      return vc_ctx
        .. file_ctx
        .. "<|fim_prefix|>"
        .. pref
        .. "<|fim_suffix|>"
        .. suff
        .. "<|fim_middle|>"
    end

    local active_provider = "deepseek_fim"

    local providers = {
      -- llama-server -hf ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF --port 8012 -ngl 99 -fa -ub 1024 -b 1024 --ctx-size 0 --cache-reuse 256
      local_qwen = {
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 8192,
        throttle = 600,
        debounce = 200,
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM",
            end_point = "http://localhost:8012/v1/completions",
            model = "local",
            stream = true,
            name = "Qwen Local",
            optional = {
              max_tokens = 128,
              top_p = 0.9,
              temperature = 0.1,
            },
            template = {
              prompt = qwen_fim,
              suffix = false,
            },
          },
        },
      },

      -- FREE: zai-glm-4.6 (best for coding), gpt-oss-120b, qwen-3-235b-a22b-instruct-2507, qwen-3-32b, llama-3.3-70b, llama3.1-8b
      cerebras = {
        provider = "openai_compatible",
        provider_options = {
          openai_compatible = {
            api_key = "CEREBRAS_API_KEY",
            end_point = "https://api.cerebras.ai/v1/chat/completions",
            model = "zai-glm-4.6",
            stream = true,
            name = "Cerebras",
            optional = { max_tokens = 56, top_p = 0.9, temperature = 0.1 },
            system = minuet_cfg.default_system_prefix_first,
            chat_input = minuet_cfg.default_chat_input_prefix_first,
            few_shots = minuet_cfg.default_few_shots_prefix_first,
          },
        },
      },

      openrouter = {
        provider = "openai_compatible",
        provider_options = {
          openai_compatible = {
            api_key = "OPENROUTER_API_KEY",
            end_point = "https://openrouter.ai/api/v1/chat/completions",
            -- model = "mistralai/devstral-small", -- $0.06/M, cheap agentic coder
            -- model = "deepseek/deepseek-chat-v3.1", -- $0.15/M, excellent value
            -- model = "moonshotai/kimi-k2", -- $0.55/M, top open-source coder
            -- model = "qwen/qwen3-coder", -- $0.45/M, SOTA (use for complex tasks)
            model = "qwen/qwen-2.5-coder-32b-instruct", -- $0.07/M, solid coder
            stream = true,
            name = "OpenRouter",
            optional = { max_tokens = 56, top_p = 0.9, temperature = 0.1 },
            system = minuet_cfg.default_system_prefix_first,
            chat_input = minuet_cfg.default_chat_input_prefix_first,
            few_shots = minuet_cfg.default_few_shots_prefix_first,
          },
        },
      },

      deepseek_fim = {
        provider = "openai_fim_compatible",
        n_completions = 1,
        -- context_window = 16000,
        throttle = 600,
        debounce = 200,
        provider_options = {
          openai_fim_compatible = {
            api_key = "DEEPSEEK_API_KEY",
            end_point = "https://api.deepseek.com/beta/completions",
            model = "deepseek-chat",
            stream = true,
            name = "DeepSeek FIM",
            optional = {
              -- max_tokens = 128,
              max_tokens = 256,
              temperature = 0.1,
              stop = { "\n\n", "```" },
            },
            -- no custom template needed - it supports native suffix parameter
          },
        },
      },
    }

    return vim.tbl_deep_extend("force", {
      notify = "error",
      request_timeout = 3,
      throttle = 2000,
      debounce = 600,
      context_window = 4096,
      context_ratio = 0.80,
      n_completions = 2,
      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = {
          "snacks_picker_input",
          "oil",
          "qf",
        },
        keymap = {
          accept = false,
          accept_line = "<C-l>",
          accept_n_lines = "<C-w>",
          prev = "[[",
          next = "]]",
        },
        show_on_completion_menu = true,
      },
    }, providers[active_provider])
  end,
  config = function(_, opts)
    if not vim.g.minuet_enabled then
      vim.cmd([[silent! Minuet virtualtext disable]])
    end

    require("minuet").setup(opts)

    if vim.g.minuet_enabled then
      vim.keymap.set("i", "<Tab>", function()
        local vt = require("minuet.virtualtext").action
        if vt.is_visible() then
          vt.accept()
        else
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
            "n",
            false
          )
        end
      end, { silent = true })
    end
  end,
  init = function()
    local DEBUG = false
    if DEBUG then
      local log_file = "/tmp/minuet_debug.log"
      local function log(label, data)
        local f = io.open(log_file, "a")
        if f then
          f:write("\n" .. string.rep("=", 70) .. "\n")
          f:write("[" .. os.date("%H:%M:%S") .. "] " .. label .. "\n")
          f:write(string.rep("=", 70) .. "\n")
          if type(data) == "string" then
            f:write(data .. "\n")
          else
            f:write(vim.fn.json_encode(data) .. "\n")
          end
          f:close()
        end
      end
      -- Clear log on startup
      io.open(log_file, "w"):close()
      -- Intercept requests
      local utils = require("minuet.utils")
      local orig = utils.make_tmp_file
      utils.make_tmp_file = function(data)
        log("REQUEST", {
          model = data.model,
          prompt_len = data.prompt and #data.prompt or 0,
          suffix_len = data.suffix and #data.suffix or 0,
          max_tokens = data.max_tokens,
        })
        log("PROMPT", data.prompt or "(no prompt)")
        if data.suffix then
          log("SUFFIX", data.suffix)
        end
        if data.messages then
          log("MESSAGES", data.messages)
        end
        return orig(data)
      end
    end
  end,
}
