return {
  -- RuboCop was wired twice: ruby-lsp runs it from the bundle AND the
  -- standalone `rubocop` LSP ran it again, duplicating diagnostics. Disable
  -- the standalone LSP and let ruby-lsp own RuboCop diagnostics. Formatting is
  -- unaffected -- conform still formats Ruby with the rubocop binary.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rubocop = { enabled = false },
      },
    },
  },
}
