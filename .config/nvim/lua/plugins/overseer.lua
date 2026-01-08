return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerTaskList", "OverseerInfo" },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer run" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer toggle" },
      { "<leader>ol", "<cmd>OverseerTaskAction<cr>", desc = "Overseer task action" },

      { "<leader>b", desc = "Build" },
      { "<leader>q", desc = "Quickfix" },
    },
    opts = {
      strategy = "terminal",
      templates = { "builtin", "user" },
      task_list = { direction = "bottom", min_height = 10, max_height = 20, default_detail = 1 },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      local uv = vim.uv or vim.loop

      local function exists(p)
        return uv.fs_stat(p) ~= nil
      end

      local function open_quickfix()
        local ok, quicker = pcall(require, "quicker")
        if ok and quicker then
          if quicker.open then
            return quicker.open({ focus = true })
          end
          if quicker.toggle then
            return quicker.toggle({ focus = true })
          end
        end
        vim.cmd("copen")
        vim.cmd("wincmd p")
      end

      local function toggle_quickfix()
        local ok, quicker = pcall(require, "quicker")
        if ok and quicker and quicker.toggle then
          return quicker.toggle()
        end
        if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
          vim.cmd("cclose")
        else
          vim.cmd("copen")
        end
      end

      local function run(name, params)
        vim.fn.setqflist({})
        overseer.run_task(vim.tbl_extend("force", { name = name }, params or {}), function(task)
          if not task then
            return
          end
          task:subscribe("on_complete", function()
            local qf = vim.fn.getqflist({ size = 0 })
            if (qf.size or 0) > 0 then
              open_quickfix()
            end
          end)
        end)
      end

      local function smart_build()
        local r = require("utils").workspace_root()

        if exists(r .. "/Cargo.toml") then
          return run("cargo build")
        end
        if exists(r .. "/build.zig") then
          return run("zig build")
        end
        if exists(r .. "/tsconfig.json") or exists(r .. "/package.json") then
          return run("tsc")
        end

        local ft = vim.bo.filetype
        if ft == "c" then
          return run("gcc build")
        end
        if ft == "cpp" then
          return run("c++ build")
        end

        vim.notify("No build mapping for " .. ft, vim.log.levels.WARN)
      end

      vim.keymap.set("n", "<leader>b", smart_build, { desc = "Build" })
      vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Quickfix" })
    end,
  },
}
