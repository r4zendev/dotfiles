-- Cool harpoon-like view for buffers if don't want to deal with marks
-- Easily replaced by snacks buffers picker
return {
  "mistweaverco/bafa.nvim",
  event = "LazyFile",
  keys = {
    {
      "<c-b>",
      function()
        require("bafa.ui").toggle()
      end,
      desc = "Bafa",
    },
  },
  opts = {
    width = 60,
    height = 10,
    title = "Bafa",
    title_pos = "center",
    relative = "editor",
    border = "rounded",
    style = "minimal",
    diagnostics = true,
    modified_hl = "DiffChanged",
  },
}
