-- https://github.com/hedyhli/markdown-toc.nvim
-- Generate and update table of contents list (with links) for markdown.
return {
  "hedyhli/markdown-toc.nvim",
  ft = "markdown", -- Lazy load on markdown filetype
  cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
  opts = {
    toc_list = {
      markers = "-",
      indent_size = function()
        return vim.bo.shiftwidth
      end,
    },
    headings = {
      exclude = { "CHANGELOG", "INDEX", "Index", "License" },
    },
  },
}
