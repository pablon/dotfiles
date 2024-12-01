-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt -- option
local g = vim.g -- global

vim.wo.colorcolumn = "80"
-- opt.textwidth = 80
-- opt.linebreak = true

opt.scrolloff = 7
opt.ignorecase = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false

opt.hlsearch = true
opt.incsearch = true

opt.signcolumn = "yes"

opt.cursorline = true
opt.cursorcolumn = true

-- Fixes Notify opacity issues
opt.termguicolors = true

-- folding
opt.foldenable = true
--
-- opt.foldmethod = "expr"
-- opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--
-- opt.foldmethod = "manual"
--
opt.foldmethod = "indent"

-- scrolling
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8

-- indentation
opt.tabstop = 2 -- insert 2 spaces for a tab
opt.softtabstop = 2 -- insert 2 spaces for a tab
opt.expandtab = true -- convert tabs to spaces
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.smartindent = true -- smart indentation

-- completion
opt.completeopt = "menuone,noselect"
-- vim.o.timeoutlen = 300 -- time to wait for a mapped sequence to complete

-- windows
opt.splitbelow = true -- split: always split down
opt.splitright = true -- vsplit: always split right

opt.termguicolors = true
opt.signcolumn = "yes"
opt.isfname:append("@-@")

-- browser
g.mkdp_browser = "/Applications/Firefox.app/Contents/MacOS/firefox"
