return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  opts = {
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    -- enable indentation
    indent = { enable = true },
    -- ensure these language parsers are installed
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
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.filetype.add({ extension = { mdc = "markdown" } })
  end,
}
