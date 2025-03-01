local utils = require("r4zen.utils")

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- opts = ,
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      -- winopts = {
      -- 	height = 0.25,
      -- 	width = 0.4,
      -- 	row = 0.5,
      -- 	preview = { hidden = "hidden" },
      -- 	border = "rounded",
      -- 	treesitter = { enabled = true },
      -- },
      fzf_opts = {
        ["--no-info"] = "",
        ["--info"] = "hidden",
        ["--padding"] = "13%,5%,13%,5%",
        ["--header"] = " ",
        ["--no-scrollbar"] = "",
      },
      files = {
        formatter = "path.filename_first",
        git_icons = false,
        prompt = ":",
        no_header = true,
        cwd_header = false,
        cwd_prompt = false,
        cwd = utils.git_root(),
        winopts = {
          title = " files 📑 ",
          title_pos = "center",
          title_flags = false,
        },
      },
      buffers = {
        formatter = "path.filename_first",
        prompt = ":",
        no_header = true,
        fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
        winopts = {
          title = " buffers 📝 ",
          title_pos = "center",
        },
      },
      helptags = {
        prompt = ":",
        winopts = {
          title = " help 💡 ",
          title_pos = "center",
          width = 0.8,
          height = 0.6,
          preview = {
            hidden = "nohidden",
            horizontal = "down:40%",
          },
        },
      },
      git = {
        branches = {
          prompt = ":",
          cmd = "git branch -a --format='%(refname:short)'",
          no_header = true,
          winopts = {
            title = " branches  ",
            title_pos = "center",
            preview = { hidden = "hidden" },
          },
          actions = {
            ["ctrl-d"] = {
              fn = function(selected)
                vim.cmd.DiffviewOpen({ args = { selected[1] } })
              end,
              desc = "diffview-git-branch",
            },
          },
        },
      },
      lsp = {
        symbols = {
          cwd_only = true,
          no_header = true,
          regex_filter = function(item)
            if utils.is_in_list(item.kind, { "Variable", "String", "Number", "Text", "Boolean" }) then
              return false
            else
              return true
            end
          end,
          prompt = ":",
          winopts = {
            title = " symbols ✨ ",
            title_pos = "center",
            width = 0.8,
            height = 0.6,
            preview = {
              hidden = "nohidden",
              horizontal = "down:40%",
              wrap = "wrap",
            },
          },
          symbol_fmt = function(s)
            return s .. ":"
          end,
          symbol_style = 2,
          child_prefix = false,
        },
      },
      autocmds = {
        prompt = ":",
        winopts = {
          title = " autocommands ",
          title_pos = "center",
          width = 0.8,
          height = 0.6,
          preview = {
            hidden = "nohidden",
            layout = "horizontal",
            horizontal = "down:40%",
            wrap = "wrap",
          },
        },
      },
      keymaps = {
        prompt = ":",
        winopts = {
          title = " keymaps ",
          title_pos = "center",
          width = 0.8,
          height = 0.6,
          preview = {
            hidden = "nohidden",
            layout = "horizontal",
            horizontal = "down:40%",
          },
        },
        actions = {
          ["default"] = {
            fn = function(selected)
              local lines = vim.split(selected[1], "│", {})
              local mode, key = lines[1]:gsub("%s+", ""), lines[2]:gsub("%s+", "")
              vim.cmd("verbose " .. mode .. "map " .. key)
            end,
            desc = "print-keymap-location",
          },
        },
      },
      highlights = {
        prompt = ":",
        winopts = {
          title = " highlights 🎨 ",
          title_pos = "center",
          width = 0.8,
          height = 0.6,
          preview = {
            hidden = "nohidden",
            layout = "horizontal",
            horizontal = "down:40%",
            wrap = "wrap",
          },
        },
      },
      registers = {
        prompt = "registers:",
        filter = "%a",
        winopts = {
          title = " registers 🏷️ ",
          title_pos = "center",
          width = 0.8,
        },
      },
    })

    vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua<cr>", { desc = "open fzf picker" })
    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "fzf files in cwd" })
    vim.keymap.set("n", "<C-p>", fzf.files, { desc = "fzf files in cwd" })
    vim.keymap.set("n", "<leader>hh", fzf.help_tags, { desc = "fzf help" })
    vim.keymap.set("n", "<leader>fg", function()
      if utils.git_root() ~= nil then
        fzf.git_branches()
      else
        vim.notify("not a git repository", vim.log.levels.WARN)
      end
    end, { desc = "fzf git branches" })
    vim.keymap.set("n", "<C-m>", function()
      vim.ui.input({ prompt = "search symbol: " }, function(sym)
        if not sym or sym == "" then
          return
        end
        fzf.lsp_workspace_symbols({ lsp_query = sym })
      end)
    end, { desc = "fzf workspace symbols" })
    vim.keymap.set("n", "gm", fzf.lsp_document_symbols, { desc = "fzf document symbols" })

    local opts = { noremap = true, silent = true }

    opts.desc = "fzf lsp references"
    vim.keymap.set("n", "gR", fzf.lsp_references, opts)

    opts.desc = "fzf lsp definitions"
    vim.keymap.set("n", "gd", fzf.lsp_definitions, opts)

    opts.desc = "fzf lsp implementations"
    vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)

    opts.desc = "fzf lsp type definitions"
    vim.keymap.set("n", "gt", fzf.lsp_typedefs, opts)

    opts.desc = "fzf lsp diagnostics for buffer"
    vim.keymap.set("n", "<leader>D", fzf.lsp_document_diagnostics, opts)

    --   {
    --     '""',
    --     function()
    --       fzf.registers()
    --     end,
    --     desc = "fzf show registers",
    --   },
  end,
}
