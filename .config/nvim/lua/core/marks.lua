-- Borrowed from https://github.com/lewis6991/dotfiles/blob/0071d6f1a97f8f6080eb592c4838d92f77901e84/config/nvim/lua/gizmos/marksigns.lua ; https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/marks.lua

local ns = vim.api.nvim_create_namespace("r4zen/marks")
local map = vim.keymap.set

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
    -- Only enable mark signs for buffers with a filename.
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

-- Mark deletion
map("n", "dm", function()
  local char = vim.fn.getcharstr()

  if char == " " or char == "<leader>" then
    -- Delete all marks in buffer (including uppercase/global marks)
    local bufnr = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(bufnr)

    -- Delete local marks (a-z)
    local local_marks = {}
    for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
      if mark.mark:match("^'[a-z]$") then
        table.insert(local_marks, mark.mark:sub(2))
      end
    end

    -- Delete global marks (A-Z) that point to current buffer
    local global_marks = {}
    for _, mark in ipairs(vim.fn.getmarklist()) do
      if mark.mark:match("^'[A-Z]$") then
        local mark_file = vim.fn.fnamemodify(mark.file, ":p")
        if current_file == mark_file then
          table.insert(global_marks, mark.mark:sub(2))
        end
      end
    end

    -- Delete all collected marks
    local all_marks = vim.list_extend(local_marks, global_marks)
    if #all_marks > 0 then
      vim.cmd("delmarks " .. table.concat(all_marks, " "))
      vim.notify("Deleted " .. #all_marks .. " marks in buffer")
    else
      vim.notify("No marks to delete")
    end

    -- Redraw all windows if global marks were deleted
    if #global_marks > 0 then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.api.nvim__redraw({ win = win, range = { 0, -1 } })
      end
    else
      vim.api.nvim__redraw({ range = { 0, -1 } })
    end
  else
    -- Delete specific mark
    if char:match("[a-zA-Z]") then
      vim.cmd("delmarks " .. char)
      vim.notify("Deleted mark '" .. char .. "'")

      -- Redraw appropriately based on mark type
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
