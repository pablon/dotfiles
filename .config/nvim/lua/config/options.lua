-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt -- option
local g = vim.g -- global

vim.wo.colorcolumn = "80"

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

-- ############################################################################
-- :highlight CursorColumn ctermfg=White ctermbg=Yellow cterm=bold guifg=white guibg=yellow gui=bold
-- If you also need to highlight the current line, use CursorLine.

-- NO FUNCIONA:
-- g.ctermbg = "DarkGray"
-- g.guibg = "DarkGray"

-- NO FUNCIONA:
-- opt.highlight.CursorColumn.ctermbg = "DarkGray"
-- opt.highlight.CursorColumn.guibg = "DarkGray"

-- ############################################################################

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

-- wrap / break
-- opt.textwidth = 80
-- opt.linebreak = true

-- indentation
opt.tabstop = 2 -- insert 2 spaces for a tab
opt.softtabstop = 2 -- insert 2 spaces for a tab
opt.expandtab = true -- convert tabs to spaces
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.smartindent = true -- smart indentation

-- completion
opt.completeopt = "menuone,noselect"

-- windows
opt.splitbelow = true -- split: always split down
opt.splitright = true -- vsplit: always split right

-- completion
-- vim.o.timeoutlen = 300 -- time to wait for a mapped sequence to complete
--
-- g.vim_markdown_conceal = 0
-- opt.vim_markdown_conceal = 0

-- try this: vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

g.mkdp_browser = "/Applications/Firefox.app/Contents/MacOS/firefox"

-- g.lazygit_config = false

opt.termguicolors = true
opt.signcolumn = "yes"
opt.isfname:append("@-@")
