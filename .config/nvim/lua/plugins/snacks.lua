local M = {}

M.plugin = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    styles = {
      notification_history = {
        wo = { wrap = true },
      },
    },
    picker = {
      matcher = { frecency = true },
      sources = {
        files = { hidden = true, ignored = true },
        smart = { hidden = true },
        grep = { hidden = true },
        grep_word = { hidden = true },
        git_status = { untracked = true },
        recent = { hidden = true },
        explorer = {
          hidden = true,
          ignored = true,
          layout = {
            layout = { position = "right" },
          },
          win = {
            list = {
              keys = {
                -- Use o for picking a window to open the file in
                ["o"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header", padding = 2 },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
      preset = {
        -- stylua: ignore
        keys = {
          { icon = " ", key = "f", desc = "Find Files", action = ":lua Snacks.dashboard.pick('smart', { hidden = true })" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep', { hidden = true })" },
          { icon = " ", key = "d", desc = "View Diff", action = ":CodeDiff" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣡⣾⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣟⠻⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡿⢫⣷⣿⣿⣿⣿⣿⣿⣿⣾⣯⣿⡿⢧⡚⢷⣌⣽⣿⣿⣿⣿⣿⣶⡌⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣇⣘⠿⢹⣿⣿⣿⣿⣿⣻⢿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⡟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣻⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡇⠀⣬⠏⣿⡇⢻⣿⣿⣿⣿⣿⣿⣿⣷⣼⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⠀⠈⠁⠀⣿⡇⠘⡟⣿⣿⣿⣿⣿⣿⣿⣿⡏⠿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣇⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡏⠀⠀⠐⠀⢻⣇⠀⠀⠹⣿⣿⣿⣿⣿⣿⣩⡶⠼⠟⠻⠞⣿⡈⠻⣟⢻⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢿⠀⡆⠀⠘⢿⢻⡿⣿⣧⣷⢣⣶⡃⢀⣾⡆⡋⣧⠙⢿⣿⣿⣟⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⡥⠂⡐⠀⠁⠑⣾⣿⣿⣾⣿⣿⣿⡿⣷⣷⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿
⣿⣿⡿⣿⣍⡴⠆⠀⠀⠀⠀⠀⠀⠀⠀⣼⣄⣀⣷⡄⣙⢿⣿⣿⣿⣿⣯⣶⣿⣿⢟⣾⣿⣿⢡⣿⣿⣿⣿⣿
⣿⡏⣾⣿⣿⣿⣷⣦⠀⠀⠀⢀⡀⠀⠀⠠⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣡⣾⣿⣿⢏⣾⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡴⠀⠀⠀⠀⠀⠠⠀⠰⣿⣿⣿⣷⣿⠿⠿⣿⣿⣭⡶⣫⠔⢻⢿⢇⣾⣿⣿⣿⣿⣿⣿
⣿⣿⣿⡿⢫⣽⠟⣋⠀⠀⠀⠀⣶⣦⠀⠀⠀⠈⠻⣿⣿⣿⣾⣿⣿⣿⣿⡿⣣⣿⣿⢸⣾⣿⣿⣿⣿⣿⣿⣿
⡿⠛⣹⣶⣶⣶⣾⣿⣷⣦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⡿⠫⠾⠿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⡆⣠⢀⣴⣏⡀⠀⠀⠀⠉⠀⠀⢀⣠⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠿⠛⠛⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣯⣟⠷⢷⣿⡿⠋⠀⠀⠀⠀⣵⡀⢠⡿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⢿⣿⣿⠂⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⣿⣿⣍⠛⠿⣿⣿⣿⣿⣿⣿]],
      },
    },
    rename = { enabled = true },
    bigfile = { enabled = true },
    image = { enabled = false },
    input = { enabled = true },
    notifier = {
      enabled = true,
      top_down = false,
      style = "fancy", -- "compact" | "minimal" | "fancy"
    },
    indent = {
      enabled = true,
      indent = {
        only_scope = true,
      },
    },
    statuscolumn = {
      enabled = true,
      -- left = { "mark", "fold", "sign" },
      -- right = { "git" },
      left = { "mark", "fold" },
      right = {},
      folds = {
        open = true,
        git_hl = true,
      },
      git = {
        -- patterns = { "GitSign", "MiniDiffSign" },
        patterns = { "MiniDiffSign" },
      },
      refresh = 50,
    },
  },
  -- stylua: ignore
  keys = {
    -- NOTE: Files
    { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>.", function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find in directory" },
    { "<leader>ee", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<C-b>", function() Snacks.picker.buffers() end, desc = "Find Buffer" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Buffer" },
    { "<leader>ff", function() Snacks.picker.recent() end, desc = "Find Recent Files" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = os.getenv("HOME") .. "/projects/r4zendotdev/dotfiles" }) end, desc = "Find Under Dotfiles" },
    { "<leader>fF", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },

    -- NOTE: Grep
    { "<leader>,", function() Snacks.picker.grep() end, desc = "Grep", mode = { "n" } },
    { "<leader>/", function() Snacks.picker.grep({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Grep in directory" },
    { "<leader>,", function() Snacks.picker.grep_word() end, desc = "Grep", mode = { "x" } },
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Open Buffers" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },

    -- NOTE: Git
    { "<leader>gm", function() M.grep_git_files() end, desc = "Grep Git Files" },
    { "<leader>gf", function() Snacks.picker.git_status() end, desc = "Find Git Files" },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>g\\", function() Snacks.picker.git_log() end, desc = "Git Log" },

    -- NOTE: Search
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    {
      "<leader>su",
      function()
        Snacks.picker.undo({
          on_show = function ()
            vim.cmd.stopinsert()
          end
        })
      end,
      desc = "Undo History"
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps({
          on_show = function ()
            vim.cmd.stopinsert()
          end
        })
      end,
      desc = "Jumps"
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.highlights({
          confirm = function(picker, item)
            picker:close()
            if item then
              vim.fn.setreg("+", item.text)
            end
          end,
        })
      end,
      desc = "Highlights"
    },
    { "<leader>sH", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>sn", function() Snacks.picker.files({ cwd = "~/notes" }) end, desc = "Grep Notes" },
    { "<leader>sN", function() Snacks.picker.grep({ cwd = "~/notes" }) end, desc = "Search Notes" },

    -- NOTE: LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "Calls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "Calls Outgoing" },
    -- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

    -- NOTE: Colorscheme
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

    -- NOTE: Notifier / messages
    { '<leader>cc', function() Snacks.notifier.hide() end, desc = "Notifications history" },
    { '<leader>ch', function() Snacks.notifier.show_history() end, desc = "Notifications history" },
    { '<leader>cm', function()
      Snacks.win({
        style = "notification_history",
        text = vim.split(vim.fn.execute('messages'), '\n'),
        title = " Messages ",
        ft = "messages",
      })
    end, desc = "Messages" },

    -- NOTE: Misc
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search history" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Command List" },

  },
  init = function(plugin)
    require("which-key").add({
      { "<leader>s", group = "Search", icon = { icon = "󰍉", color = "green" } },
    })

    -- Fix for C-o working from dashboard on first try (requires two presses without this)
    if plugin.opts.dashboard.enabled then
      local id
      id = vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          vim.schedule(function()
            if vim.bo.filetype == "snacks_dashboard" then
              vim.keymap.set("n", "<C-o>", function()
                vim.cmd("normal! `0")
              end, { buffer = true })

              vim.api.nvim_del_autocmd(id)
            end
          end)
        end,
      })
    end

    if plugin.opts.notifier.enabled then
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), "info", {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
              notif.msg = ev.data.params.value.kind == "end" and "Workspace loaded" or notif.msg
            end,
            timeout = 1000,
          })
        end,
      })
    end

    -- AI completion toggle. Putting it here, since using multiple providers
    -- First, check if enabled by default to omit toggling disabled tools
    --
    -- Kills lazy loading:
    -- -- stylua: ignore start
    -- local is_minuet_enabled = pcall(require, "minuet")
    --   and (vim.g.minuet_enabled == nil or vim.g.minuet_enabled)
    -- local is_copilot_enabled = pcall(require, "copilot")
    --   and (vim.g.copilot_enabled == nil or vim.g.copilot_enabled)
    -- -- stylua: ignore end

    vim.g.copilot_enabled = true
    vim.g.minuet_enabled = false

    local is_minuet_enabled = vim.g.minuet_enabled == nil or vim.g.minuet_enabled
    local is_copilot_enabled = vim.g.copilot_enabled == nil or vim.g.copilot_enabled

    vim.g.enable_ai_completion = true
    vim.schedule(function()
      Snacks.toggle({
        name = "AI Completion",
        get = function()
          return vim.g.enable_ai_completion
        end,
        set = function(state)
          vim.g.enable_ai_completion = state

          -- Minuet
          if is_minuet_enabled then
            vim.cmd([[Minuet virtualtext toggle]])
            vim.g.minuet_enabled = state
          end

          -- Copilot
          if is_copilot_enabled then
            vim.cmd("silent! Copilot" .. (state and " enable" or " disable"))
            vim.g.copilot_enabled = state
          end
        end,
      }):map("<leader>a-")

      vim.g.statuscolumn_show_signs = true
      Snacks.toggle({
        name = "Statuscolumn Signs",
        get = function()
          return vim.g.statuscolumn_show_signs
        end,
        set = function(state)
          vim.g.statuscolumn_show_signs = state
        end,
      }):map("<leader>us")

      Snacks.picker.actions.git_branch_del = M.git_branch_del
    end)
  end,
}

