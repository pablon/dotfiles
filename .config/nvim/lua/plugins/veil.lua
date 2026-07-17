-- https://github.com/Gentleman-Programming/veil.nvim
-- Hide your secrets. Stream with confidence.
--
-- Default keybindings:
-- <leader>sv - Toggle veil on/off
-- <leader>sp - Peek at value on current line

return {
  "Gentleman-Programming/veil.nvim",
  cmd = "Veil",
  event = "LazyFile",
  opts = {
    highlight = { fg = "#f1e89d" },
    extra_patterns = {
      -- *TOKEN* (case-sensitive): TOKEN anywhere in the key name
      { pattern = "([%w_]*TOKEN[%w_]*%s*[=:]%s*[\"']?)([^\"'\n]+)", group = 2 },
      -- *api*key (case-insensitive)
      { pattern = "([%w_]*[Aa][Pp][Ii][%w_]*[Kk][Ee][Yy]%s*[=:]%s*[\"']?)([^\"'\n]+)", group = 2 },
      -- *access*key (case-insensitive)
      { pattern = "([%w_]*[Aa][Cc][Cc][Ee][Ss][Ss][%w_]*[Kk][Ee][Yy]%s*[=:]%s*[\"']?)([^\"'\n]+)", group = 2 },
      -- *secret*key (case-insensitive)
      { pattern = "([%w_]*[Ss][Ee][Cc][Rr][Ee][Tt][%w_]*[Kk][Ee][Yy]%s*[=:]%s*[\"']?)([^\"'\n]+)", group = 2 },
    },
    keymaps = {
      toggle = "<leader>sv", -- Toggle veil on/off
      peek = "<leader>sp", -- Peek at value on current line
    },
  },
  keys = {
    { "<leader>sv", "<cmd>Veil<CR>", desc = "Toggle Veil" },
    { "<leader>sp", "<cmd>VeilPeek<CR>", desc = "Veil Peek" },
  },
}
