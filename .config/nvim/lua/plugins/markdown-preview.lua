-- https://github.com/iamcco/markdown-preview.nvim
-- Preview Markdown in your modern browser with synchronised scrolling and flexible configuration.
return {
  "iamcco/markdown-preview.nvim",
  keys = {
    {
      "<leader>mp",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
}
