return {
  {
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
        "zig",
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
  },
  {
    "bezhermoso/tree-sitter-ghostty",
    event = "VeryLazy",
    build = "make nvim_install",
  },
  {
    "folke/ts-comments.nvim",
    version = "*",
    ft = { "html", "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {
      -- Can be enabled to close tags on </
      -- Conflicts with my custom ftplugin for tsx files to close self-closing JSX tags (e.g. <Component />)
      -- opts = {
      --   enable_close_on_slash = true,
      -- },
    },
  },
  {
    "andymass/vim-matchup",
    event = "LazyFile",
    init = function()
      vim.g.loaded_matchparen = 1
      vim.g.matchup_matchparen_enabled = 1

      vim.g.matchup_motion_enabled = 1
      vim.g.matchup_text_obj_enabled = 0
      vim.g.matchup_surround_enabled = 1

      -- This is the only way to make matchparen work but fallback to default nvim hl
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          local enabled = { "rust", "zig" }
          vim.b.matchup_matchparen_enabled = vim.tbl_contains(enabled, vim.bo.filetype)
        end,
      })
    end,
  },
}
