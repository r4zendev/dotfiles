return {
  "nvim-treesitter/nvim-treesitter",
  event = "LazyFile",
  build = ":TSUpdate",
  opts = {
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      disable = function(lang, bufnr)
        local disabled_filetypes = { "tmux" }
        local disabled_langs = {}
        local ft = vim.bo[bufnr].filetype

        if vim.tbl_contains(disabled_filetypes, ft) or vim.tbl_contains(disabled_langs, lang) then
          return true
        end

        -- Disable for large files
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_filesize then
          return true
        end

        return false
      end,
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
