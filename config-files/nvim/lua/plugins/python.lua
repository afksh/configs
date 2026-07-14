return {
  -- Consolidated Python tooling: Ruff owns linting/formatting/import-sorting,
  -- Pyright owns type-checking and hover (configured by the lang.python extra).
  --
  -- Guard: mason-lspconfig auto-enables any installed LSP that LazyVim doesn't
  -- explicitly disable. pylsp (pycodestyle + pyflakes) would double up on Ruff,
  -- so keep it off even if it ever gets reinstalled.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = { enabled = false },
      },
    },
  },

  -- Format and organize imports with Ruff on save.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },
}
