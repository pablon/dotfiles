-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Generic function to toggle any vim.opt
local function vim_opt_toggle(opt, on, off, name)
  local message = name
  if vim.opt[opt]:get() == off then
    vim.opt[opt] = on
    message = message .. " Enabled"
  else
    vim.opt[opt] = off
    message = message .. " Disabled"
  end
  vim.notify(message)
end

-- Togle paste mode
vim.keymap.set("n", "<F2>", function()
  vim_opt_toggle("paste", true, false, "Paste mode")
end)

-- enable/disable completion
vim.keymap.set("n", "<leader>p", '<cmd>lua require("cmp").setup { enabled = true }<cr>', { desc = "Enable completion" })
vim.keymap.set(
  "n",
  "<leader>P",
  '<cmd>lua require("cmp").setup { enabled = false }<cr>',
  { desc = "Disable completion" }
)

-- buffer resize
vim.keymap.set("n", "<leader><left>", ":vertical resize +20<cr>", { desc = "Vertical resize +20" })
vim.keymap.set("n", "<leader><right>", ":vertical resize -20<cr>", { desc = "Vertical resize +20" })
vim.keymap.set("n", "<leader><up>", ":resize +10<cr>", { desc = "Horizontal resize +10" })
vim.keymap.set("n", "<leader><down>", ":resize -10<cr>", { desc = "Horizontal resize -10" })

-- insert date in my desired configuration
vim.keymap.set("n", "<F3>", ":r!date<cr><ESC>o", { desc = "Insert date" })

-- lsp
vim.keymap.set("n", "<leader>S", "<cmd>LspStop<CR>", { desc = "LspStop" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp Hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Lsp Definition" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp Code Action" })

-- undotree
vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Undotree Toggle" })

-- surrounding words
vim.keymap.set("n", "<leader>wsq", 'ciw""<Esc>P', { desc = "Word Surround Quotes" })

-- replace backward slash
vim.keymap.set("n", "<leader>rbs", "<cmd>%s/\\//g<CR>", { desc = "Replace Backward Slash" })

-- telescope
vim.keymap.set("n", "<leader>tgb", "<cmd>Telescope git_branches<cr>", { desc = "Telescope git_branches" })
vim.keymap.set("n", "<leader>tgc", "<cmd>Telescope git_commits<cr>", { desc = "Telescope git_commits" })

-- telescope-symbols
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope symbols<cr>", { desc = "Find Symbols" })

-- convert Current line to title cases
-- vim.keymap.set("n", "<leader>rlt", "<cmd>s/<./\u&/g<cr>", { desc = "Replace Line Title" })
vim.keymap.set(
  "n",
  "<leader>rlt",
  "<cmd>lua require('textcase').current_word('to_title_case')<CR>",
  { desc = "Replace Line Title" }
)

-- these keep the cursor in the middle when scrolling with C-d and C-u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Start interactive EasyAlign
vim.keymap.set({ "n", "x" }, "<leader>al", "<Plug>(EasyAlign)", { desc = " Start EasyAlign" })

-- surround word with quotes
vim.keymap.set("n", "<leader>aq", 'ciw""<Esc>P', { desc = "Add Surround Quotes" })

