local ns = vim.api.nvim_create_namespace("r4zen/marks")
local map = vim.keymap.set

local USE_UPPERCASE_FOR_LOWERCASE = true

---@param bufnr integer
---@param mark vim.fn.getmarklist.ret.item
local function decor_mark(bufnr, mark)
  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, mark.pos[2] - 1, 0, {
    sign_text = mark.mark:sub(2),
    sign_hl_group = "DiagnosticSignOk",
  })
end

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, bufnr, top_row, bot_row)
    if vim.api.nvim_buf_get_name(bufnr) == "" then
      return
    end

    vim.api.nvim_buf_clear_namespace(bufnr, ns, top_row, bot_row)

    local current_file = vim.api.nvim_buf_get_name(bufnr)

    -- Global marks
    for _, mark in ipairs(vim.fn.getmarklist()) do
      if mark.mark:match("^.[a-zA-Z]$") then
        local mark_file = vim.fn.fnamemodify(mark.file, ":p:a")
        if current_file == mark_file then
          decor_mark(bufnr, mark)
        end
      end
    end

    -- Local marks
    for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
      if mark.mark:match("^.[a-zA-Z]$") then
        decor_mark(bufnr, mark)
      end
    end
  end,
})

-- Redraw screen when marks are changed via `m` commands
vim.on_key(function(_, typed)
  if typed:sub(1, 1) ~= "m" then
    return
  end

  local mark = typed:sub(2)

  vim.schedule(function()
    if mark:match("[A-Z]") then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
      end
    else
      vim.api.nvim__redraw({ range = { 0, -1 } })
    end
  end)
end, ns)

