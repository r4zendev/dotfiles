local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local keymap = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap

return {
  "milanglacier/yarepl.nvim",
  event = "VeryLazy",
  lazy = vim.fn.argc(-1) == 0,
  config = function()
    local yarepl = require("yarepl")
    local aider = require("yarepl.extensions.aider")

    yarepl.setup({
      metas = {
        aider = aider.create_aider_meta(),
        python = false,
        R = false,
        shell = {
          cmd = vim.o.shell,
          wincmd = function(bufnr, name)
            vim.api.nvim_open_win(bufnr, true, {
              relative = "cursor",
              row = -4,
              col = -6,
              width = math.floor(vim.o.columns * 0.65),
              height = math.floor(vim.o.lines * 0.4),
              style = "minimal",
              title = name,
              border = "rounded",
              title_pos = "center",
            })
          end,
        },
      },
    })

    require("yarepl.extensions.code_cell").register_text_objects({
      {
        key = "c",
        start_pattern = "```.+",
        end_pattern = "^```$",
        ft = { "rmd", "quarto", "markdown" },
        desc = "markdown code cells",
      },
      {
        key = "<leader>c",
        start_pattern = "^# ?%%%%.*",
        end_pattern = "^# ?%%%%.*",
        ft = { "r", "python" },
        desc = "r/python code cells",
      },
      {
        key = "m",
        start_pattern = "# COMMAND ---",
        end_pattern = "# COMMAND ---",
        ft = { "r", "python" },
        desc = "databricks code cells",
      },
      {
        key = "m",
        start_pattern = "-- COMMAND ---",
        end_pattern = "-- COMMAND ---",
        ft = { "sql" },
        desc = "databricks code cells",
      },
    })
  end,
  init = function()
    -- ----- Set Aichat Keymap ------
    -- keymap("n", "<leader>cs", "<Plug>(REPLStart-aichat)", {
    --   desc = "Start an Aichat REPL",
    -- })
    -- keymap("n", "<leader>cf", "<Plug>(REPLFocus-aichat)", {
    --   desc = "Focus on Aichat REPL",
    -- })
    -- keymap("n", "<leader>ch", "<Plug>(REPLHide-aichat)", {
    --   desc = "Hide Aichat REPL",
    -- })
    -- keymap("v", "<leader>cr", "<Plug>(REPLSourceVisual-aichat)", {
    --   desc = "Send visual region to Aichat",
    -- })
    -- keymap("n", "<Leader>crr", "<Plug>(REPLSendLine-aichat)", {
    --   desc = "Send lines to Aichat",
    -- })
    -- keymap("n", "<leader>cr", "<Plug>(REPLSourceOperator-aichat)", {
    --   desc = "Send Operator to Aichat",
    -- })
    -- keymap("n", "<leader>ce", "<Plug>(REPLExec-aichat)", {
    --   desc = "Execute command in aichat",
    -- })
    -- keymap("n", "<leader>cq", "<Plug>(REPLClose-aichat)", {
    --   desc = "Quit Aichat",
    -- })
    -- keymap("n", "<leader>cc", "<CMD>REPLCleanup<CR>", {
    --   desc = "Clear aichat REPLs.",
    -- })

    keymap("n", "<leader>As", "<Plug>(REPLStart-aider)", {
      desc = "Start an aider REPL",
    })
    keymap("n", "<leader>Af", "<Plug>(REPLFocus-aider)", {
      desc = "Focus on aider REPL",
    })
    keymap("n", "<leader>Ah", "<Plug>(REPLHide-aider)", {
      desc = "Hide aider REPL",
    })
    keymap("v", "<leader>Ar", "<Plug>(REPLSendVisual-aider)", {
      desc = "Send visual region to aider",
    })
    keymap("n", "<leader>Arr", "<Plug>(REPLSendLine-aider)", {
      desc = "Send lines to aider",
    })
    keymap("n", "<leader>Ar", "<Plug>(REPLSendOperator-aider)", {
      desc = "Send Operator to aider",
    })

    -- special keymap from aider
    keymap("n", "<leader>Ae", "<Plug>(AiderExec)", {
      desc = "Execute command in aider",
    })
    keymap("n", "<leader>Ay", "<Plug>(AiderSendYes)", {
      desc = "Send y to aider",
    })
    keymap("n", "<leader>An", "<Plug>(AiderSendNo)", {
      desc = "Send n to aider",
    })
    keymap("n", "<leader>Aa", "<Plug>(AiderSendAbort)", {
      desc = "Send abort to aider",
    })
    keymap("n", "<leader>Aq", "<Plug>(AiderSendExit)", {
      desc = "Send exit to aider",
    })
    keymap("n", "<leader>Ama", "<Plug>(AiderSendAskMode)", {
      desc = "Switch aider to ask mode",
    })
    keymap("n", "<leader>Amc", "<Plug>(AiderSendCodeMode)", {
      desc = "Switch aider to code mode",
    })
    keymap("n", "<leader>AmC", "<Plug>(AiderSendContextMode)", {
      desc = "Switch aider to context mode",
    })
    keymap("n", "<leader>AmA", "<Plug>(AiderSendArchMode)", {
      desc = "Switch aider to architect mode",
    })
    keymap("n", "<leader>Ag", "<cmd>AiderSetPrefix<cr>", {
      desc = "Set aider prefix",
    })
    keymap("n", "<leader>AG", "<cmd>AiderRemovePrefix<cr>", {
      desc = "Remove aider prefix",
    })
    keymap("n", "<leader>A<space>", "<cmd>checktime<cr>", {
      desc = "Sync file changes by aider to nvim buffer",
    })

    ----- Set Shell Keymap ------
    keymap("n", "<leader>bt", "<Plug>(REPLStart-shell)", {
      desc = "Start or focus a shell",
    })
    keymap("n", "<leader>b1", "<Plug>(REPLFocus-shell)", {
      desc = "Focus on shell",
    })
    keymap("n", "<leader>b0", "<Plug>(REPLHide-shell)", {
      desc = "Hide shell REPL",
    })

    ----- Set Filetype Specific keymap -----
    local ft_to_repl = {
      r = "radian",
      R = "radian",
      rmd = "radian",
      quarto = "radian",
      markdown = "radian",
      python = "ipython",
      sh = "bash",
    }

    autocmd("FileType", {
      pattern = { "quarto", "markdown", "rmd", "python", "sh", "REPL", "r" },
      group = augroup("MyAugroup", {}),
      desc = "set up REPL keymap",
      callback = function()
        local repl = ft_to_repl[vim.bo.filetype]
        repl = repl and ("-" .. repl) or ""

        bufmap(0, "n", "<localleader>rs", string.format("<Plug>(REPLStart%s)", repl), {
          desc = "Start an REPL",
        })
        bufmap(0, "n", "<localleader>rf", "<Plug>(REPLFocus)", {
          desc = "Focus on REPL",
        })
        bufmap(0, "n", "<localleader>rv", "<CMD>FF repl_show<CR>", {
          desc = "View REPLs in telescope",
        })
        bufmap(0, "n", "<localleader>rh", "<Plug>(REPLHide)", {
          desc = "Hide REPL",
        })
        bufmap(0, "v", "<localleader>s", "<Plug>(REPLSourceVisual)", {
          desc = "Send visual region to REPL",
        })
        bufmap(0, "n", "<localleader>ss", "<Plug>(REPLSendLine)", {
          desc = "Send line to REPL",
        })
        bufmap(0, "n", "<localleader>s", "<Plug>(REPLSourceOperator)", {
          desc = "Send current line to REPL",
        })
        bufmap(0, "n", "<localleader>re", "<Plug>(REPLExec)", {
          desc = "Execute command in REPL",
        })
        bufmap(0, "n", "<localleader>rq", "<Plug>(REPLClose)", {
          desc = "Quit REPL",
        })
        bufmap(0, "n", "<localleader>rc", "<CMD>REPLCleanup<CR>", {
          desc = "Clear REPLs.",
        })
        bufmap(0, "n", "<localleader>rS", "<CMD>REPLSwap<CR>", {
          desc = "Swap REPLs.",
        })
        bufmap(0, "n", "<localleader>r?", "<Plug>(REPLStart)", {
          desc = "Start an REPL from available REPL metas",
        })
        bufmap(0, "n", "<localleader>ra", "<CMD>REPLAttachBufferToREPL<CR>", {
          desc = "Attach current buffer to a REPL",
        })
        bufmap(0, "n", "<localleader>rd", "<CMD>REPLDetachBufferToREPL<CR>", {
          desc = "Detach current buffer to any REPL",
        })

        local function send_a_code_chunk()
          local leader = vim.g.mapleader
          local localleader = vim.g.maplocalleader
          -- NOTE: in an expr mapping, <leader> and <localleader>
          -- cannot be translated. You must use their literal value
          -- in the returned string.

          if vim.bo.filetype == "r" or vim.bo.filetype == "python" then
            return localleader .. "si" .. leader .. "c"
          elseif vim.bo.filetype == "rmd" or vim.bo.filetype == "quarto" or vim.bo.filetype == "markdown" then
            return localleader .. "sic"
          end
        end

        bufmap(0, "n", "<localleader>sc", "", {
          desc = "send a code chunk",
          callback = send_a_code_chunk,
          expr = true,
        })
      end,
    })
  end,
}
