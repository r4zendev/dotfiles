return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  opts = {
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
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
  init = function()
    vim.filetype.add({ extension = { mdc = "markdown" } })
    vim.filetype.add({ extension = { kbd = "lisp" } })
  end,
  -- config = function(_, opts)
  --   require("nvim-treesitter.configs").setup(opts)
  --   local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  --   parser_config.kanata = {
  --     install_info = {
  --       url = "https://github.com/postsolar/tree-sitter-kanata",
  --       files = { "src/parser.c" },
  --       -- branch = "main",
  --       -- generate_requires_npm = false,
  --       -- requires_generate_from_grammar = false,
  --     },
  --     filetype = "kanata",
  --   }
  --
  --   vim.filetype.add({ extension = { kbd = "kanata" } })
  -- end,
}
