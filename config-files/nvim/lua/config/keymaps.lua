-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Half-page scrolling with Shift+Up/Down
vim.keymap.set('n', '<S-Up>', '<C-u>', { noremap = true, desc = 'Half-page up' })
vim.keymap.set('n', '<S-Down>', '<C-d>', { noremap = true, desc = 'Half-page down' })
