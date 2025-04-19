return {
  cmd = { "typos-lsp" },
  root_markers = { "typos.toml", "_typos.toml", ".typos.toml", "pyproject.toml", "Cargo.toml" },
  settings = {
    cmd_env = { RUST_LOG = "error" },
    init_options = {
      -- Equivalent to the typos `--config` cli argument.
      config = "~/.config/nvim/_typos.toml",
      -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
      diagnosticSeverity = "Hint",
    },
  },
}
