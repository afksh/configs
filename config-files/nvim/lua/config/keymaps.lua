-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Half-page scrolling with Shift+Up/Down
vim.keymap.set('n', '<S-Up>', '<C-u>', { noremap = true, desc = 'Half-page up' })
vim.keymap.set('n', '<S-Down>', '<C-d>', { noremap = true, desc = 'Half-page down' })

-- Save on escape, on top of LazyVim's default clear-hlsearch/stop-snippet behavior
vim.keymap.set({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('noh')
  LazyVim.cmp.actions.snippet_stop()
  if vim.bo.modifiable and vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
    vim.cmd('silent! update')
  end
  return '<esc>'
end, { expr = true, desc = 'Escape, Clear hlsearch, and Save' })
