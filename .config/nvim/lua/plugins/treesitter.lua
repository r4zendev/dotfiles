return {
  "nvim-treesitter/nvim-treesitter",
  event = "LazyFile",
  build = ":TSUpdate",
  opts = {
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      -- additional_vim_regex_highlighting = {
      --   "just",
      -- },

      -- disable = function(lang, bufnr)
      --   local HIGHLIGHTING_DISABLED = {
      --     -- treesitter language, not ft
      --     "javascript",
      --     "tsx",
      --     "sh",
      --   }
      --
      --   if vim.tbl_contains(HIGHLIGHTING_DISABLED, lang) then
      --     vim.b[bufnr].ts_highlight = {
      --       enabled = false,
      --       reason = "blacklisted",
      --     }
      --     return false
      --   end
      --
      --   vim.b[bufnr].ts_highlight = {
      --     enabled = true,
      --     reason = "default",
      --   }
      --   return true
      -- end,
    },
    indent = { enable = true },
    matchup = { enable = true },
    ensure_installed = {
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "jsdoc",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "rust",
      "go",
      "c",
      "cpp",
      "cmake",
      "fish",
      "tmux",
      "kdl",
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
  main = "nvim-treesitter.configs",
  keys = {
    {
      "<leader>ut",
      function()
        vim.cmd("TSDisable highlight")
        vim.defer_fn(function()
          vim.cmd("TSEnable highlight")
        end, 150)
      end,
      desc = "Toggle Treesitter",
    },
  },
  init = function()
    vim.filetype.add({
      extension = {
        mdc = "markdown",
        kbd = "lisp",
        conf = "conf",
        tiltfile = "tiltfile",
        Tiltfile = "tiltfile",
      },
      filename = {
        ["tsconfig.json"] = "jsonc",
        [".yamlfmt"] = "yaml",
      },
      pattern = {
        [".env.*"] = "sh",
      },
    })
  end,
}
