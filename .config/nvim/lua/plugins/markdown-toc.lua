-- https://github.com/hedyhli/markdown-toc.nvim
-- Generate and update table of contents list (with links) for markdown.
--
-- Default keybindings:
-- <leader>mti - Insert table of contents
-- <leader>mtu - Update existing table of contents
-- <leader>mtr - Remove table of contents

return {
  "hedyhli/markdown-toc.nvim",
  ft = "markdown", -- Lazy load on markdown filetype
  cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
  opts = {
    toc_list = {
      markers = "-",
    },
    headings = {
      exclude = { "CHANGELOG", "INDEX", "Index", "License" },
    },
  },
  keys = {
    { "<leader>mti", "<cmd>Mtoc insert<CR>", desc = "Insert Markdown TOC" },
    { "<leader>mtu", "<cmd>Mtoc update<CR>", desc = "Update Markdown TOC" },
    { "<leader>mtr", "<cmd>Mtoc remove<CR>", desc = "Remove Markdown TOC" },
  },
}
