-- https://github.com/NStefan002/screenkey.nvim
-- Neovim plugin that displays the keys you are typing in a floating window

return {
  "NStefan002/screenkey.nvim",
  lazy = false,
  version = "*",
  config = function()
    require("screenkey").setup({
      disable = {
        buftypes = { "terminal" },
      },
    })

    vim.keymap.set({ "n" }, "<leader>k", "<cmd>Screenkey toggle<CR>", { desc = "Screenkey toggle" })
  end,
}
