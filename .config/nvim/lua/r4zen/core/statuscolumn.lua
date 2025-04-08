local M = {}

function M.fold_column()
  local lnum = vim.v.lnum
  local fold_level = vim.fn.foldlevel(lnum)
  local fold_closed = vim.fn.foldclosed(lnum)

  -- If line is part of a fold
  if fold_level > 0 then
    -- If this line starts a fold and the fold is closed
    if fold_closed == lnum then
      return vim.opt.fillchars:get().foldclose
    -- If this line starts a fold and the fold is open
    elseif fold_level > vim.fn.foldlevel(lnum - 1) then
      return vim.opt.fillchars:get().foldopen
    end
  end

  -- Return empty space for all other cases
  return " "
end

return M
