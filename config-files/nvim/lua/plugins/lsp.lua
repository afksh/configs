return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = {
          -- Pin diagnostics to a fixed window column so they line up in a
          -- neat left-aligned gutter clear of the code. Sits just past the
          -- colorcolumn guide at 80. spacing = 0 so text starts exactly at 81.
          virt_text_win_col = 81,
          spacing = 0,
        },
      },
    },
  },
}
