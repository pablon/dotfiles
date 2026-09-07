-- https://github.com/spacedentist/resolve.nvim
--
-- A Neovim plugin for resolving merge conflicts with ease.

return {
  "spacedentist/resolve.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}
