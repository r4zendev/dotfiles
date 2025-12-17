local M = {}

function M.fold_column()
  local lnum = vim.v.lnum
  local fold_level = vim.fn.foldlevel(lnum)
  local fold_closed = vim.fn.foldclosed(lnum)
  local fold_icon = " "

  if fold_level > 0 then
    if fold_closed == lnum then
      fold_icon = vim.opt.fillchars:get().foldclose or "+"
    elseif fold_level > vim.fn.foldlevel(lnum - 1) then
      fold_icon = vim.opt.fillchars:get().foldopen or "-"
    end
  end

  return fold_icon
end

function M.gitsigns_column()
  -- Skip virtual lines
  if vim.v.virtnum ~= 0 then
    return " "
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local status = vim.b[bufnr].gitsigns_status_dict

  if not status then
    return " "
  end

  -- Get gitsigns extmarks for the current line
  local gitsigns_ns = vim.api.nvim_create_namespace("gitsigns_signs_")
  local extmarks = vim.api.nvim_buf_get_extmarks(
    bufnr,
    gitsigns_ns,
    { vim.v.lnum - 1, 0 },
    { vim.v.lnum - 1, -1 },
    { details = true }
  )

  if #extmarks > 0 then
    local sign_hl = extmarks[1][4].sign_hl_group
    local sign_text = extmarks[1][4].sign_text

    if sign_hl and sign_text then
      -- Trim any trailing spaces from the sign text
      sign_text = sign_text:match("^(.-)%s*$")
      return "%#" .. sign_hl .. "#" .. sign_text .. "%*"
    end
  end

  return " "
end

function M.line_or_diagnostic()
  local line = vim.v.lnum - 1
  local bufnr = vim.api.nvim_get_current_buf()

  local line_count = vim.api.nvim_buf_line_count(0)
  -- Number area width (just for the number itself)
  local num_width = math.max(3, #tostring(line_count))

  if vim.v.virtnum > 0 then
    local show_signs = vim.g.statuscolumn_show_signs ~= false
    local extra = show_signs and 2 or 0
    return string.rep(" ", num_width + extra)
  end

  -- Get git and fold signs (both always 1 char each)
  local show_signs = vim.g.statuscolumn_show_signs ~= false
  local git = show_signs and M.gitsigns_column() or "" -- Returns " " or formatted sign
  local fold = show_signs and M.fold_column() or "" -- Always 1 char
  local prefix = git .. fold

  -- Check for marks first (they have priority)
  local marks_ns = vim.api.nvim_create_namespace("r4zen/marks")
  local marks = vim.api.nvim_buf_get_extmarks(bufnr, marks_ns, { line, 0 }, { line, -1 }, { details = true })

  if #marks > 0 then
    -- Get the first mark on this line
    local mark = marks[1][4]

    if not mark then
      return ""
    end

    local sign = mark.sign_text or " "
    local hl_group = mark.sign_hl_group or "DiagnosticSignOk"

    local sign_width = vim.fn.strdisplaywidth(sign)
    local padding = string.rep(" ", num_width - sign_width)
    return prefix .. "%#" .. hl_group .. "#" .. padding .. sign .. "%*"
  end

  -- If no marks, check diagnostics
  local diagnostics = vim.diagnostic.get(0, { lnum = line })

  local diagnostic_icons = require("icons").diagnostics
  local signs = {
    [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
    [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
    [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
    [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
  }

  local hl_groups = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
    [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
    [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
  }

  if #diagnostics > 0 then
    local max_severity = vim.diagnostic.severity.HINT
    for _, diagnostic in ipairs(diagnostics) do
      if diagnostic.severity < max_severity then
        max_severity = diagnostic.severity
      end
    end

    local sign = signs[max_severity] or " "
    local hl_group = hl_groups[max_severity] or "Normal"

    local sign_width = vim.fn.strdisplaywidth(sign)
    local padding = string.rep(" ", num_width - sign_width)
    return prefix .. "%#" .. hl_group .. "#" .. padding .. sign .. "%*"
  else
    local num = vim.v.relnum ~= 0 and vim.v.relnum or vim.v.lnum
    local num_str = tostring(num)
    local hl_group = vim.v.relnum == 0 and "CursorLineNr" or "LineNr"
    local padding = string.rep(" ", num_width - #num_str)

    return prefix .. "%#" .. hl_group .. "#" .. padding .. num_str .. "%*"
  end
end

function M.get_statuscolumn()
  local line_diag = M.line_or_diagnostic()
  return line_diag .. " "
end

return M
