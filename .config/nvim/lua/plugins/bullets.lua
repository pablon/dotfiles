-- https://github.com/bullets-vim/bullets.vim
--
-- Automatically adds bulletpoints on the next line respecting indentation
-- In markdown or a text file start a bulleted list using - or *. Press return
-- to go to the next line, a new list item will be created.
-- When in insert mode, you can increase indentation with ctrl+t and decrease it
-- with ctrl+d
-- By default its enabled on filetypes 'markdown', 'text', 'gitcommit', 'scratch'

return {
  "bullets-vim/bullets.vim",
  ft = { "markdown", "text", "gitcommit", "scratch" },
}
