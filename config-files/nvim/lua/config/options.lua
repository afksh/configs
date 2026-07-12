-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Indentation (override LazyVim's default of 2)
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- Visual
vim.opt.encoding = "utf-8"
vim.opt.termguicolors = true
vim.opt.cursorcolumn = true
vim.opt.colorcolumn = "80"
vim.opt.showmatch = true
vim.opt.title = true
vim.opt.scrolloff = 8

-- Use Treesitter for all syntax highlighting, disable Vim defaults
vim.opt.syntax = "OFF"

-- Clipboard (sync with macOS clipboard)
vim.opt.clipboard = "unnamedplus"
