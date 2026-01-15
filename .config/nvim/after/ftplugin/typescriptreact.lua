-- Incompatible with windwp/nvim-ts-autotag when opts.enable_close_on_slash is true
-- Can do a workaround but it's still buggy so I just disabled it
vim.keymap.set("i", "/", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local char_before = line:sub(col - 1, col - 1)

  -- typing </ or fragment, just insert /
  if char_before == "<" then
    return "/"
  end

  -- self-closing tag
  local node = vim.treesitter.get_node()
  if node and node:type() == "jsx_opening_element" then
    local space_before = char_before == " "
    return space_before and "/>" or " />"
  end

  return "/"
end, { expr = true, buffer = true })
