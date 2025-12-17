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

function M.line_or_diagnostic()
  local line = vim.v.lnum - 1
  local bufnr = vim.api.nvim_get_current_buf()

  local line_count = vim.api.nvim_buf_line_count(0)
  local width = math.max(3, #tostring(line_count))

  if vim.v.virtnum > 0 then
    return string.rep(" ", width)
  end

  -- Check for marks first (they have priority)
  local marks_ns = vim.api.nvim_create_namespace("r4zen/marks")
  local marks = vim.api.nvim_buf_get_extmarks(bufnr, marks_ns, { line, 0 }, { line, -1 }, { details = true })

  if #marks > 0 then
    -- Get the first mark on this line
    local mark = marks[1][4]
    local sign = mark.sign_text or " "
    local hl_group = mark.sign_hl_group or "DiagnosticSignOk"

    local sign_width = vim.fn.strdisplaywidth(sign)
    local padding = string.rep(" ", width - sign_width)
    return "%#" .. hl_group .. "#" .. padding .. sign .. "%*"
  end

  -- If no marks, check diagnostics
  local diagnostics = vim.diagnostic.get(0, { lnum = line })

  local signs = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.HINT] = "󰠠",
    [vim.diagnostic.severity.INFO] = "",
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

    local padding = string.rep(" ", width - sign_width)
    return "%#" .. hl_group .. "#" .. padding .. sign .. "%*"
  else
    local num = vim.v.relnum ~= 0 and vim.v.relnum or vim.v.lnum
    local num_str = tostring(num)
    local hl_group = vim.v.relnum == 0 and "CursorLineNr" or "LineNr"

    local padding = string.rep(" ", width - #num_str)
    return "%#" .. hl_group .. "#" .. padding .. num_str .. "%*"
  end
end

function M.get_statuscolumn()
  return M.fold_column() .. M.line_or_diagnostic() .. "  "
end

return M
