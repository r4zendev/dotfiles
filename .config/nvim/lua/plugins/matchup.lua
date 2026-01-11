return {
  "andymass/vim-matchup",
  event = "LazyFile",
  opts = {},
  init = function()
    vim.g.loaded_matchparen = 1
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    vim.g.matchup_matchparen_enabled = 1
    vim.g.matchup_motion_enabled = 1
    vim.g.matchup_text_obj_enabled = 0
    vim.g.matchup_surround_enabled = 1
  end,
}
