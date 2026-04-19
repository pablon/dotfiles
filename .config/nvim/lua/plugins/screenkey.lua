-- https://github.com/NStefan002/screenkey.nvim
-- Neovim plugin that displays the keys you are typing in a floating window

return {
  "NStefan002/screenkey.nvim",
  version = "*",
  cmd = "Screenkey",
  keys = {
    { "<leader>k", "<cmd>Screenkey toggle<CR>", desc = "Screenkey toggle" },
  },
  opts = {
    disable = {
      buftypes = { "terminal" },
    },
  },
}
