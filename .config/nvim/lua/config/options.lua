-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local cmd = vim.cmd -- command
local opt = vim.opt -- option
local g = vim.g -- global

-- all
opt.autoindent = true -- copy indentation on new line
opt.backup = false -- no backup
opt.colorcolumn = "80"
opt.completeopt = "menuone,noselect"
opt.conceallevel = 2
opt.cursorcolumn = true
opt.cursorline = true
opt.expandtab = true -- convert tabs to spaces
opt.formatoptions:remove("t") -- no auto-intent of line breaks, keep line wrap enabled
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.isfname:append("@-@")
opt.laststatus = 3 -- avante: views can only be fully collapsed with the global statusline
opt.list = true -- show tab characters and trailing whitespace
opt.listchars = "tab:»\\ ,extends:›,precedes:‹,nbsp:·,trail:·" -- show tab characters and trailing whitespace
opt.number = true
opt.relativenumber = true
opt.scrolloff = 7
opt.shiftwidth = 0 -- the number of spaces inserted for each indentation
opt.signcolumn = "yes"
opt.smartindent = true -- smart indentation
opt.softtabstop = 2 -- insert 2 spaces for a tab
opt.spelllang = { "en,es" }
opt.splitbelow = true -- split: always split down
opt.splitright = true -- vsplit: always split right
opt.swapfile = false
opt.tabstop = 2 -- insert 2 spaces for a tab
opt.termguicolors = true -- Fixes Notify opacity issues
opt.textwidth = 100
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- set directory where undo files are stored
opt.undofile = true -- save undo history to a file
opt.wrap = false -- do not wrap lines
opt.writebackup = false -- no backup

-- folding
opt.foldenable = true
opt.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"

-- browser
-- g.mkdp_browser = "safari"
-- g.mkdp_browser = "google-chrome"
g.mkdp_browser = "firefox"