-- https://github.com/folke/snacks.nvim/blob/main/lua/snacks/picker/actions.lua#L392
function M.git_branch_del(picker, item)
  if not (item and item.branch) then
    Snacks.notify.warn("No branch or commit found", { title = "Snacks Picker" })
  end

  local branch = item.branch
  Snacks.picker.util.cmd({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, function(data)
    -- Check if we are on the same branch
    if data[1]:match(branch) ~= nil then
      Snacks.notify.error("Cannot delete the current branch.", { title = "Snacks Picker" })
      return
    end

    Snacks.picker.select(
      { "Yes", "No" },
      { prompt = ("Delete branch %q?"):format(branch) },
      function(_, idx)
        if idx == 1 then
          -- Proceed with deletion
          -- NOTE: Modified only here to force delete the branch using the -D flag.
          Snacks.picker.util.cmd({ "git", "branch", "-D", branch }, function()
            Snacks.notify("Deleted Branch `" .. branch .. "`", { title = "Snacks Picker" })
            vim.cmd.checktime()
            picker.list:set_selected()
            picker.list:set_target()
            picker:find()
          end, { cwd = picker:cwd() })
        end
      end
    )
  end, { cwd = picker:cwd() })
end

function M.grep_git_files()
  local files = {}
  local git_root = nil

  local git_root_job = require("plenary.job"):new({
    command = "git",
    args = { "rev-parse", "--show-toplevel" },
    on_exit = function(job)
      local result = job:result()
      if result and #result > 0 then
        git_root = result[1]
      end
    end,
  })

  git_root_job:sync()
  if not git_root or #git_root == 0 then
    vim.notify("Could not find git root", vim.log.levels.ERROR)
    return
  end

  -- Staged files (added/modified and staged for commit)
  require("plenary.job")
    :new({
      command = "git",
      args = { "diff", "--cached", "--name-only" },
      cwd = git_root,
      on_stdout = function(_, line)
        if line and #line > 0 then
          files[line] = true
        end
      end,
    })
    :sync()

  -- Modified but unstaged files
  require("plenary.job")
    :new({
      command = "git",
      args = { "diff", "--name-only" },
      cwd = git_root,
      on_stdout = function(_, line)
        if line and #line > 0 then
          files[line] = true
        end
      end,
    })
    :sync()

  -- Untracked files
  -- require("plenary.job")
  --   :new({
  --     command = "git",
  --     args = { "ls-files", "--others", "--exclude-standard" },
  --     cwd = git_root,
  --     on_stdout = function(_, line)
  --       if line and #line > 0 then
  --         files[line] = true
  --       end
  --     end,
  --   })
  --   :sync()

  local file_list = {}
  for file, _ in pairs(files) do
    table.insert(file_list, file)
  end

  if #file_list == 0 then
    vim.notify("No git files found", vim.log.levels.INFO)
    return
  end

  local args = {}
  for _, file in ipairs(file_list) do
    table.insert(args, "--glob")
    table.insert(args, file)
  end

  Snacks.picker.grep({
    title = "Grep in Git Files",
    need_search = true,
    args = args,
    cwd = git_root,
  })
end

return M.plugin
