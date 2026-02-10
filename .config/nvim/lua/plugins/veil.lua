-- https://github.com/Gentleman-Programming/veil.nvim
-- Hide your secrets. Stream with confidence.

return {
  "Gentleman-Programming/veil.nvim",
  config = function()
    require("veil").setup({
      highlight = { fg = "#f1e89d" },
    })
  end,
}
