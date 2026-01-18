local parsers = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "css",
  "dockerfile",
  "fish",
  "gitignore",
  "go",
  "graphql",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "kdl",
  "lua",
  "markdown",
  "markdown_inline",
  "prisma",
  "query",
  "rust",
  "svelte",
  "tmux",
  "tsx",
  "typescript",
  "vim",
  "yaml",
  "zig",
}

local treesitter_fts = vim.tbl_extend("force", parsers, {
  "javascriptreact",
  "typescriptreact",
  "sh",
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- lazy = false,
    event = "LazyFile",
    build = ":TSUpdate",
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/treesitter",
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      require("nvim-treesitter").install(parsers)
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = treesitter_fts,
        callback = function()
          vim.treesitter.start()
        end,
      })

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
          ["config"] = function(path, bufnr)
            if path:match("ghostty/config$") then
              return "ghostty"
            end
          end,
        },
        pattern = {
          [".env.*"] = "sh",
        },
      })
    end,
  },
  {
    "bezhermoso/tree-sitter-ghostty",
    event = "LazyFile",
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
      opts = {
        enable_close_on_slash = true,
      },
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
