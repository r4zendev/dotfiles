return {
  dir = "~/projects/nova.nvim",
  event = "InsertEnter",
  cmd = { "NovaEnable", "NovaDisable", "NovaToggle", "NovaClearCache", "NovaStats" },
  opts = {
    provider = "llamacpp",

    providers = {
      llamacpp = {
        endpoint = "http://127.0.0.1:8012/infill",
      },

      -- Cloud providers (use with: provider = "cerebras")
      cerebras = {
        adapter = "openai_chat",
        endpoint = "https://api.cerebras.ai/v1/chat/completions",
        api_key_env = "CEREBRAS_API_KEY",
        model = "llama-3.3-70b",
        timeout = 30,
        debounce = 150,
        speculative_prefetch = false,
        max_tokens = 128,
        temperature = 0,
      },

      deepseek_fim = {
        adapter = "openai_fim",
        endpoint = "https://api.deepseek.com/beta/completions",
        api_key_env = "DEEPSEEK_API_KEY",
        model = "deepseek-chat",
        timeout = 30,
        debounce = 150,
        speculative_prefetch = false,
        max_tokens = 128,
        temperature = 0,
        fim_tokens = {
          prefix = "<|fim_prefix|>",
          suffix = "<|fim_suffix|>",
          middle = "<|fim_middle|>",
        },
      },
    },

    context = {
      prefix_lines = 256,
      suffix_lines = 64,
      max_tokens = 128,
    },

    ring = {
      enabled = true,
      max_chunks = 8,
      chunk_size = 32,
    },

    vectorcode = { enabled = false },

    debounce = 80,
    auto_trigger = true,
    ghost_text = true,
    speculative_prefetch = true,

    keymaps = {
      accept = "<Tab>",
      accept_line = "<S-Tab>",
      dismiss = "<C-]>",
    },

    ignore_filetypes = { "oil", "qf", "help" },
  },
  init = function()
    vim.g.nova_debug = false
  end,
}