-- Obsidian
-- vim.keymap.set("n", "<leader>oc", "<cmd>lua require('obsidian').util.toggle_checkbox()<CR>", { desc = "Obsidian Checkbox" })
vim.keymap.set("n", "<leader>onN", "<cmd>Obsidian new_from_template<CR>", { desc = "Create New Note From Template" })
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<CR>", { desc = "Show picker list of backlinks" })
vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<CR>", { desc = "Cycle through checkbox options" })
vim.keymap.set("n", "<leader>od", "<cmd>Obsidian dailies<CR>", { desc = "Insert new Daily note" })
vim.keymap.set("n", "<leader>oe", "<cmd>Obsidian extract_note<CR>", { desc = "Extract selected text into a new note" })
vim.keymap.set(
  "n",
  "<leader>of",
  "<cmd>Obsidian follow_link vsplit_force<CR>",
  { desc = "Follow a note reference under the cursor" }
)
vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<CR>", { desc = "Collect all links in the current buffer" })
vim.keymap.set("n", "<leader>onn", "<cmd>Obsidian new<CR>", { desc = "Create New Note" })
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<CR>", { desc = "Open in Obsidian App" })
vim.keymap.set("n", "<leader>op", "<cmd>Obsidian template<CR>", { desc = "Insert Obsidian Template" })
vim.keymap.set("n", "<leader>oq", "<cmd>Obsidian quick_switch<CR>", { desc = "Quick Switch" })
vim.keymap.set("n", "<leader>oss", "<cmd>Obsidian search<CR>", { desc = "Search Obsidian" })
vim.keymap.set("n", "<leader>ost", "<cmd>Obsidian tags<CR>", { desc = "Search Obsidian notes by Tags" })
vim.keymap.set("n", "<leader>oT", "<cmd>Obsidian toc<CR>", { desc = "Load the table of contents into a picker list" })

-------------------------------------------------------------------------------
-- markdown section
-------------------------------------------------------------------------------

-- markdown-preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview" })

-- markdown-toc
vim.keymap.set("n", "<leader>mti", "<cmd>Mtoc insert<cr>", { desc = "Markdown TOC Insert" })
vim.keymap.set("n", "<leader>mtu", "<cmd>Mtoc update<cr>", { desc = "Markdown TOC Update" })
vim.keymap.set("n", "<leader>mtr", "<cmd>Mtoc remove<cr>", { desc = "Markdown TOC Remove" })

-- render-markdown
vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", { desc = "RenderMarkdown toggle" })

-- to list
vim.keymap.set({ "n", "v" }, "<leader>mlu", "<cmd>'<,'>s/^/- /<cr><esc>", { desc = "Markdown list bullet" })
-- to numbered list
vim.keymap.set({ "n", "v" }, "<leader>mln", "<cmd>'<,'>s/^/1. /<cr><esc>", { desc = "Markdown list numbered" })
-- to checkboxes
vim.keymap.set({ "n", "v" }, "<leader>mlc", "<cmd>'<,'>s/^/- [ ] /<cr><esc>", { desc = "Markdown list checkbox" })

-------------------------------------------------------------------------------
-- folding section (borrowed from https://github.com/linkarzu)
-------------------------------------------------------------------------------

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
    vim.cmd("normal! zz") -- center the cursor line on screen
  end
end, { desc = "[P]Toggle fold" })

local function set_foldmethod_expr()
  -- These are lazyvim.org defaults but setting them just in case a file
  -- doesn't have them set
  if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.require'lazyvim.util'.treesitter.foldexpr()"
    vim.opt.foldtext = ""
  else
    vim.opt.foldmethod = "indent"
    vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
  end
  vim.opt.foldlevel = 99
end

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd("normal! za")
      end
    end
  end
end

local function fold_markdown_headings(levels)
  set_foldmethod_expr()
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- Keymap for unfolding markdown headings of level 2 or above
-- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- zj, zk, zl, z; and zu respectively lamw25wmal
vim.keymap.set("n", "zu", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Unfold all headings level 2 or above" })

-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
vim.keymap.set("n", "zi", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- Difference between normal and normal!
  -- - `normal` executes the command and respects any mappings that might be defined.
  -- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
  vim.cmd("normal gk")
  -- This is to fold the line under the cursor
  vim.cmd("normal! za")
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold the heading cursor currently on" })

-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "zj", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otheriise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 1 or above" })

-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "zk", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "zl", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 3 or above" })

-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "z;", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 4 or above" })

-------------------------------------------------------------------------------
-- End Folding section
-------------------------------------------------------------------------------
