return {
  {
    "stevearc/overseer.nvim",
    pin = true,
    event = "VeryLazy",
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
      -- Override built-in npm (loads ALL workspaces which is slow for large monorepos)
      -- Remove to use the default behavior, currently using only cwd pkg + root
      disable_template_modules = { "overseer.template.npm" },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      local uv = vim.uv or vim.loop
      local files = require("overseer.files")

      -- For all workspaces, remove "overseer.template.npm" from disable_template_modules
      overseer.register_template({
        name = "npm",
        priority = 60,
        generator = function(search_opts)
          local root_pkg = vim.fs.find("package.json", { upward = true, path = vim.fn.getcwd() })[1]
          if not root_pkg or root_pkg:match("node_modules") then
            return "No package.json found"
          end

          local root_dir = vim.fs.dirname(root_pkg)
          local bin = (uv.fs_stat(root_dir .. "/pnpm-lock.yaml") and "pnpm")
            or (uv.fs_stat(root_dir .. "/yarn.lock") and "yarn")
            or ((uv.fs_stat(root_dir .. "/bun.lockb") or uv.fs_stat(root_dir .. "/bun.lock")) and "bun")
            or "npm"

          local ret = {}
          local function add_scripts(pkg_path, prefix)
            local dir, data = vim.fs.dirname(pkg_path), files.load_json_file(pkg_path)
            for k in pairs((data and data.scripts) or {}) do
              table.insert(ret, {
                name = ("%s%s %s (%s)"):format(bin, prefix, k, data.name or "root"),
                builder = function()
                  return { cmd = { bin, "run", k }, cwd = dir }
                end,
              })
            end
          end

          add_scripts(root_pkg, "")

          local current_pkg = vim.fs.find("package.json", { upward = true, path = search_opts.dir, stop = root_dir })[1]
          if current_pkg and vim.fs.dirname(current_pkg) ~= root_dir then
            add_scripts(current_pkg, "[ws] ")
          end

          return ret
        end,
      })

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
