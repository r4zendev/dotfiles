local M = {}

M.plugin = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
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
          { icon = " ", key = "d", desc = "View Diff", action = ":DiffviewOpen" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
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
  },
  -- stylua: ignore
  keys = {
    -- NOTE: Files
    { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>.", function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find in directory" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<leader>ff", function() Snacks.picker.recent() end, desc = "Find Recent Files" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = os.getenv("HOME") .. "/projects/r4zendotdev/dotfiles" }) end, desc = "Find Under Dotfiles" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },

    -- NOTE: Grep
    { "<leader>,", function() Snacks.picker.grep() end, desc = "Grep", mode = { "n" } },
    { "<leader>/", function() Snacks.picker.grep({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Grep in directory" },
    { "<leader>,", function() Snacks.picker.grep_word() end, desc = "Grep", mode = { "x" } },
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Open Buffers" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>st", function() Snacks.picker.grep({ search = "()TODO()|()FIXME()", }) end, desc = "Search TODOs" },
    { "<leader>sT", function() Snacks.picker.grep({ search = "()TODO()|()FIXME()|()HACK()|()NOTE()", }) end, desc = "Search All Notes" },

    -- NOTE: Git
    { "<leader>gg", function() M.grep_modified_files() end, desc = "Grep Git Files" },
    { "<leader>gf", function() Snacks.picker.git_status() end, desc = "Find Git Files" },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>g\\", function() Snacks.picker.git_log() end, desc = "Git Log" },

    -- NOTE: Search
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },

    -- NOTE: LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

    -- NOTE: Colorscheme
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

    -- NOTE: Misc
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search history" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Command History" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })

    -- AI completion toggle. Putting it here, since using multiple providers
    -- First, check if enabled by default to omit toggling disabled tools
    local is_augment_enabled_by_default = vim.g.augment_disable_completions == nil
      or not vim.g.augment_disable_completions
    local is_copilot_enabled_by_default = vim.g.copilot_enabled == nil or vim.g.copilot_enabled
    vim.g.enable_ai_completion = true
    vim.schedule(function()
      Snacks.toggle({
        name = "AI Completion",
        get = function()
          return vim.g.enable_ai_completion
        end,
        set = function(state)
          vim.g.enable_ai_completion = state

          -- Augment
          if is_augment_enabled_by_default then
            vim.g.augment_disable_completions = not state
            vim.g.augment_disable_tab_mapping = not state
          end

          -- Copilot
          if is_copilot_enabled_by_default then
            vim.g.copilot_enabled = state
          end
        end,
      }):map("<leader>a-")

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

    Snacks.picker.select({ "Yes", "No" }, { prompt = ("Delete branch %q?"):format(branch) }, function(_, idx)
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
    end)
  end, { cwd = picker:cwd() })
end

function M.grep_modified_files()
  local modified_files = {}
  require("plenary.job")
    :new({
      command = "git",
      args = { "diff", "--name-only" },
      on_stdout = function(_, line)
        if line and #line > 0 then
          table.insert(modified_files, line)
        end
      end,
    })
    :sync()

  if #modified_files == 0 then
    vim.notify("No modified files found", vim.log.levels.INFO)
    return
  end

  local args = {}
  for _, file in ipairs(modified_files) do
    table.insert(args, "--glob")
    table.insert(args, file)
  end

  Snacks.picker.grep({
    title = "Grep in Modified Files",
    need_search = true,
    args = args,
  })
end

return M.plugin
