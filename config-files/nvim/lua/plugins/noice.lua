return {
  {
    "folke/noice.nvim",
    opts = {
      -- Kill the bottom-right event-stream float. Its content is LSP
      -- progress ($/progress), which noice renders in the `mini` view;
      -- disabling progress removes the stream entirely.
      lsp = {
        progress = { enabled = false },
      },
    },
  },
}
