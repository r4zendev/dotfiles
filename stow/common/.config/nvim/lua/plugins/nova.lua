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

      cerebras = {
        adapter = "openai_chat",
        endpoint = "https://api.cerebras.ai/v1/chat/completions",
        api_key_env = "CEREBRAS_API_KEY",
        model = "qwen-3-32b",
        debounce = 150,
        speculative_prefetch = false,
        max_tokens = 128,
      },

      deepseek_fim = {
        adapter = "openai_fim",
        endpoint = "https://api.deepseek.com/beta/completions",
        api_key_env = "DEEPSEEK_API_KEY",
        model = "deepseek-chat",
        native_fim = true,
        debounce = 150,
        speculative_prefetch = false,
        max_tokens = 128,
        max_prefix_chars = 4000,
        max_suffix_chars = 1000,
      },
    },

    ring = {
      enabled = true,
      max_chunks = 8,
      chunk_size = 32,
    },

    ignore_filetypes = { "oil", "qf", "help" },
  },
  init = function()
    vim.g.nova_debug = false
  end,
}