map("n", "dm", function()
  local char = vim.fn.getcharstr()

  if USE_UPPERCASE_FOR_LOWERCASE and char:match("[a-z]") then
    char = char:upper()
  end

  if char == " " or char == "<leader>" then
    local all_marks = {}
    for _, mark in ipairs(vim.fn.getmarklist()) do
      if mark.mark:match("^'[A-Z]$") then
        table.insert(all_marks, mark.mark:sub(2))
      end
    end

    local bufnr = vim.api.nvim_get_current_buf()
    for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
      if mark.mark:match("^'[a-z]$") then
        table.insert(all_marks, mark.mark:sub(2))
      end
    end

    if #all_marks > 0 then
      vim.cmd("delmarks " .. table.concat(all_marks, " "))
      vim.notify("Deleted " .. #all_marks .. " marks")

      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
      end
    else
      vim.notify("No marks to delete")
    end
  else
    if char:match("[a-zA-Z]") then
      vim.cmd("delmarks " .. char)
      vim.notify("Deleted mark '" .. char .. "'")

      if char:match("[A-Z]") then
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
        end
      else
        vim.api.nvim__redraw({ range = { 0, -1 } })
      end
    else
      vim.notify("Invalid mark: " .. char, vim.log.levels.WARN)
    end
  end
end, { desc = "Delete mark" })

if USE_UPPERCASE_FOR_LOWERCASE then
  for char in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
    map("n", "m" .. char, "m" .. char:upper(), { desc = "Set mark " .. char:upper() })
  end

  for char in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
    map("n", "'" .. char, "'" .. char:upper(), { desc = "Jump to mark " .. char:upper() })
  end

  for char in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
    map(
      "n",
      "`" .. char,
      "`" .. char:upper(),
      { desc = "Jump to mark " .. char:upper() .. " (exact)" }
    )
  end
end

---@param filter_to_cwd boolean Whether to filter marks to current working directory
---@return table[] marks List of mark items
local function get_marks(filter_to_cwd)
  local marks = vim.fn.getmarklist()
  local current_buf = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(current_buf)
  local cwd = filter_to_cwd and vim.fn.getcwd() or nil

  local items = {}

  for _, mark in ipairs(marks) do
    local label = mark.mark:sub(2, 2)
    if label:match("[A-Z]") then
      local file = mark.file or bufname
      local buf = mark.pos[1] and mark.pos[1] > 0 and mark.pos[1] or nil
      local line_content = nil

      if buf and mark.pos[2] > 0 and vim.api.nvim_buf_is_valid(buf) then
        local success, lines =
          pcall(vim.api.nvim_buf_get_lines, buf, mark.pos[2] - 1, mark.pos[2], false)
        if success and lines[1] then
          line_content = lines[1]:gsub("^%s+", "") -- Trim leading whitespace
        end
      end

      local include = true
      if filter_to_cwd then
        local file_path = vim.fn.fnamemodify(file, ":p")
        include = file_path:find(cwd, 1, true) == 1
      end

      if include then
        table.insert(items, {
          label = label,
          file = file,
          buf = buf,
          line_content = line_content or "",
          pos = mark.pos[2] > 0 and { mark.pos[2], mark.pos[3] } or nil,
          is_builtin = false,
        })
      end
    end
  end

  return items
end

---@param filter_to_cwd boolean
---@return table[]
local function build_picker_items(filter_to_cwd)
  local marks = get_marks(filter_to_cwd)
  local picker_items = {}

  for _, mark in ipairs(marks) do
    local file_display = filter_to_cwd and vim.fn.fnamemodify(mark.file, ":~:.")
      or vim.fn.fnamemodify(mark.file, ":~")
    local text = string.format("[%s] %s %s", mark.label, file_display, mark.line_content)

    table.insert(picker_items, {
      text = text,
      label = mark.label,
      file = mark.file,
      pos = mark.pos,
      buf = mark.buf,
      line = mark.line_content,
    })
  end

  return picker_items
end

local function open_marks_picker_project()
  require("snacks").picker.pick({
    finder = function()
      return build_picker_items(true)
    end,
    prompt = "Marks (Project) ",
    format = "file",
    preview = "file",
    jump = { close = true },
    on_show = function()
      vim.cmd.stopinsert()
    end,
    confirm = function(picker, item)
      picker:close()
      if item and item.file then
        vim.schedule(function()
          vim.cmd("edit " .. vim.fn.fnameescape(item.file))
          if item.pos then
            vim.api.nvim_win_set_cursor(0, item.pos)
          end
        end)
      end
    end,
    actions = {
      delete = function(picker)
        local items = picker:selected({ fallback = true })
        local marks_to_delete = {}

        for _, item in ipairs(items) do
          table.insert(marks_to_delete, item.label)
        end

        if #marks_to_delete > 0 then
          vim.cmd("delmarks " .. table.concat(marks_to_delete, " "))
          vim.notify("Deleted marks: " .. table.concat(marks_to_delete, ", "))

          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
          end

          picker:refresh()
        end
      end,
      delete_all = function(picker)
        local marks = get_marks(true)
        local marks_to_delete = {}

        for _, mark in ipairs(marks) do
          table.insert(marks_to_delete, mark.label)
        end

        if #marks_to_delete > 0 then
          vim.cmd("delmarks " .. table.concat(marks_to_delete, " "))
          vim.notify("Deleted all marks in project")

          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
          end

          picker:refresh()
        end
      end,
    },
    win = {
      input = {
        keys = {
          ["<c-x>"] = "delete",
          ["<c-d>"] = "delete_all",
        },
      },
      list = {
        keys = {
          ["<c-x>"] = "delete",
          ["<c-d>"] = "delete_all",
        },
      },
    },
  })
end

local function open_marks_picker_all()
  require("snacks").picker.pick({
    finder = function()
      return build_picker_items(false)
    end,
    prompt = "Marks (All) ",
    format = "file",
    preview = "file",
    jump = { close = true },
    on_show = function()
      vim.cmd.stopinsert()
    end,
    confirm = function(picker, item)
      picker:close()
      if item and item.file then
        vim.schedule(function()
          vim.cmd("edit " .. vim.fn.fnameescape(item.file))
          if item.pos then
            vim.api.nvim_win_set_cursor(0, item.pos)
          end
        end)
      end
    end,
    actions = {
      delete = function(picker)
        local items = picker:selected({ fallback = true })
        local marks_to_delete = {}

        for _, item in ipairs(items) do
          table.insert(marks_to_delete, item.label)
        end

        if #marks_to_delete > 0 then
          vim.cmd("delmarks " .. table.concat(marks_to_delete, " "))
          vim.notify("Deleted marks: " .. table.concat(marks_to_delete, ", "))

          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
          end

          picker:refresh()
        end
      end,
      delete_all = function(picker)
        local marks = get_marks(false)
        local marks_to_delete = {}

        for _, mark in ipairs(marks) do
          table.insert(marks_to_delete, mark.label)
        end

        if #marks_to_delete > 0 then
          vim.cmd("delmarks " .. table.concat(marks_to_delete, " "))
          vim.notify("Deleted all marks")

          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
          end

          picker:refresh()
        end
      end,
    },
    win = {
      input = {
        keys = {
          ["<c-x>"] = "delete",
          ["<c-d>"] = "delete_all",
        },
      },
      list = {
        keys = {
          ["<c-x>"] = "delete",
          ["<c-d>"] = "delete_all",
        },
      },
    },
  })
end

map("n", "<leader>sm", open_marks_picker_project, { desc = "Marks (Project)" })
map("n", "<leader>sM", open_marks_picker_all, { desc = "Marks (All)" })
