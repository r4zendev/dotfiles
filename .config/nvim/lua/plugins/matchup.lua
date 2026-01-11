return {
  "andymass/vim-matchup",
  event = "LazyFile",
  init = function()
    vim.g.loaded_matchparen = 1
    vim.g.matchup_matchparen_enabled = 1

    vim.g.matchup_motion_enabled = 1
    vim.g.matchup_text_obj_enabled = 0
    vim.g.matchup_surround_enabled = 1

    -- This is the only way to make matchparen work but fallback to default nvim hl
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        local enabled = { "rust", "zig" }
        vim.b.matchup_matchparen_enabled = vim.tbl_contains(enabled, vim.bo.filetype)
      end,
    })
  end,
}
