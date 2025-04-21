local M = {}

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
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("edit " .. vim.fn.fnameescape(path))
    end)
  end

  vim.bo[buf].buflisted = false

  vim.api.nvim_open_win(buf, true, float_win_config())

  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "q",
    "<cmd>close<CR>",
    { silent = true, noremap = true, desc = "Close Todo Window" }
  )
end

local function setup_user_commands(opts)
  if not opts or not opts.target_file then
    vim.notify("Todo plugin setup error: 'target_file' option is missing.", vim.log.levels.ERROR)
    return
  end

  local final_filepath = vim.fn.expand(opts.target_file)
  if vim.fn.filereadable(final_filepath) == 0 then
    vim.notify("Todo file not found or not readable: " .. final_filepath, vim.log.levels.ERROR)
    return -- Stop setup if file is invalid
  end

  vim.api.nvim_create_user_command("Td", function()
    local buf = vim.fn.bufadd(final_filepath)
    local existing_win = nil

    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == buf then
        local config = vim.api.nvim_win_get_config(winid)
        if config.relative ~= "" then
          existing_win = winid
          break
        end
      end
    end

    if existing_win then
      vim.api.nvim_win_close(existing_win, true) -- 'true' forces close without saving
    else
      ensure_and_open_todo_window(final_filepath)
    end
  end, {})
end

local function setup_keymaps()
  vim.keymap.set("n", "<leader>td", ":Td<CR>", { desc = "Todo List", silent = true })
end

M.setup = function(opts)
  setup_user_commands(opts)
  setup_keymaps()
end

return M
