-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

opt.colorcolumn = "80"
opt.completeopt = "menuone,noselect"
opt.conceallevel = 2
opt.cursorcolumn = true
opt.formatoptions:remove("t")
opt.isfname:append("@-@")
opt.laststatus = 3
opt.list = true
opt.listchars = "tab:»\\ ,extends:›,precedes:‹,nbsp:·,trail:·"
opt.scrolloff = 7
opt.shiftwidth = 0
opt.softtabstop = 2
opt.spelllang = { "en,es" }
opt.swapfile = false
opt.tabstop = 2
opt.textwidth = 100
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- folding
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'lazyvim.util'.treesitter.foldexpr()"

-- browser
-- g.mkdp_browser = "safari"
-- g.mkdp_browser = "google-chrome"
g.mkdp_browser = "firefox"
