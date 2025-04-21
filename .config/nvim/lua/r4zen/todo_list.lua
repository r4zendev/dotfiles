local api = vim.api
local map = vim.keymap.set
local autocmd = api.nvim_create_autocmd

local M = {}
local todo_win_id = nil

local function float_win_config()
  local width = math.min(math.floor(vim.o.columns * 0.8), 100)
  local height = math.floor(vim.o.lines * 0.8)

  return {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = 2,
    border = "single",
  }
end

local function ensure_and_open_todo_window(filepath)
  local path = vim.fn.expand(filepath)

  if not path or vim.fn.filereadable(path) == 0 then
    vim.notify("File does not exist: " .. filepath, vim.log.levels.ERROR)
    return
  end

  local buf = vim.fn.bufadd(path)

  if not vim.fn.bufloaded(buf) then
    api.nvim_buf_call(buf, function()
      vim.cmd("edit " .. vim.fn.fnameescape(path))
    end)
  end

  vim.bo[buf].buflisted = false

  todo_win_id = api.nvim_open_win(buf, true, float_win_config())

  local augroup = api.nvim_create_augroup("TodoWindowGroup" .. todo_win_id, { clear = true })

  autocmd("BufEnter", {
    group = augroup,
    callback = function()
      if api.nvim_get_current_win() == todo_win_id then
        map("n", "q", function()
          if api.nvim_win_is_valid(todo_win_id) then
            api.nvim_win_close(todo_win_id, true)
            todo_win_id = nil
          end
          pcall(api.nvim_del_augroup_by_id, augroup)
        end, { buffer = 0, silent = true, noremap = true, desc = "Close Todo Window" })
      end
    end,
  })

  autocmd("WinClosed", {
    group = augroup,
    pattern = tostring(todo_win_id),
    callback = function()
      todo_win_id = nil
      pcall(api.nvim_del_augroup_by_id, augroup)
    end,
    once = true,
  })

  map("n", "q", function()
    if api.nvim_win_is_valid(todo_win_id) then
      api.nvim_win_close(todo_win_id, true)
      todo_win_id = nil
    end
    pcall(api.nvim_del_augroup_by_id, augroup)
  end, { buffer = 0, silent = true, noremap = true, desc = "Close Todo Window" })
end

local function toggle_todo_window(filepath)
  if todo_win_id and api.nvim_win_is_valid(todo_win_id) then
    api.nvim_win_close(todo_win_id, true)
    todo_win_id = nil
  else
    ensure_and_open_todo_window(filepath)
  end
end

local function setup_user_commands(opts)
  if not opts or not opts.target_file then
    vim.notify("Todo plugin setup error: 'target_file' option is missing.", vim.log.levels.ERROR)
    return
  end

  local final_filepath = vim.fn.expand(opts.target_file)
  if vim.fn.filereadable(final_filepath) == 0 then
    vim.notify("Todo file not found or not readable: " .. final_filepath, vim.log.levels.ERROR)
    return
  end

  api.nvim_create_user_command("Td", function()
    toggle_todo_window(final_filepath)
  end, {})

  M.target_file = final_filepath
end

local function setup_keymaps()
  map("n", "<leader>td", function()
    if M.target_file then
      toggle_todo_window(M.target_file)
    else
      vim.notify("Todo target file not configured", vim.log.levels.ERROR)
    end
  end, { desc = "Toggle Todo List", silent = true })
end

M.setup = function(opts)
  setup_user_commands(opts)
  setup_keymaps()
end

return M
